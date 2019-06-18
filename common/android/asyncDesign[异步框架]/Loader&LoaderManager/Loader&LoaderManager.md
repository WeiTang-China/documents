[TOC]

# 1、使用方法

Android 3.0 中引入了加载器，支持轻松在 Activity 或片段中异步加载数据。 加载器具有以下特征：

- 可用于每个 `Activity` 和 `Fragment`。
- 支持异步加载数据。
- 监控其数据源并在内容变化时传递新结果。
- 在某一配置更改后重建加载器时，会自动重新连接上一个加载器的游标。 因此，它们无需重新查询其数据。

## 1.1、Loader API 摘要

在应用中使用加载器时，可能会涉及到多个类和接口。 下表汇总了这些类和接口：

| 类/接口                         | 说明                                                         |
| ------------------------------- | ------------------------------------------------------------ |
| `LoaderManager`                 | 一种与 `Activity` 或 `Fragment` 相关联的的抽象类，用于管理一个或多个 `Loader` 实例。 这有助于应用管理与 `Activity` 或 `Fragment` 生命周期相关联的、运行时间较长的操作。它最常见的用法是与 `CursorLoader` 一起使用，但应用可自由写入其自己的加载器，用于加载其他类型的数据。   每个 Activity 或片段中只有一个 `LoaderManager`。但一个 `LoaderManager` 可以有多个加载器。 |
| `LoaderManager.LoaderCallbacks` | 一种回调接口，用于客户端与 `LoaderManager` 进行交互。例如，您可使用 `onCreateLoader()` 回调方法创建新的加载器。 |
| `Loader`                        | 一种执行异步数据加载的抽象类。这是加载器的基类。 您通常会使用 `CursorLoader`，但您也可以实现自己的子类。加载器处于活动状态时，应监控其数据源并在内容变化时传递新结果。 |
| `AsyncTaskLoader`               | 提供 `AsyncTask` 来执行工作的抽象加载器。                    |
| `CursorLoader`                  | `AsyncTaskLoader` 的子类，它将查询 `ContentResolver` 并返回一个 `Cursor`。此类采用标准方式为查询游标实现 `Loader` 协议。它是以 `AsyncTaskLoader` 为基础而构建，在后台线程中执行游标查询，以免阻塞应用的 UI。使用此加载器是从`ContentProvider` 异步加载数据的最佳方式，而不用通过片段或 Activity 的 API 来执行托管查询。 |

上表中的类和接口是您在应用中用于实现加载器的基本组件。 并非您创建的每个加载器都要用到上述所有类和接口。但是，为了初始化加载器以及实现一个 `Loader` 类（如 `CursorLoader`），您始终需要要引用 `LoaderManager`。 下文将为您展示如何在应用中使用这些类和接口。

## 1.2、启动加载器

`LoaderManager` 可在 `Activity` 或 `Fragment` 内管理一个或多个 `Loader` 实例。每个 Activity 或片段中只有一个 `LoaderManager`。

通常，您会在 Activity 的 `onCreate()` 方法或片段的`onActivityCreated()` 方法内初始化 `Loader`。您执行操作如下：

```java
// Prepare the loader.  Either re-connect with an existing one,
// or start a new one.
getLoaderManager().initLoader(0, null, this);
```

`initLoader()` 方法采用以下参数：

- 用于标识加载器的唯一 ID。在此示例中，ID 为 0。
- 在构建时提供给加载器的可选参数（在此示例中为 `null`）。
- `LoaderManager.LoaderCallbacks` 实现， `LoaderManager` 将调用此实现来报告加载器事件。在此示例中，本地类实现 `LoaderManager.LoaderCallbacks` 接口，因此它会传递对自身的引用 `this`。

`initLoader()` 调用确保加载器已初始化且处于活动状态。这可能会出现两种结果：

- 如果 ID 指定的加载器已存在，则将重复使用上次创建的加载器。
- 如果 ID 指定的加载器不存在，则 `initLoader()` 将触发 `LoaderManager.LoaderCallbacks` 方法 `onCreateLoader()`。在此方法中，您可以实现代码以实例化并返回新加载器。有关详细介绍，请参阅 [onCreateLoader](#1.4.1、onCreateLoader) 。

无论何种情况，给定的 `LoaderManager.LoaderCallbacks` 实现均与加载器相关联，且将在加载器状态变化时调用。如果在调用时，调用程序处于启动状态，且请求的加载器已存在并生成了数据，则系统将立即调用 `onLoadFinished()`（在 `initLoader()` 期间），因此您必须为此做好准备。 有关此回调的详细介绍，请参阅 [onLoadFinished](#1.4.2、onLoadFinished)。

请注意，`initLoader()` 方法将返回已创建的 `Loader`，但您不必捕获其引用。`LoaderManager` 将自动管理加载器的生命周期。`LoaderManager` 将根据需要启动和停止加载，并维护加载器的状态及其相关内容。 这意味着您很少直接与加载器进行交互（有关使用加载器方法调整加载器行为的示例，请参阅 [LoaderThrottle](https://developer.android.com/resources/samples/ApiDemos/src/com/example/android/apis/app/LoaderThrottle.html) 示例）。当特定事件发生时，您通常会使用 `LoaderManager.LoaderCallbacks` 方法干预加载进程。有关此主题的详细介绍，请参阅[使用 LoaderManager 回调](#1.4、使用 LoaderManager 回调)。

## 1.3、重启加载器

当您使用 `initLoader()` 时（如上所述），它将使用含有指定 ID 的现有加载器（如有）。如果没有，则它会创建一个。但有时，您想舍弃这些旧数据并重新开始。

要舍弃旧数据，请使用 `restartLoader()`。例如，当用户的查询更改时，此 `SearchView.OnQueryTextListener` 实现将重启加载器。 加载器需要重启，以便它能够使用修订后的搜索过滤器执行新查询：

```java
public boolean onQueryTextChanged(String newText) {
    // Called when the action bar search text has changed.  Update
    // the search filter, and restart the loader to do a new query
    // with this filter.
    mCurFilter = !TextUtils.isEmpty(newText) ? newText : null;
    getLoaderManager().restartLoader(0, null, this);
    return true;
}
```

## 1.4、使用 LoaderManager 回调

`LoaderManager.LoaderCallbacks` 是一个支持客户端与 `LoaderManager` 交互的回调接口。

加载器（特别是 `CursorLoader`）在停止运行后，仍需保留其数据。这样，应用即可保留 Activity 或片段的 `onStop()` 和 `onStart()` 方法中的数据。当用户返回应用时，无需等待它重新加载这些数据。您可使用 `LoaderManager.LoaderCallbacks` 方法了解何时创建新加载器，并告知应用何时停止使用加载器的数据。

`LoaderManager.LoaderCallbacks` 包括以下方法：

- `onCreateLoader()`：针对指定的 ID 进行实例化并返回新的 `Loader`

- `onLoadFinished()` ：将在先前创建的加载器完成加载时调用

- `onLoaderReset()`：将在先前创建的加载器重置且其数据因此不可用时调用

### 1.4.1、onCreateLoader

当您尝试访问加载器时（例如，通过 `initLoader()`），该方法将检查是否已存在由该 ID 指定的加载器。 如果没有，它将触发 `LoaderManager.LoaderCallbacks` 方法 `onCreateLoader()`。在此方法中，您可以创建新加载器。 通常，这将是 `CursorLoader`，但您也可以实现自己的 `Loader` 子类。

在此示例中，`onCreateLoader()` 回调方法创建了 `CursorLoader`。您必须使用其构造函数方法来构建 `CursorLoader`。该方法需要对 `ContentProvider` 执行查询时所需的一系列完整信息。具体地说，它需要：

- *uri*：用于检索内容的 URI
- *projection*：要返回的列的列表。传递 `null` 时，将返回所有列，这样会导致效率低下
- *selection*：一种用于声明要返回哪些行的过滤器，采用 SQL WHERE 子句格式（WHERE 本身除外）。传递 `null` 时，将为指定的 URI 返回所有行
- *selectionArgs*：您可以在 selection 中包含 ?s，它将按照在 selection 中显示的顺序替换为 *selectionArgs* 中的值。该值将绑定为字串符
- *sortOrder*：行的排序依据，采用 SQL ORDER BY 子句格式（ORDER BY 自身除外）。传递 `null` 时，将使用默认排序顺序（可能并未排序）

例如：

```java
 // If non-null, this is the current filter the user has provided.
String mCurFilter;
...
public Loader<Cursor> onCreateLoader(int id, Bundle args) {
    // This is called when a new Loader needs to be created.  This
    // sample only has one Loader, so we don't care about the ID.
    // First, pick the base URI to use depending on whether we are
    // currently filtering.
    Uri baseUri;
    if (mCurFilter != null) {
        baseUri = Uri.withAppendedPath(Contacts.CONTENT_FILTER_URI,
                  Uri.encode(mCurFilter));
    } else {
        baseUri = Contacts.CONTENT_URI;
    }

    // Now create and return a CursorLoader that will take care of
    // creating a Cursor for the data being displayed.
    String select = "((" + Contacts.DISPLAY_NAME + " NOTNULL) AND ("
            + Contacts.HAS_PHONE_NUMBER + "=1) AND ("
            + Contacts.DISPLAY_NAME + " != '' ))";
    return new CursorLoader(getActivity(), baseUri,
            CONTACTS_SUMMARY_PROJECTION, select, null,
            Contacts.DISPLAY_NAME + " COLLATE LOCALIZED ASC");
}
```

### 1.4.2、onLoadFinished

当先前创建的加载器完成加载时，将调用此方法。该方法必须在为此加载器提供的最后一个数据释放之前调用。 此时，您应移除所有使用的旧数据（因为它们很快会被释放），但不要自行释放这些数据，因为这些数据归其加载器所有，其加载器会处理它们。

当加载器发现应用不再使用这些数据时，即会释放它们。 例如，如果数据是来自 `CursorLoader` 的一个游标，则您不应手动对其调用 `close()`。如果游标放置在 `CursorAdapter` 中，则应使用 `swapCursor()` 方法，使旧 `Cursor` 不会关闭。例如：

```java
// This is the Adapter being used to display the list's data.
SimpleCursorAdapter mAdapter;
...

public void onLoadFinished(Loader<Cursor> loader, Cursor data) {
    // Swap the new cursor in.  (The framework will take care of closing the
    // old cursor once we return.)
    mAdapter.swapCursor(data);
}
```

### 1.4.3、onLoaderReset

此方法将在先前创建的加载器重置且其数据因此不可用时调用。 通过此回调，您可以了解何时将释放数据，因而能够及时移除其引用。  

此实现调用值为 `null` 的`swapCursor()`：

```java
// This is the Adapter being used to display the list's data.
SimpleCursorAdapter mAdapter;
...

public void onLoaderReset(Loader<Cursor> loader) {
    // This is called when the last Cursor provided to onLoadFinished()
    // above is about to be closed.  We need to make sure we are no
    // longer using it.
    mAdapter.swapCursor(null);
}
```

## 1.5、完整示例

以下是一个 `Fragment` 完整实现示例。它展示了一个 `ListView`，其中包含针对联系人内容提供程序的查询结果。它使用 `CursorLoader` 管理提供程序的查询。

应用如需访问用户联系人（如此示例中所示），其清单文件必须包括权限 `READ_CONTACTS`。

```java
public static class CursorLoaderListFragment extends ListFragment
        implements OnQueryTextListener, LoaderManager.LoaderCallbacks<Cursor> {

    // This is the Adapter being used to display the list's data.
    SimpleCursorAdapter mAdapter;

    // If non-null, this is the current filter the user has provided.
    String mCurFilter;

    @Override public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        // Give some text to display if there is no data.  In a real
        // application this would come from a resource.
        setEmptyText("No phone numbers");

        // We have a menu item to show in action bar.
        setHasOptionsMenu(true);

        // Create an empty adapter we will use to display the loaded data.
        mAdapter = new SimpleCursorAdapter(getActivity(),
                android.R.layout.simple_list_item_2, null,
                new String[] { Contacts.DISPLAY_NAME, Contacts.CONTACT_STATUS },
                new int[] { android.R.id.text1, android.R.id.text2 }, 0);
        setListAdapter(mAdapter);

        // Prepare the loader.  Either re-connect with an existing one,
        // or start a new one.
        getLoaderManager().initLoader(0, null, this);
    }

    @Override public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        // Place an action bar item for searching.
        MenuItem item = menu.add("Search");
        item.setIcon(android.R.drawable.ic_menu_search);
        item.setShowAsAction(MenuItem.SHOW_AS_ACTION_IF_ROOM);
        SearchView sv = new SearchView(getActivity());
        sv.setOnQueryTextListener(this);
        item.setActionView(sv);
    }

    public boolean onQueryTextChange(String newText) {
        // Called when the action bar search text has changed.  Update
        // the search filter, and restart the loader to do a new query
        // with this filter.
        mCurFilter = !TextUtils.isEmpty(newText) ? newText : null;
        getLoaderManager().restartLoader(0, null, this);
        return true;
    }

    @Override public boolean onQueryTextSubmit(String query) {
        // Don't care about this.
        return true;
    }

    @Override public void onListItemClick(ListView l, View v, int position, long id) {
        // Insert desired behavior here.
        Log.i("FragmentComplexList", "Item clicked: " + id);
    }

    // These are the Contacts rows that we will retrieve.
    static final String[] CONTACTS_SUMMARY_PROJECTION = new String[] {
        Contacts._ID,
        Contacts.DISPLAY_NAME,
        Contacts.CONTACT_STATUS,
        Contacts.CONTACT_PRESENCE,
        Contacts.PHOTO_ID,
        Contacts.LOOKUP_KEY,
    };
    public Loader<Cursor> onCreateLoader(int id, Bundle args) {
        // This is called when a new Loader needs to be created.  This
        // sample only has one Loader, so we don't care about the ID.
        // First, pick the base URI to use depending on whether we are
        // currently filtering.
        Uri baseUri;
        if (mCurFilter != null) {
            baseUri = Uri.withAppendedPath(Contacts.CONTENT_FILTER_URI,
                    Uri.encode(mCurFilter));
        } else {
            baseUri = Contacts.CONTENT_URI;
        }

        // Now create and return a CursorLoader that will take care of
        // creating a Cursor for the data being displayed.
        String select = "((" + Contacts.DISPLAY_NAME + " NOTNULL) AND ("
                + Contacts.HAS_PHONE_NUMBER + "=1) AND ("
                + Contacts.DISPLAY_NAME + " != '' ))";
        return new CursorLoader(getActivity(), baseUri,
                CONTACTS_SUMMARY_PROJECTION, select, null,
                Contacts.DISPLAY_NAME + " COLLATE LOCALIZED ASC");
    }

    public void onLoadFinished(Loader<Cursor> loader, Cursor data) {
        // Swap the new cursor in.  (The framework will take care of closing the
        // old cursor once we return.)
        mAdapter.swapCursor(data);
    }

    public void onLoaderReset(Loader<Cursor> loader) {
        // This is called when the last Cursor provided to onLoadFinished()
        // above is about to be closed.  We need to make sure we are no
        // longer using it.
        mAdapter.swapCursor(null);
    }
}
```



# 2、细节分析

## 2.1、系统如何管理LoaderManager的实例？

每一个Activity实例唯一对应一个LoaderManager对象，如下代码所示（核心代码片段）：

```java
public LoaderManager getSupportLoaderManager() {
    if (mLoaderManager == null) {
        mLoaderManager = getLoaderManager("(root)", mLoadersStarted, true);
    }
    return mLoaderManager;
}

SimpleArrayMap<String, LoaderManagerImpl> mAllLoaderManagers;

LoaderManagerImpl getLoaderManager(String who, boolean started, boolean create) {
    LoaderManagerImpl lm = mAllLoaderManagers.get(who);
    if (lm == null) {
        lm = new LoaderManagerImpl(who, this, started);
        mAllLoaderManagers.put(who, lm);
    } else {
        lm.updateActivity(this);
    }
    return lm;
}
```

每一个Fragment实际调用的也是Activity.getLoaderManager()方法，如下代码所示：

```java
public LoaderManager getLoaderManager() {
    if (mLoaderManager == null) {
        mLoaderManager = mActivity.getLoaderManager(mWho, mLoadersStarted, true);
    }
    return mLoaderManager;
}
```

Fragment.mWho是什么？可能会重复吗？

当然不会重复，拼接值的规则为 android:fragment:%mIndex%，例如下图所示：

![fragment_who](C:\Users\teddymobile\Desktop\tangwei\github-documents\common\android\asyncDesign[异步框架]\Loader&LoaderManager\files\fragment_who.png)



## 2.2、LoaderManager的实例如何与Activity的生命周期绑定在一起的？

LoaderManager提供了一系列的生命周期状态切换函数：

1. `doStart()`会将LoaderManager中保存的全部Loader都启动，最终执行每个已经initLoader过的onStartLoading()方法。
2. `doReportStart()`。假设Fragment上一次在销毁并重做，并且数据有效的话会在这里主动上报数据，最终走到callback的`onLoadFinished`中。
3. `doStop()`会停止mLoaders保存的全部Loader。最终执行每个Loader的`onStopLoading()`方法。
4. `doDestroy()`会清空全部有效和无效Loader。LoaderManager中不再存在Loader。
5. `doRetain()`会将LoaderManager的mRetaining状态置位true。并且保存retain时LoaderInfo的mStarted状态。
6. `finishRetain()`假设之前所保存的mStarted与如今的不一样并且新的状态是停止的话。就停止掉这个Loader。否则若有数据并且不是要下次再上报（没有call
    doReportNextStart）的话就上报给callback的`onLoadFinished`。
7. `doReportNextStart()`。依据第6条，已经可以理解了。当Fragment运行到onDestroyView生命周期时，对自己的LoaderManager发出请求：`即使如今有数据也不要进行上报。等我重做再到onStart生命周期时再给我`。

LoaderManager唯一对应的Owner在自己的声明周期函数中会调用这些切换函数，以Fragment举例说明：

1. onStart()中调用了mLoaderManager.doStart()
2. onDestroy()中调用了mLoaderManager.doDestroy()
3. performReallyStop()中，如果mActivity.mRetaining则调用mLoaderManager.doRetain()；否则调用mLoaderManager.doStop()
4. performStart()中调用了mLoaderManager.doReportStart()
5. performDestroyView()中调用了mLoaderManager.doReportNextStart()

例如下面的生命周期序列：

正常的从出生到销毁：

```java
doStart() -> doReportStart() -> doStop() -> doDestroy()
```

Activity配置发生变化：

```java
doStart() -> doRetain() -> finishRetain() -> doReportStart() -> doStart() -> doStop() -> doDestroy()
```

Fragment在onDestroyView()之后还会运行LoaderManager的doReportNextStart(), 即：

```java
doStart() -> doRetain() -> doReportNextStart() -> finishRetain() -> doReportStart() -> doStart() -> doStop() -> doDestroy()
```



## 2.3、LoaderManager如何区分不同的Loader？

下面我们来看看LoaderManager相关的类结构：

![](files\LoaderManager_classesDiagram.png)

initLoader时传入的id作为外部唯一标识

内部使用LoaderInfo判断



# 3、使用技巧

## 3.1、通过dump指令查看当前Loader状态

adb shell dumpsys activity %包名%

![](files\dumpsys_activity.png)















# References

- [官方文档](https://developer.android.com/guide/components/loaders.html)