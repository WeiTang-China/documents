# LiveData Overview   **Part of Android Jetpack.**

`LiveData`是一个可观察的数据持有者类。 与常规observable不同，LiveData是生命周期感知的，这意味着它遵守其他应用程序组件的生命周期，例如Activity，Fragment或Service。 此感知确保LiveData仅更新处于活动生命周期状态的应用程序组件观察者。

**Note:** 要将LiveData组件导入Android项目，请参阅[Adding Components to your Project](https://developer.android.com/topic/libraries/architecture/adding-components.html#lifecycle)。

LiveData认为观察者是由`Observer`类表示的，如果它的生命周期是在 `STARTED`或`RESUMED`状态。LiveData仅通知活动观察者有关更新的信息。 注册观察`LiveData`对象的非活动观察者不会收到有关更改的通知。

您可以注册一个观察者，它与`LifecycleOwner`界面配对。这种配对关系可以删除观察者，当对应的`Lifecycle`对象的状态变为`DESTROYED`时。这对于Activity和Fragment特别有用，因为它们可以安全地观察`LiveData`对象而不用担心泄漏 - Activity和Fragment是当他们的生命周期被摧毁时立即取消订阅。

有关如何使用LiveData的详细信息，请参阅[Work with LiveData objects](#Work with LiveData objects)。

## The advantages of using LiveData

使用LiveData有如下好处：

- **确保UI与data状态匹配**

  LiveData遵循观察者模式。生命周期状态更改时，LiveData会通知`Observer`对象。您可以合并代码以更新这些`Observer`对象中的UI。每次应用程序数据更改时，您的观察者都可以在每次更改时更新UI，而不是更新UI。

- **不会内存泄漏**

  观察者必须绑定`Lifecycle`对象，并在其相关生命周期被破坏后自行清理。

- **没有因停止活动而崩溃**

  如果观察者的生命周期处于非活动状态，例如Activity切换到后台堆栈中，则Activity不会再收到任何LiveData事件。

- **不再需要手动生命周期处理**

  UI组件只是观察相关数据，不会停止或恢复观察。LiveData自动管理所有这些，因为它在观察时感知到相关的生命周期状态变化。

- **始终保持最新数据**

  如果生命周期变为非活动状态，它将在再次变为活动状态时接收最新数据。例如，后台Activity在返回前台后立即接收最新数据。

- **适当的配置更改**

  如果由于configuration更改（例如设备横竖屏切换）而重新创建Activity或Fragment，则会立即接收最新的可用数据。

- **共享资源**

  您可以使用单例模式扩展`LiveData`对象以包装系统服务，以便可以在您的应用程序中共享它们。`LiveData`对象连接到系统服务一次，然后任何需要该资源的观察者只能看到`LiveData`对象。有关更多信息，请参阅[extend_livedata](#extend_livedata)。

## Work with LiveData objects

按照以下步骤使用`LiveData`对象：

1. 创建一个“LiveData”实例来保存某种类型的数据。这通常在您的`ViewModel`类中完成。

2. 创建一个`Observer`对象，定义`onChanged()`方法，它控制当`LiveData`对象保持数据发生变化时会发生什么。您通常在UI控制器中创建一个“Observer”对象，例如在Activity或Fragment中。

3. 使用`observe()`将`Observer`对象附加到`LiveData`对象。`observe()`方法需要一个`LifecycleOwner`对象参数，并将`Observer`对象订阅到`LiveData`对象，以便通知它变化。 您通常在UI控制器中附加`Observer`对象，例如Activity或Fragment。

   **Note:** 您可以使用`observeForever(Observer)`方法注册没有关联`LifecycleOwner`对象的观察者。在这种情况下，观察者被认为始终处于活动状态，因此始终会收到有关修改的通知。您可以删除这些观察者，通过调用`removeObserver(Observer)`方法。

当您更新存储在`LiveData`对象中的值时，只要附加的`LifecycleOwner`处于活动状态，它就会触发所有已注册的观察者。

LiveData允许UI控制器观察者订阅更新。当`LiveData`对象保存的数据发生变化时，UI会自动更新响应。

### Create LiveData objects

LiveData是一个可以与任何数据一起使用的包装器，包括实现`Collections`的对象，例如`List`。`LiveData`对象通常存储在`ViewModel`对象中，可通过getter方法访问，如下所示：

```java
public class NameViewModel extends ViewModel {
    // Create a LiveData with a String
    private MutableLiveData<String> currentName;

    public MutableLiveData<String> getCurrentName() {
        if (currentName == null) {
            currentName = new MutableLiveData<String>();
        }
        return currentName;
    }

// Rest of the ViewModel...
}
```

初始状态，`LiveData`对象中的数据并未被设置。

> **Note:** 确保存储`LiveData`对象更新`ViewModel`对象中的UI，而不是Activity或Fragment，原因：避免膨胀的Activity和Fragment。现在，这些UI控制器负责显示数据但不保持数据状态。将“LiveData”实例与特定Activity或Fragment实例分离，并允许“LiveData”对象在configuration更改后继续存在。

您可以在[ViewModel指南](https://developer.android.com/topic/libraries/architecture/viewmodel.html)中阅读有关`ViewModel`类的优点和用法的更多信息。

### Observe LiveData objects

在大多数情况下，app组件的`onCreate()`方法是开始观察`LiveData`对象的正确位置。 原因如下：

- 确保系统不会从Activity或Fragment的`onResume()`方法进行冗余调用。
- 确保Activity或Fragment具有可在变为活动状态时立即显示的数据。一旦应用程序组件处于`STARTED`状态，它就会收到来自`LiveData`的最新值。 只有在设置了要观察的`LiveData`对象时才会出现这种情况。

通常，LiveData仅在数据更改时才提供更新，并且仅在观察者处于活动状态时提供更新。此行为的一个例外是观察者在从非活动状态更改为活动状态时也会收到更新。此外，如果观察者第二次从非活动状态变为活动状态，则只有在自上次活动状态以来该值发生更改时才会收到更新。

以下示例代码说明了如何开始观察`LiveData`对象：

```java
public class NameActivity extends AppCompatActivity {

    private NameViewModel model;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Other code to setup the activity...

        // Get the ViewModel.
        model = ViewModelProviders.of(this).get(NameViewModel.class);


        // Create the observer which updates the UI.
        final Observer<String> nameObserver = new Observer<String>() {
            @Override
            public void onChanged(@Nullable final String newName) {
                // Update the UI, in this case, a TextView.
                nameTextView.setText(newName);
            }
        };

        // Observe the LiveData, passing in this activity as the LifecycleOwner and the observer.
        model.getCurrentName().observe(this, nameObserver);
    }
}
```

在调用`observe()`之后（`nameObserver`作为参数），立即调用`onChanged()`方法立即被调用，并提供存储的最新值在`mCurrentName`中。如果`LiveData`对象没有在`mCurrentName`中设置一个值，即`mCurrentName`是未设置状态，则不会调用`onChanged()`。

### Update LiveData objects

LiveData没有公开的方法来更新存储的数据。`MutableLiveData`类暴露了`setValue(T)`和`postValue(T)`方法为public，因此如果您需要编辑存储在`LiveData`对象中的值，则必须使用这些。通常`MutableLiveData`用在`ViewModel`中，然后`ViewModel`只向观察者公开不可变的`LiveData`对象。

建立观察者关系后，可以更新`LiveData`对象的值，如下所示，当用户点击按钮时触发所有观察者：

```java
button.setOnClickListener(new OnClickListener() {
    @Override
    public void onClick(View v) {
        String anotherName = "John Doe";
        model.getCurrentName().setValue(anotherName);
    }
});
```

在示例中调用`setValue(T)`导致观察者调用他们的`onChanged()`方法并且value==“John Doe”。该示例显示按下按钮，但也可以调用`setValue()`或`postValue()`以更新`mName`，触发更新的原因可能有很多种，包括响应网络请求或数据库负载完成；不论如何，对`setValue()`或`postValue()`的调用都会触发观察者并更新UI。

**Note:** 你必须在**主线程**调用`setValue(T)`方法来更新`LiveData`对象。如果代码在工作线程中执行，则可以使用`postValue(T)`方法来更新`LiveData`对象。

### Use LiveData with Room

Room持久性库支持可观察的查询，返回`LiveData`对象。可观察查询被实现为数据库访问对象（DAO）的一部分。

Room会生成所有必要的代码，以便在更新数据库时更新`LiveData`对象。生成的代码在需要时在后台线程上异步运行查询。此模式对于使UI中显示的数据与存储在数据库中的数据保持同步非常有用。您可以在[Room persistent library guide](https://developer.android.com/topic/libraries/architecture/room.html)中阅读有关Room和DAO的更多信息。

### Use coroutines with LiveData

`LiveData` includes support for Kotlin coroutines. For more information, see [Use Kotlin coroutines with Android Architecture Components](https://developer.android.com/topic/libraries/architecture/coroutines).

## Extend LiveData

如果观察者的生命周期在`STARTED`或`RESUMED`中，LiveData会认为观察者处于活动状态。以下示例代码说明了如何扩展`LiveData`类：

```java
public class StockLiveData extends LiveData<BigDecimal> {
    private StockManager stockManager;

    private SimplePriceListener listener = new SimplePriceListener() {
        @Override
        public void onPriceChanged(BigDecimal price) {
            setValue(price);
        }
    };

    public StockLiveData(String symbol) {
        stockManager = new StockManager(symbol);
    }

    @Override
    protected void onActive() {
        stockManager.requestPriceUpdates(listener);
    }

    @Override
    protected void onInactive() {
        stockManager.removeUpdates(listener);
    }
}
```

此示例中price监听器的实现包括以下重要方法：

- 当`LiveData`对象具有活动观察者时，将调用`onActive()`方法。这意味着您需要从此方法开始观察price更新。
- 当`LiveData`对象没有任何活动的观察者时，会调用`onInactive()`方法。由于没有观察者正在收听，因此没有理由保持与`StockManager`服务的连接。
- `setValue(T)`方法更新`LiveData`实例的值并通知任何活动的观察者相关改变。

您可以使用`StockLiveData`类，如下所示：

```java
public class MyFragment extends Fragment {
    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        LiveData<BigDecimal> myPriceListener = ...;
        myPriceListener.observe(this, price -> {
            // Update the UI.
        });
    }
}
```

`observe()`方法传递Fragment作为第一个参数，Fragment是`LifecycleOwner`的实例。这样做表示此观察者绑定到与所有者关联的`Lifecycle`对象，这意味着：

- 如果`Lifecycle`对象未处于活动状态，则即使value发生更改，也不会调用观察者。
- “Lifecycle”对象被销毁后，会自动删除观察者。

`LiveData`对象具有生命周期感知这一事实意味着您可以在多个Activity、Fragment和Service之间共享它们。为了简化示例，您可以将`LiveData`类实现为单例，如下所示：

```java
public class StockLiveData extends LiveData<BigDecimal> {
    private static StockLiveData sInstance;
    private StockManager stockManager;

    private SimplePriceListener listener = new SimplePriceListener() {
        @Override
        public void onPriceChanged(BigDecimal price) {
            setValue(price);
        }
    };

    @MainThread
    public static StockLiveData get(String symbol) {
        if (sInstance == null) {
            sInstance = new StockLiveData(symbol);
        }
        return sInstance;
    }

    private StockLiveData(String symbol) {
        stockManager = new StockManager(symbol);
    }

    @Override
    protected void onActive() {
        stockManager.requestPriceUpdates(listener);
    }

    @Override
    protected void onInactive() {
        stockManager.removeUpdates(listener);
    }
}
```

您可以在Fragment中使用它，如下所示：

```java
public class MyFragment extends Fragment {
    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        StockLiveData.get(symbol).observe(this, price -> {
            // Update the UI.
        });
    }
}
```

多个Fragment和Activity可以观察到`MyPriceListener`实例。`LiveData`仅在一个或多个观察者可见且处于活动状态时才连接到系统服务。

## Transform LiveData

您可能希望更改存储在`LiveData`对象中的值，然后再将其发送给观察者，或者您可能需要根据另一个实例的值返回不同的`LiveData`实例。`Lifecycle`包提供`Transformations`类，包括支持这些方案的辅助方法。

- [`Transformations.map()`](https://developer.android.com/reference/androidx/lifecycle/Transformations.html#map(android.arch.lifecycle.LiveData, android.arch.core.util.Function))

  对存储在`LiveData`对象中的value应用函数，并将结果传播到下游。

```java
LiveData<User> userLiveData = ...;
LiveData<String> userName = Transformations.map(userLiveData, user -> {
    user.name + " " + user.lastName
});
```

- [`Transformations.switchMap()`](https://developer.android.com/reference/androidx/lifecycle/Transformations.html#switchMap(android.arch.lifecycle.LiveData, android.arch.core.util.Function>))

  与`map()`类似，将函数应用于存储在`LiveData`对象中的值，并将结果解包并调度到下游。传递给`switchMap()`的函数必须返回一个`LiveData`对象，如下例所示：

```java
private LiveData<User> getUser(String id) {
  ...;
}

LiveData<String> userId = ...;
LiveData<User> user = Transformations.switchMap(userId, id -> getUser(id) );
```

您可以使用转换方法在观察者的生命周期中传递信息。除非观察者正在观察返回的“LiveData”对象，否则不会计算变换。由于转换是延迟计算的，因此生命周期相关的行为会被隐式传递下去，而不需要额外的显式调用或依赖项。

如果您认为在`ViewModel`对象中需要一个`Lifecycle`对象，那么转换可能是更好的解决方案。例如，假设您有一个接受地址的UI组件并返回该地址的邮政编码。您可以为此组件实现纯粹的`ViewModel`，如以下示例代码所示：

```java
class MyViewModel extends ViewModel {
    private final PostalCodeRepository repository;
    public MyViewModel(PostalCodeRepository repository) {
       this.repository = repository;
    }

    private LiveData<String> getPostalCode(String address) {
       // DON'T DO THIS
       return repository.getPostCode(address);
    }
}
```

然后，UI组件需要从之前的`LiveData`对象取消注册，并在每次调用`getPostalCode()`时注册到新实例。另外，如果重新创建UI组件，它会触发另一个对`repository.getPostCode()`方法的调用，而不是使用前一个调用的结果。

相反，您可以将邮政编码查找实现为地址输入的转换，如以下示例所示：

```java
class MyViewModel extends ViewModel {
    private final PostalCodeRepository repository;
    private final MutableLiveData<String> addressInput = new MutableLiveData();
    public final LiveData<String> postalCode =
            Transformations.switchMap(addressInput, (address) -> {
                return repository.getPostCode(address);
             });

  public MyViewModel(PostalCodeRepository repository) {
      this.repository = repository
  }

  private void setInput(String address) {
      addressInput.setValue(address);
  }
}
```

在这种情况下，`postalCode`字段被定义为`addressInput`的转换。只要您的应用程序具有与`postalCode`字段关联的活动观察器，就会在`addressInput`更改时重新计算并检索字段的值。

这种机制允许较低级别的应用程序创建按需延迟计算的“LiveData”对象。 `ViewModel`对象可以轻松获取对`LiveData`对象的引用，然后在它们之上定义转换规则。

### Create new transformations

有十几种不同的特定转换可能对您的应用有用，但默认情况下不提供。要实现自己的转换，可以使用`MediatorLiveData`类，该类可以监听其他`LiveData`对象和处理它们发出的事件。`MediatorLiveData`正确地将其状态传播到源`LiveData`对象。要了解有关此模式的更多信息，请参阅[`Transformations`](https://developer.android.com/reference/androidx/lifecycle/Transformations.html)类的参考文档。

## Merge multiple LiveData sources

`MediatorLiveData`是`LiveData`的子类，可以用来合并多个LiveData源。只要任何原始LiveData源对象发生更改，就会触发`MediatorLiveData`对象的观察者。

例如，如果UI中有一个可以从本地数据库或网络更新的`LiveData`对象，则可以将以下源添加到`MediatorLiveData`对象：

- 与存储在数据库中的数据相关联的`LiveData`对象。
- 与从网络访问的数据相关联的`LiveData`对象。

您的活动只需要观察`MediatorLiveData`对象以接收来自两个来源的更新。有关详细示例，请参阅[Addendum: exposing network status](https://developer.android.com/topic/libraries/architecture/guide.html#addendum) section of the [Guide to App Architecture](https://developer.android.com/topic/libraries/architecture/guide.html)。

## Additional resources

To learn more about the [`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData.html) class, consult the following resources.

### Samples

- [Sunflower](https://github.com/googlesamples/android-architecture-components), a demo app demonstrating best practices with Architecture Components
- [Android Architecture Components Basic Sample](https://github.com/googlesamples/android-architecture-components/tree/master/BasicSample)

### Codelabs

- Android Room with a View [(Java)](https://codelabs.developers.google.com/codelabs/android-room-with-a-view) [(Kotlin)](https://codelabs.developers.google.com/codelabs/android-room-with-a-view-kotlin)

### Blogs

- [ViewModels and LiveData: Patterns + AntiPatterns](https://medium.com/androiddevelopers/viewmodels-and-livedata-patterns-antipatterns-21efaef74a54)
- [LiveData beyond the ViewModel — Reactive patterns using Transformations and MediatorLiveData](https://medium.com/androiddevelopers/livedata-beyond-the-viewmodel-reactive-patterns-using-transformations-and-mediatorlivedata-fda520ba00b7)
- [LiveData with SnackBar, Navigation and other events (the SingleLiveEvent case)](https://medium.com/androiddevelopers/livedata-with-snackbar-navigation-and-other-events-the-singleliveevent-case-ac2622673150)

### Videos

- [Jetpack LiveData](https://www.youtube.com/watch?v=OMcDk2_4LSk)
- [Fun with LiveData (Android Dev Summit '18)](https://www.youtube.com/watch?v=2rO4r-JOQtA)