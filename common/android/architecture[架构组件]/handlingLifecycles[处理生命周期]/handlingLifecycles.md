# Handling Lifecycles with Lifecycle-Aware Components **Part of Android Jetpack.**

Lifecycle-aware组件执行某些操作来响应另一个组件（例如Activity和Fragment）的生命周期状态的变化。这些组件可帮助您生成更易于组织且通常更轻量级的代码，这些代码更易于维护。

一种常见模式是在Activity和Fragment的生命周期回调方法中实现这些操作。但是，这种模式导致代码组织不良和错误扩散。通过使用lifecycle-aware组件，您可以将依赖组件的代码移出生命周期方法并移入组件本身。

[`android.arch.lifecycle`](https://developer.android.com/reference/android/arch/lifecycle/package-summary.html)包提供了类和接口，用来构建*lifecycle-aware*组件 - 根据Activity或Fragment的当前生命周期状态自动调整其行为的组件。

**Note:** 要将[`android.arch.lifecycle`](https://developer.android.com/reference/android/arch/lifecycle/package-summary.html)导入到您的Android项目中，请参阅[lifecycle release notes](https://developer.android.com/jetpack/androidx/releases/lifecycle#declaring_dependencies)。

Android Framework中定义的大多数应用程序组件都附加了生命周期。 生命周期由操作系统或运行在app进程的Framework代码管理。 它们是Android运作方式的核心，您的应用程序必须遵守。不这样做可能会触发内存泄漏甚至应用程序崩溃。

想象一下，我们有一个Activity，在屏幕上显示设备位置。常见的实现可能如下所示：

```java
class MyLocationListener {
    public MyLocationListener(Context context, Callback callback) {
        // ...
    }

    void start() {
        // connect to system location service
    }

    void stop() {
        // disconnect from system location service
    }
}

class MyActivity extends AppCompatActivity {
    private MyLocationListener myLocationListener;

    @Override
    public void onCreate(...) {
        myLocationListener = new MyLocationListener(this, (location) -> {
            // update UI
        });
    }

    @Override
    public void onStart() {
        super.onStart();
        myLocationListener.start();
        // manage other components that need to respond
        // to the activity lifecycle
    }

    @Override
    public void onStop() {
        super.onStop();
        myLocationListener.stop();
        // manage other components that need to respond
        // to the activity lifecycle
    }
}
```

即使这个示例看起来很好，但在真实的应用程序中，最终会有太多的调用来管理UI和其他组件以响应生命周期的当前状态。管理多个组件会在生命周期方法中放置大量代码，例如`onStart()`和`onStop()`回调，这使得这些生命周期方法难以维护。

此外，无法保证组件在活动或片段停止之前启动。如果我们需要执行长时间运行的操作，例如`onStart()`中的某些配置检查，则尤其明显。 这可能导致资源竞争，导致`onStop()`方法在`onStart()`之前完成，使组件保持活动的时间超过了它所需的时间。

```java
class MyActivity extends AppCompatActivity {
    private MyLocationListener myLocationListener;

    public void onCreate(...) {
        myLocationListener = new MyLocationListener(this, location -> {
            // update UI
        });
    }

    @Override
    public void onStart() {
        super.onStart();
        Util.checkUserStatus(result -> {
            // what if this callback is invoked AFTER activity is stopped?
            if (result) {
                myLocationListener.start();
            }
        });
    }

    @Override
    public void onStop() {
        super.onStop();
        myLocationListener.stop();
    }
}
```

[`android.arch.lifecycle`](https://developer.android.com/reference/android/arch/lifecycle/package-summary.html)包提供的类和接口可以用弹性和独立的方式解决这些问题。

## Lifecycle

[`Lifecycle`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.html)是一个类，它包含有关组件生命周期状态的信息（如Activity或Fragment）并允许其他物体要观察这种状态。

[`Lifecycle`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.html)使用两个主要枚举来跟踪其关联组件的生命周期状态：

- Event

  从Framework和[`Lifecycle`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.html)类调度的生命周期event。这些事件映射到Activity和Fragment中的回调events。

- State

  由`Lifecycle`对象跟踪的组件的当前state。

![img](files/lifecycle-states.png)

可以通过向类方法添加注解来监视组件的生命周期状态。然后你可以通过调用[`addObserver()`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.html#addObserver(android.arch.lifecycle.LifecycleObserver))方法来添加一个观察者。`Lifecycle`类并传递观察者的实例，如下所示：

```java
public class MyObserver implements LifecycleObserver {
    @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
    public void connectListener() {
        ...
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_PAUSE)
    public void disconnectListener() {
        ...
    }
}

myLifecycleOwner.getLifecycle().addObserver(new MyObserver());
```

在上面的示例中，`myLifecycleOwner`对象实现了[`LifecycleOwner`](https://developer.android.com/reference/androidx/lifecycle/LifecycleOwner.html)接口，这将在下一节中介绍。

## LifecycleOwner

`LifecycleOwner`是一个单一的方法接口，表示该类有`Lifecycle`。 它有一个方法，[`getLifecycle()`](https://developer.android.com/reference/androidx/lifecycle/LifecycleOwner.html#getLifecycle())。如果您正在尝试管理整个应用程序进程的生命周期，请参阅[`ProcessLifecycleOwner`](https://developer.android.com/reference/androidx/lifecycle/ProcessLifecycleOwner.html)。

This interface abstracts the ownership of a [`Lifecycle`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.html) from individual classes, such as `Fragment` and `AppCompatActivity`, and allows writing components that work with them. Any custom application class can implement the [`LifecycleOwner`](https://developer.android.com/reference/androidx/lifecycle/LifecycleOwner.html) interface.

Components that implement [`LifecycleObserver`](https://developer.android.com/reference/androidx/lifecycle/LifecycleObserver.html) work seamlessly with components that implement[`LifecycleOwner`](https://developer.android.com/reference/androidx/lifecycle/LifecycleOwner.html) because an owner can provide a lifecycle, which an observer can register to watch.

For the location tracking example, we can make the `MyLocationListener` class implement [`LifecycleObserver`](https://developer.android.com/reference/androidx/lifecycle/LifecycleObserver.html) and then initialize it with the activity's [`Lifecycle`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.html) in the `onCreate()` method. This allows the `MyLocationListener` class to be self-sufficient, meaning that the logic to react to changes in lifecycle status is declared in `MyLocationListener`instead of the activity. Having the individual components store their own logic makes the activities and fragments logic easier to manage.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/lifecycle#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/lifecycle#java)

```java
class MyActivity extends AppCompatActivity {
    private MyLocationListener myLocationListener;

    public void onCreate(...) {
        myLocationListener = new MyLocationListener(this, getLifecycle(), location -> {
            // update UI
        });
        Util.checkUserStatus(result -> {
            if (result) {
                myLocationListener.enable();
            }
        });
  }
}
```



A common use case is to avoid invoking certain callbacks if the [`Lifecycle`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.html) isn't in a good state right now. For example, if the callback runs a fragment transaction after the activity state is saved, it would trigger a crash, so we would never want to invoke that callback.

To make this use case easy, the [`Lifecycle`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.html) class allows other objects to query the current state.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/lifecycle#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/lifecycle#java)

```java
class MyLocationListener implements LifecycleObserver {
    private boolean enabled = false;
    public MyLocationListener(Context context, Lifecycle lifecycle, Callback callback) {
       ...
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_START)
    void start() {
        if (enabled) {
           // connect
        }
    }

    public void enable() {
        enabled = true;
        if (lifecycle.getCurrentState().isAtLeast(STARTED)) {
            // connect if not connected
        }
    }

    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    void stop() {
        // disconnect if connected
    }
}
```



With this implementation, our `LocationListener` class is completely lifecycle-aware. If we need to use our `LocationListener` from another activity or fragment, we just need to initialize it. All of the setup and teardown operations are managed by the class itself.

If a library provides classes that need to work with the Android lifecycle, we recommend that you use lifecycle-aware components. Your library clients can easily integrate those components without manual lifecycle management on the client side.

### Implementing a custom LifecycleOwner

Fragments and Activities in Support Library 26.1.0 and later already implement the [`LifecycleOwner`](https://developer.android.com/reference/androidx/lifecycle/LifecycleOwner.html) interface.

If you have a custom class that you would like to make a [`LifecycleOwner`](https://developer.android.com/reference/androidx/lifecycle/LifecycleOwner.html), you can use the [LifecycleRegistry](https://developer.android.com/reference/androidx/lifecycle/LifecycleRegistry.html) class, but you need to forward events into that class, as shown in the following code example:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/lifecycle#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/lifecycle#java)

```java
public class MyActivity extends Activity implements LifecycleOwner {
    private LifecycleRegistry lifecycleRegistry;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        lifecycleRegistry = new LifecycleRegistry(this);
        lifecycleRegistry.markState(Lifecycle.State.CREATED);
    }

    @Override
    public void onStart() {
        super.onStart();
        lifecycleRegistry.markState(Lifecycle.State.STARTED);
    }

    @NonNull
    @Override
    public Lifecycle getLifecycle() {
        return lifecycleRegistry;
    }
}
```



## Best practices for lifecycle-aware components

- Keep your UI controllers (activities and fragments) as lean as possible. They should not try to acquire their own data; instead, use a [`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html) to do that, and observe a [`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData.html) object to reflect the changes back to the views.
- Try to write data-driven UIs where your UI controller’s responsibility is to update the views as data changes, or notify user actions back to the [`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html).
- Put your data logic in your [`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html) class. [`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html) should serve as the connector between your UI controller and the rest of your app. Be careful though, it isn't [`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html)'s responsibility to fetch data (for example, from a network). Instead, [`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html) should call the appropriate component to fetch the data, then provide the result back to the UI controller.
- Use [Data Binding](https://developer.android.com/topic/libraries/data-binding/index.html) to maintain a clean interface between your views and the UI controller. This allows you to make your views more declarative and minimize the update code you need to write in your activities and fragments. If you prefer to do this in the Java programming language, use a library like [Butter Knife](http://jakewharton.github.io/butterknife/) to avoid boilerplate code and have a better abstraction.
- If your UI is complex, consider creating a [presenter](http://www.gwtproject.org/articles/mvp-architecture.html#presenter) class to handle UI modifications. This might be a laborious task, but it can make your UI components easier to test.
- Avoid referencing a `View` or `Activity` context in your [`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html). If the `ViewModel` outlives the activity (in case of configuration changes), your activity leaks and isn't properly disposed by the garbage collector.
- Use [Kotlin coroutines](https://developer.android.com/topic/libraries/architecture/coroutines) to manage long-running tasks and other operations that can run asynchronously.

## Use cases for lifecycle-aware components

Lifecycle-aware components can make it much easier for you to manage lifecycles in a variety of cases. A few examples are:

- Switching between coarse and fine-grained location updates. Use lifecycle-aware components to enable fine-grained location updates while your location app is visible and switch to coarse-grained updates when the app is in the background. [`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData.html), a lifecycle-aware component, allows your app to automatically update the UI when your user changes locations.
- Stopping and starting video buffering. Use lifecycle-aware components to start video buffering as soon as possible, but defer playback until app is fully started. You can also use lifecycle-aware components to terminate buffering when your app is destroyed.
- Starting and stopping network connectivity. Use lifecycle-aware components to enable live updating (streaming) of network data while an app is in the foreground and also to automatically pause when the app goes into the background.
- Pausing and resuming animated drawables. Use lifecycle-aware components to handle pausing animated drawables when while app is in the background and resume drawables after the app is in the foreground.

## Handling on stop events

When a [`Lifecycle`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.html) belongs to an `AppCompatActivity` or `Fragment`, the [`Lifecycle`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.html)'s state changes to [`CREATED`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.State.html#CREATED) and the [`ON_STOP`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.Event.html#ON_STOP) event is dispatched when the `AppCompatActivity` or `Fragment`'s `onSaveInstanceState()` is called.

When a `Fragment` or `AppCompatActivity`'s state is saved via `onSaveInstanceState()`, it's UI is considered immutable until [`ON_START`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.Event.html#ON_START) is called. Trying to modify the UI after the state is saved is likely to cause inconsistencies in the navigation state of your application which is why `FragmentManager` throws an exception if the app runs a`FragmentTransaction` after state is saved. See `commit()` for details.

[`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData.html) prevents this edge case out of the box by refraining from calling its observer if the observer's associated [`Lifecycle`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.html) isn't at least [`STARTED`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.State.html#STARTED). Behind the scenes, it calls [`isAtLeast()`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.State.html#isAtLeast(android.arch.lifecycle.Lifecycle.State)) before deciding to invoke its observer.

Unfortunately, `AppCompatActivity`'s `onStop()` method is called *after* `onSaveInstanceState()`, which leaves a gap where UI state changes are not allowed but the [`Lifecycle`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.html) has not yet been moved to the [`CREATED`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.State.html#CREATED) state.

To prevent this issue, the [`Lifecycle`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.html) class in version `beta2` and lower mark the state as [`CREATED`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.State.html#CREATED) without dispatching the event so that any code that checks the current state gets the real value even though the event isn't dispatched until `onStop()` is called by the system.

Unfortunately, this solution has two major problems:

- On API level 23 and lower, the Android system actually saves the state of an activity even if it is *partially*covered by another activity. In other words, the Android system calls `onSaveInstanceState()` but it doesn't necessarily call `onStop()`. This creates a potentially long interval where the observer still thinks that the lifecycle is active even though its UI state can't be modified.
- Any class that wants to expose a similar behavior to the [`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData.html) class has to implement the workaround provided by [`Lifecycle`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.html) version `beta 2` and lower.

**Note:** To make this flow simpler and provide better compatibility with older versions, starting at version `1.0.0-rc1`, [`Lifecycle`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.html) objects are marked as [`CREATED`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.State.html#CREATED) and [`ON_STOP`](https://developer.android.com/reference/androidx/lifecycle/Lifecycle.Event.html#ON_STOP) is dispatched when `onSaveInstanceState()` is called without waiting for a call to the `onStop()` method. This is unlikely to impact your code but it is something you need to be aware of as it doesn't match the call order in the `Activity` class in API level 26 and lower.

## Additional resources

To learn more about handling lifecycles with lifecycle-aware components, consult the following additional resources.

### Samples

- [Android Architecture Components Basic Sample](https://github.com/googlesamples/android-architecture-components/tree/master/BasicSample)
- [Sunflower](https://github.com/googlesamples/android-architecture-components), a demo app demonstrating best practices with Architecture Components

### Codelabs

- [Android Lifecycle-aware components](https://codelabs.developers.google.com/codelabs/android-lifecycles/index.html?index=..%2F..%2Findex#0)

### Blogs

- [Introducing Android Sunflower](https://medium.com/androiddevelopers/introducing-android-sunflower-e421b43fe0c2)