# Paging Library

## Paging library overview

Paging库可帮助您一次加载和显示小块数据。按需加载部分数据可减少网络带宽和系统资源的使用。

本指南提供了paging库的几个概念性示例，以及它如何工作的概述。要查看paging库如何工作的完整示例，请尝试使用[additional resources](https://developer.android.com/topic/libraries/architecture/paging#additional-resources)部分中的codelab和示例。

### Library architecture

本节描述并展示了paging库的主要组件。

#### PagedList

Paging库的关键组件是[`PagedList`](https://developer.android.com/reference/androidx/paging/PagedList)类，它可以加载应用程序数据块或*页面*。由于需要更多数据，因此将其分页到现有的`PagedList`对象中。如果任何加载的数据发生更改，则会从`LiveData`或基于RxJava2的新的`PagedList`实例发送到可观察数据持有者对象。当生成`PagedList`对象时，应用程序的UI会显示其内容，同时遵守UI控制器的生命周期。

以下代码段展示了如何使用`PagedList`对象的`LiveData`持有者配置应用程序的view model以加载和显示数据：

```java
public class ConcertViewModel extends ViewModel {
    private ConcertDao concertDao;
    public final LiveData<PagedList<Concert>> concertList;

    // Creates a PagedList object with 50 items per page.
    public ConcertViewModel(ConcertDao concertDao) {
        this.concertDao = concertDao;
        concertList = new LivePagedListBuilder<>(
                concertDao.concertsByDate(), 50).build();
    }
}
```

#### Data

`PagedList`的每个实例从相应的`DataSource`对象加载应用程序数据的最新快照。数据从应用程序的后端或数据库流入`PagedList`对象。

以下示例使用[room库](https://developer.android.com/training/data-storage/room)来组织应用程序的数据，但如果要使用其他方式存储数据，还可以使用 [Build your own data sources](#Build your own data sources)。

```java
@Dao
public interface ConcertDao {
    // The Integer type parameter tells Room to use a
    // PositionalDataSource object.
    @Query("SELECT * FROM concerts ORDER BY date DESC")
    DataSource.Factory<Integer, Concert> concertsByDate();
}
```

要了解有关如何将数据加载到`PagedList`对象的更多信息，请参阅有关如何[Gather paged data](#Gather paged data)的指南。

#### UI

`PagedList`类使用`PagedListAdapter`将项目加载到[`RecyclerView`]。 这些类一起工作以在加载内容时获取和显示内容，预取视图内容并动画呈现内容变化。

获取更多信息，请参阅 [Display paged lists](#Display paged lists)。

### Support different data architectures

Paging库支持如下数据架构：

- 仅由后端服务器提供
- 仅存储在设备上的数据库中
- 使用设备上数据库作为缓存，并组合其他源

图1显示了每种架构方案中数据的流动方式。对于仅限网络或仅限数据库的解决方案，数据直接流向应用程序的UI模型。如果您使用的是组合方法，则数据会从后端服务器流入设备上的数据库，然后流入应用程序的UI模型。每隔一段时间，每个数据流的端点就会耗尽要加载的数据，此时它会从提供数据的组件请求更多数据。例如，当设备上数据库用完数据时，它会从服务器请求更多数据。

![Diagrams of data flows](files/paging-library-data-flow.webp)

**图1.** Paging库的数据流向图

本节的其余部分提供了配置每个数据流用例的建议。

#### Network only

要显示来自后端服务器的数据，可以使用[Retrofit API](http://square.github.io/retrofit/)的同步版本将信息加载到[您自己的自定义`DataSource`对象](#Build your own data sources)中。

**Note:** Paging库的`DataSource`对象不提供任何错误处理，因为不同的应用程序以不同的方式处理和呈现错误UI。一旦发生错误，将会回推给结果回调，你可以稍后重试该请求。有关此行为的示例，请参阅[PagingWithNetwork示例](https://github.com/googlesamples/android-architecture-components/tree/master/PagingWithNetworkSample)。

#### Database only

让`RecyclerView`观察本地存储，最好使用`Room库`。这样，无论何时在应用程序的数据库中插入或修改数据，这些更改都会自动反映在显示此数据的`RecyclerView`中。

#### Network and database

在开始观察数据库变化之后，您可以使用[`PagedList.BoundaryCallback`](https://developer.android.com/reference/androidx/paging/PagedList.BoundaryCallback)监听数据库何时没有数据。然后，您可以从网络中获取更多项目并将其插入数据库。如果您的UI正在观察数据库变化，如上这些操作都是需要做的。

### Handle network errors

当使用网络获取或分页您正在使用分页库显示的数据时，重要的是不要将网络视为“可用”或“不可用”，因为许多连接是间歇性的或片状的：

- 特定服务器可能无法响应网络请求。
- 设备可能连接到缓慢或信号弱的网络。

相反，应用应该检查每个失败请求，并在网络不可用的情况下尽可能优雅地恢复。例如，您可以提供“重试”按钮，由用户来选择数据刷新是否不能正常工作。如果在数据分页步骤期间发生错误，则最好自动重试分页请求。

### Update your existing app

如果您的app已经使用了数据库或后端源中的数据，则可以直接升级到Paging库提供的功能。本节介绍如何升级已存在的具有通用设计的app。

#### Custom paging solutions

如果您使用自定义功能从应用程序的数据源加载小的数据子集，则可以将此逻辑替换为`PagedList`类中的逻辑。`PagedList`的实例提供与公共数据源的内置连接。这些实例还为您可能包含在app UI中的`RecyclerView`对象提供adapter。

#### Data loaded using lists instead of pages

如果使用内存中的List作为UI adapter的后备数据结构，请考虑更换`PagedList`类来监视数据变化（例如List中的数量可能变大）。`PagedList`的实例可以使用`LiveData`或`Observable<List>`将数据变化传递到app的UI，从而最大限度地减少加载时间和内存使用量。更好的是，在app中用`PagedList`对象替换`List`对象不需要对应用程序的UI结构或数据变化逻辑进行任何更改。

#### Associate a data cursor with a list view using CursorAdapter

app可能使用`CursorAdapter`将来自`Cursor`的数据与`ListView`相关联。在这种情况下，通常需要从`ListView`迁移到`RecyclerView`作为app的列表UI容器，然后将`Cursor`组件替换为`Room`或`PositionalDataSource`，具体取决于`Cursor`的实例是否访问SQLite数据库。

在某些情况下，例如使用`Spinner`实例时，只提供adapter。然后，Paging库将获取加载到该adapter中的数据并为您显示数据。在这些情况下，将adapter数据的类型更改为`LiveData`，然后在尝试让Paging库的类在UI中对item进行inflate之前，将此列表包装在“ArrayAdapter”对象中。

#### Load content asynchronously using AsyncListUtil

如果使用[`AsyncListUtil`](https://developer.android.com/reference/androidx/recyclerview/widget/AsyncListUtil)对象异步加载和显示信息组，则Paging库可让您更轻松地加载数据：

- **数据不是位置强相关的。`Your data doesn't need to be positional.`** Paging库允许使用网络提供的密钥直接从后端加载数据。
- **数据可能非常大。** 使用Paging库，可以一页一页地加载数据，直到没有剩余数据。
- **可以更轻松地observe数据变化。** Paging库可以展示被app的ViewModel持有的数据，在一个observable的数据结构中。

**Note:** 如果现有app使用SQLite数据库，请参阅[使用Room持久性库](https://developer.android.com/topic/libraries/architecture/room)部分。

### Database examples

以下代码片段显示了使所有部分协同工作的几种可能方法。

#### Observing paged data using LiveData

以下代码段显示了一起工作的所有代码。当在数据库中添加、删除或更改音乐会事件时，`RecyclerView`中的内容将自动高效地更新：

```java
@Dao
public interface ConcertDao {
    // The Integer type parameter tells Room to use a PositionalDataSource
    // object, with position-based loading under the hood.
    @Query("SELECT * FROM concerts ORDER BY date DESC")
    DataSource.Factory<Integer, Concert> concertsByDate();
}

public class ConcertViewModel extends ViewModel {
    private ConcertDao concertDao;
    public final LiveData<PagedList<Concert>> concertList;

    public ConcertViewModel(ConcertDao concertDao) {
        this.concertDao = concertDao;
        concertList = new LivePagedListBuilder<>(
            concertDao.concertsByDate(), /* page size */ 50).build();
    }
}

public class ConcertActivity extends AppCompatActivity {
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ConcertViewModel viewModel =
                ViewModelProviders.of(this).get(ConcertViewModel.class);
        RecyclerView recyclerView = findViewById(R.id.concert_list);
        ConcertAdapter adapter = new ConcertAdapter();
        viewModel.concertList.observe(this, adapter::submitList);
        recyclerView.setAdapter(adapter);
    }
}

public class ConcertAdapter
        extends PagedListAdapter<Concert, ConcertViewHolder> {
    protected ConcertAdapter() {
        super(DIFF_CALLBACK);
    }

    @Override
    public void onBindViewHolder(@NonNull ConcertViewHolder holder,
            int position) {
        Concert concert = getItem(position);
        if (concert != null) {
            holder.bindTo(concert);
        } else {
            // Null defines a placeholder item - PagedListAdapter automatically
            // invalidates this row when the actual object is loaded from the
            // database.
            holder.clear();
        }
    }

    private static DiffUtil.ItemCallback<Concert> DIFF_CALLBACK =
            new DiffUtil.ItemCallback<Concert>() {
        // Concert details may have changed if reloaded from the database,
        // but ID is fixed.
        @Override
        public boolean areItemsTheSame(Concert oldConcert, Concert newConcert) {
            return oldConcert.getId() == newConcert.getId();
        }

        @Override
        public boolean areContentsTheSame(Concert oldConcert,
                Concert newConcert) {
            return oldConcert.equals(newConcert);
        }
    };
}
```

#### Observing paged data using RxJava2

如果您更喜欢使用[`RxJava2`](https://github.com/ReactiveX/RxJava)而不是`LiveData`，可以改为创建一个`Observable`或`Flowable` object：

```java
public class ConcertViewModel extends ViewModel {
    private ConcertDao concertDao;
    public final Observable<PagedList<Concert>> concertList;

    public ConcertViewModel(ConcertDao concertDao) {
        this.concertDao = concertDao;

        concertList = new RxPagedListBuilder<>(
                concertDao.concertsByDate(), /* page size */ 50)
                        .buildObservable();
    }
}
```

然后，可以使用以下代码开始和停止observe数据：

```java
public class ConcertActivity extends AppCompatActivity {
    private ConcertAdapter adapter = new ConcertAdapter();
    private ConcertViewModel viewModel;

    private CompositeDisposable disposable = new CompositeDisposable();

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        RecyclerView recyclerView = findViewById(R.id.concert_list);

        viewModel = ViewModelProviders.of(this).get(ConcertViewModel.class);
        recyclerView.setAdapter(adapter);
    }

    @Override
    protected void onStart() {
        super.onStart();
        disposable.add(viewModel.concertList
                .subscribe(adapter.submitList(flowableList)
        ));
    }

    @Override
    protected void onStop() {
        super.onStop();
        disposable.clear();
    }
}
```

`ConcertDao`和`ConcertAdapter`的代码与[RxJava2](https://github.com/ReactiveX/RxJava解决方案的代码相同，因为它们适用于基于`LiveData`的解决方案。



## Display paged lists

This guide builds upon the [Paging Library overview](https://developer.android.com/topic/libraries/architecture/paging/index), describing how you can present lists of information to users in your app's UI, particularly when this information changes.

### Connect your UI to your view model

You can connect an instance of [`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData) to a [`PagedListAdapter`](https://developer.android.com/reference/androidx/paging/PagedListAdapter), as shown in the following code snippet:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/paging/ui#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/paging/ui#java)

```java
public class ConcertActivity extends AppCompatActivity {
    private ConcertAdapter adapter = new ConcertAdapter();
    private ConcertViewModel viewModel;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        viewModel = ViewModelProviders.of(this).get(ConcertViewModel.class);
        viewModel.concertList.observe(this, adapter::submitList);
    }
}
```



As data sources provide new instances of [`PagedList`](https://developer.android.com/reference/androidx/paging/PagedList), the activity sends these objects to the adapter. The[`PagedListAdapter`](https://developer.android.com/reference/androidx/paging/PagedListAdapter) implementation defines how updates are computed, and it automatically handles paging and list diffing. Therefore, your [`ViewHolder`](https://developer.android.com/reference/androidx/recyclerview/widget/RecyclerView.ViewHolder) only needs to bind to a particular provided item:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/paging/ui#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/paging/ui#java)

```java
public class ConcertAdapter
        extends PagedListAdapter<Concert, ConcertViewHolder> {
    protected ConcertAdapter() {
        super(DIFF_CALLBACK);
    }

    @Override
    public void onBindViewHolder(@NonNull ConcertViewHolder holder,
            int position) {
        Concert concert = getItem(position);

        // Note that "concert" can be null if it's a placeholder.
        holder.bindTo(concert);
    }

    private static DiffUtil.ItemCallback<Concert> DIFF_CALLBACK
            = ... // See Implement the diffing callback section.
}
```



The [`PagedListAdapter`](https://developer.android.com/reference/androidx/paging/PagedListAdapter) handles page load events using a [`PagedList.Callback`](https://developer.android.com/reference/androidx/paging/PagedList.Callback) object. As the user scrolls, the `PagedListAdapter` calls [`PagedList.loadAround()`](https://developer.android.com/reference/androidx/paging/PagedList#loadaround) to provide hints to the underlying [`PagedList`](https://developer.android.com/reference/androidx/paging/PagedList) as to which items it should fetch from the [`DataSource`](https://developer.android.com/reference/androidx/paging/DataSource).

**Note:** [`PagedList`](https://developer.android.com/reference/androidx/paging/PagedList) is content-immutable. This means that, although new content can be loaded into an instance of `PagedList`, the loaded items themselves cannot change once loaded. As such, if content in a `PagedList` updates, the[`PagedListAdapter`](https://developer.android.com/reference/androidx/paging/PagedListAdapter) object receives a completely new `PagedList` that contains the updated information.

### Implement the diffing callback

The following sample shows a manual implementation of [`areContentsTheSame()`](https://developer.android.com/reference/androidx/recyclerview/widget/DiffUtil.ItemCallback#arecontentsthesame), which compares relevant object fields:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/paging/ui#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/paging/ui#java)

```java
private static DiffUtil.ItemCallback<Concert> DIFF_CALLBACK =
        new DiffUtil.ItemCallback<Concert>() {

    @Override
    public boolean areItemsTheSame(Concert oldItem, Concert newItem) {
        // The ID property identifies when items are the same.
        return oldItem.getId() == newItem.getId();
    }

    @Override
    public boolean areContentsTheSame(Concert oldItem, Concert newItem) {
        // Don't use the "==" operator here. Either implement and use .equals(),
        // or write custom data comparison logic here.
        return oldItem.equals(newItem);
    }
};
```



Because your adapter includes your definition of comparing items, the adapter automatically detects changes to these items when a new `PagedList` object is loaded. As a result, the adapter triggers efficient item animations within your `RecyclerView` object.

### Diffing using a different adapter type

If you choose not to inherit from [`PagedListAdapter`](https://developer.android.com/reference/androidx/paging/PagedListAdapter)—such as when you're using a library that provides its own adapter—you can still use the Paging Library adapter's diffing functionality by working directly with an[`AsyncPagedListDiffer`](https://developer.android.com/reference/androidx/paging/AsyncPagedListDiffer) object.

### Provide placeholders in your UI

In cases where you want your UI to display a list before your app has finished fetching data, you can show placeholder list items to your users. The [`PagedList`](https://developer.android.com/reference/androidx/paging/PagedList) handles this case by presenting the list item data as `null`until the data is loaded.

**Note:** By default, the Paging Library enables this placeholder behavior.

Placeholders have the following benefits:

- **Support for scrollbars:** The [`PagedList`](https://developer.android.com/reference/androidx/paging/PagedList) provides the number of list items to the [`PagedListAdapter`](https://developer.android.com/reference/androidx/paging/PagedListAdapter). This information allows the adapter to draw a scrollbar that conveys the full size of the list. As new pages load, the scrollbar doesn't jump because your list doesn't change size.
- **No loading spinner necessary:** Because the list size is already known, there's no need to alert users that more items are loading. The placeholders themselves convey that information.

Before adding support for placeholders, though, keep the following preconditions in mind:

- **Requires a countable data set:** Instances of [`DataSource`](https://developer.android.com/reference/androidx/paging/DataSource) from the [Room persistence library](https://developer.android.com/topic/libraries/architecture/room) can efficiently count their items. If you're using a custom local storage solution or a [network-only data architecture](https://developer.android.com/topic/libraries/architecture/paging#network-only-data-arch), however, it might be expensive or even impossible to determine how many items comprise your data set.
- **Requires adapter to account for unloaded items:** The adapter or presentation mechanism that you use to prepare the list for inflation needs to handle null list items. For example, when binding data to a[`ViewHolder`](https://developer.android.com/reference/androidx/recyclerview/widget/RecyclerView.ViewHolder), you need to provide default values to represent unloaded data.
- **Requires same-sized item views:** If list item sizes can change based on their content, such as social networking updates, crossfading between items doesn't look good. We strongly suggest disabling placeholders in this case.

### Provide feedback

Share your feedback and ideas with us through these resources:

- [Issue tracker](https://issuetracker.google.com/issues/new?component=413106&template=1096385) ![img](https://developer.android.com/topic/libraries/architecture/images/bug.png)

  Report issues so we can fix bugs.

### Additional resources

To learn more about the Paging Library, consult the following resources.

#### Samples

- [Android Architecture Components Paging sample](https://github.com/googlesamples/android-architecture-components/tree/master/PagingSample)
- [Paging With Network Sample](https://github.com/googlesamples/android-architecture-components/tree/master/PagingWithNetworkSample)

#### Codelabs

- [Android Paging codelab](https://codelabs.developers.google.com/codelabs/android-paging/index.html?index=..%2F..%2Findex#0)

#### Videos

- [Android Jetpack: manage infinite lists with RecyclerView and Paging (Google I/O '18)](https://www.youtube.com/watch?v=BE5bsyGGLf4)
- [Android Jetpack: Paging](https://www.youtube.com/watch?v=QVMqCRs0BNA)



## Gather paged data

This guide builds upon the [Paging Library overview](https://developer.android.com/topic/libraries/architecture/paging/index), discussing how you can customize your app's data-loading solution to meet your app's architecture needs.

### Construct an observable list

Typically, your UI code observes a [`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData) object (or, if you're using [RxJava2](https://github.com/ReactiveX/RxJava), a`Flowable<PagedList>` or `Observable<PagedList>` object), which resides in your app's [`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel). This observable object forms a connection between the presentation and contents of your app's list data.

In order to create one of these observable [`PagedList`](https://developer.android.com/reference/androidx/paging/PagedList) objects, pass in an instance of [`DataSource.Factory`](https://developer.android.com/reference/androidx/paging/DataSource.Factory) to a [`LivePagedListBuilder`](https://developer.android.com/reference/androidx/paging/LivePagedListBuilder) or [`RxPagedListBuilder`](https://developer.android.com/reference/androidx/paging/RxPagedListBuilder) object. A [`DataSource`](https://developer.android.com/reference/androidx/paging/DataSource) object loads pages for a single `PagedList`. The factory class creates new instances of `PagedList` in response to content updates, such as database table invalidations and network refreshes. The [Room persistence library](https://developer.android.com/topic/libraries/architecture/room) can provide `DataSource.Factory` objects for you, or you can [build your own](https://developer.android.com/topic/libraries/architecture/paging/data#custom-data-source).

The following code snippet shows how to create a new instance of [`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData) in your app's [`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel)class using Room's [`DataSource.Factory`](https://developer.android.com/reference/androidx/paging/DataSource.Factory)-building capabilities:

ConcertDao

[KOTLIN](https://developer.android.com/topic/libraries/architecture/paging/data#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/paging/data#java)

```java
@Dao
public interface ConcertDao {
    // The Integer type parameter tells Room to use a PositionalDataSource
    // object, with position-based loading under the hood.
    @Query("SELECT * FROM concerts ORDER BY date DESC")
    DataSource.Factory<Integer, Concert> concertsByDate();
}
```



ConcertViewModel

[KOTLIN](https://developer.android.com/topic/libraries/architecture/paging/data#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/paging/data#java)

```java
// The Integer type argument corresponds to a PositionalDataSource object.
DataSource.Factory<Integer, Concert> myConcertDataSource =
       concertDao.concertsByDate();

LiveData<PagedList<Concert>> concertList =
        LivePagedListBuilder(myConcertDataSource, /* page size */ 50).build();
```



### Define your own paging configuration

To further configure a [`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData) for advanced cases, you can also define your own paging configuration. In particular, you can define the following attributes:

- **Page size:** The number of items in each page.
- **Prefetch distance:** Given the last visible item in an app's UI, the number of items beyond this last item that the Paging Library should attempt to fetch in advance. This value should be several times larger than the page size.
- **Placeholder presence:** Determines whether the UI displays placeholders for list items that haven't finished loading yet. For a discussion about the benefits and drawbacks of using placeholders, learn how to [Provide placeholders in your UI](https://developer.android.com/topic/libraries/architecture/paging/ui#provide-placeholders).

If you'd like more control over when the Paging Library loads a list from your app's database, pass a custom[`Executor`](https://developer.android.com/reference/java/util/concurrent/Executor) object to the [`LivePagedListBuilder`](https://developer.android.com/reference/androidx/paging/LivePagedListBuilder), as shown in the following code snippet:

ConcertViewModel

[KOTLIN](https://developer.android.com/topic/libraries/architecture/paging/data#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/paging/data#java)

```java
PagedList.Config myPagingConfig = new PagedList.Config.Builder()
        .setPageSize(50)
        .setPrefetchDistance(150)
        .setEnablePlaceholders(true)
        .build();

// The Integer type argument corresponds to a PositionalDataSource object.
DataSource.Factory<Integer, Concert> myConcertDataSource =
        concertDao.concertsByDate();

LiveData<PagedList<Concert>> concertList =
        new LivePagedListBuilder<>(myConcertDataSource, myPagingConfig)
            .setFetchExecutor(myExecutor)
            .build();
```



### Choose the correct data source type

It's important to connect to the data source that best handles your source data's structure:

- Use [`PageKeyedDataSource`](https://developer.android.com/reference/androidx/paging/PageKeyedDataSource) if pages you load embed next/previous keys. For example, if you're fetching social media posts from the network, you may need to pass a `nextPage` token from one load into a subsequent load.
- Use [`ItemKeyedDataSource`](https://developer.android.com/reference/androidx/paging/ItemKeyedDataSource) if you need to use data from item *N* to fetch item *N+1*. For example, if you're fetching threaded comments for a discussion app, you might need to pass the ID of the last comment to get the contents of the next comment.
- Use [`PositionalDataSource`](https://developer.android.com/reference/androidx/paging/PositionalDataSource) if you need to fetch pages of data from any location you choose in your data store. This class supports requesting a set of data items beginning from whatever location you select. For example, the request might return the 50 data items beginning with location 1500.

### Notify when data is invalid

When using the Paging Library, it's up to the **data layer** to notify the other layers of your app when a table or row has become stale. To do so, call [`invalidate()`](https://developer.android.com/reference/androidx/paging/DataSource#invalidate) from the [`DataSource`](https://developer.android.com/reference/androidx/paging/DataSource) class that you've chosen for your app.

**Note:** Your app's UI can trigger this data invalidation functionality using a [swipe to refresh](https://developer.android.com/training/swipe) model.

### Build your own data sources

If you use a custom local data solution, or if you load data directly from a network, you can implement one of the [`DataSource`](https://developer.android.com/reference/androidx/paging/DataSource) subclassses. The following code snippet shows a data source that's keyed off of a given concert's start time:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/paging/data#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/paging/data#java)

```java
public class ConcertTimeDataSource
        extends ItemKeyedDataSource<Date, Concert> {
    @NonNull
    @Override
    public Date getKey(@NonNull Concert item) {
        return item.getStartTime();
    }

    @Override
    public void loadInitial(@NonNull LoadInitialParams<Date> params,
            @NonNull LoadInitialCallback<Concert> callback) {
        List<Concert> items =
            fetchItems(params.key, params.requestedLoadSize);
        callback.onResult(items);
    }

    @Override
    public void loadAfter(@NonNull LoadParams<Date> params,
            @NonNull LoadCallback<Concert> callback) {
        List<Concert> items =
            fetchItemsAfter(params.key, params.requestedLoadSize);
        callback.onResult(items);
    }
```



You can then load this customized data into `PagedList` objects by creating a concrete subclass of[`DataSource.Factory`](https://developer.android.com/reference/androidx/paging/DataSource.Factory). The following code snippet shows how to generate new instances of the custom data source defined in the preceding code snippet:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/paging/data#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/paging/data#java)

```java
public class ConcertTimeDataSourceFactory
        extends DataSource.Factory<Date, Concert> {
    private MutableLiveData<ConcertTimeDataSource> sourceLiveData =
            new MutableLiveData<>();

    private ConcertDataSource latestSource;

    @Override
    public DataSource<Date, Concert> create() {
        latestSource = new ConcertTimeDataSource();
        sourceLiveData.postValue(latestSource);
        return latestSource;
    }
}
```



### Consider how content updates work

As you construct observable [`PagedList`](https://developer.android.com/reference/androidx/paging/PagedList) objects, consider how content updates work. If you're loading data directly from a [Room database](https://developer.android.com/training/data-storage/room) updates get pushed to your app's UI automatically.

When using a paged network API, you typically have a user interaction, such as "swipe to refresh," serve as a signal for invalidating the [`DataSource`](https://developer.android.com/reference/androidx/paging/DataSource) that you've used most recently. You then request a new instance of that data source. This following code snippet demonstrates this behavior:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/paging/data#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/paging/data#java)

```java
public class ConcertActivity extends AppCompatActivity {
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        // ...
        viewModel.getRefreshState()
                .observe(this, new Observer<NetworkState>() {
            // Shows one possible way of triggering a refresh operation.
            @Override
            public void onChanged(@Nullable MyNetworkState networkState) {
                swipeRefreshLayout.isRefreshing =
                        networkState == MyNetworkState.LOADING;
            }
        };

        swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshListener() {
            @Override
            public void onRefresh() {
                viewModel.invalidateDataSource();
            }
        });
    }
}

public class ConcertTimeViewModel extends ViewModel {
    private LiveData<PagedList<Concert>> concertList;
    private DataSource<Date, Concert> mostRecentDataSource;

    public ConcertTimeViewModel(Date firstConcertStartTime) {
        ConcertTimeDataSourceFactory dataSourceFactory =
                new ConcertTimeDataSourceFactory(firstConcertStartTime);
        mostRecentDataSource = dataSourceFactory.create();
        concertList = new LivePagedListBuilder<>(dataSourceFactory, 50)
                .setFetchExecutor(myExecutor)
                .build();
    }

    public void invalidateDataSource() {
        mostRecentDataSource.invalidate();
    }
}
```



### Provide data mapping

The Paging Library supports item-based and page-based transformations of items loaded by a [`DataSource`](https://developer.android.com/reference/androidx/paging/DataSource).

In the following code snippet, a combination of concert name and concert date is mapped to a single string containing both the name and date:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/paging/data#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/paging/data#java)

```java
public class ConcertViewModel extends ViewModel {
    private LiveData<PagedList<String>> concertDescriptions;

    public ConcertViewModel(MyDatabase database) {
        DataSource.Factory<Integer, Concert> factory =
                database.allConcertsFactory().map(concert ->
                    concert.getName() + "-" + concert.getDate());
        concertDescriptions = new LivePagedListBuilder<>(
            factory, /* page size */ 50).build();
    }
}
```



This can be useful if you want to wrap, convert, or prepare items after they're loaded. Because this work is done on the fetch executor, you can do potentially expensive work, such as reading from disk or querying a separate database.

**Note:** JOIN queries are always more efficient that requerying as part of `map()`.



## Provide feedback

Share your feedback and ideas with us through these resources:

- [Issue tracker](https://issuetracker.google.com/issues/new?component=413106&template=1096385) ![img](https://developer.android.com/topic/libraries/architecture/images/bug.png)

  Report issues so we can fix bugs.



## Additional resources

To learn more about the Paging Library, consult the following resources.

### Samples

- [Android Architecture Components Paging sample](https://github.com/googlesamples/android-architecture-components/tree/master/PagingSample)
- [Paging With Network Sample](https://github.com/googlesamples/android-architecture-components/tree/master/PagingWithNetworkSample)

### Codelabs

- [Android Paging codelab](https://codelabs.developers.google.com/codelabs/android-paging/index.html?index=..%2F..%2Findex#0)

### Videos

- [Android Jetpack: manage infinite lists with RecyclerView and Paging (Google I/O '18)](https://www.youtube.com/watch?v=BE5bsyGGLf4)
- [Android Jetpack: Paging](https://www.youtube.com/watch?v=QVMqCRs0BNA)





















