# Work Manager

Schedule tasks with WorkManager   **Part of Android Jetpack.**

The WorkManager API makes it easy to schedule deferrable, asynchronous tasks that are expected to run even if the app exits or device restarts.

**Key features**:

- Backwards compatible up to API 14
  - Uses JobScheduler on devices with API 23+
  - Uses a combination of BroadcastReceiver + AlarmManager on devices with API 14-22
- Add work constraints like network availability or charging status
- Schedule asynchronous one-off or periodic tasks
- Monitor and manage scheduled tasks
- Chain tasks together
- Ensures task execution, even if the app or device restarts
- Adheres to power-saving features like Doze mode

WorkManager is intended for tasks that are **deferrable**—that is, not required to run immediately—and required to **run reliably** even if the app exits or the device restarts. For example:

- Sending logs or analytics to backend services
- Periodically syncing application data with a server

WorkManager is not intended for in-process background work that can safely be terminated if the app process goes away or for tasks that require immediate execution. Please review the [background processing guide](https://developer.android.com/guide/background/) to see which solution meets your needs.

**Note:** To import the WorkManager library into your Android project, follow the instructions to declare dependencies in the [WorkManager release notes](https://developer.android.com/jetpack/androidx/releases/work#declaring_dependencies).



## Getting started with WorkManager

With WorkManager, you can easily set up a task and hand it off to the system to run under the conditions you specify. To learn more if WorkManager is the right solution for your task, check out the [background processing guide](https://developer.android.com/guide/background/).

In this guide you will learn how to:

- Add WorkManager to your Android project
- Create a background task
- Configure how and when to run the task
- Hand off your task to the system

For information about WorkManager features, like handling recurring work, creating chains of work and cancelling work, check out the [how-to guides](https://developer.android.com/topic/libraries/architecture/workmanager/#how-to_guides).

### Add WorkManager to your Android project

Add the WorkManager dependency in Java or Kotlin to your Android project following the instructions in the [WorkManager release notes](https://developer.android.com/jetpack/androidx/releases/work#declaring_dependencies).

### Create a background task

A task is defined using the [`Worker`](https://developer.android.com/reference/androidx/work/Worker) class. The `doWork()` method is run synchronously on a background thread provided by WorkManager.

To create your background task, extend the `Worker` class and override the `doWork()` method. For example, to create a `Worker` that uploads images, you can do the following:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/basics#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/basics#java)

```java
public class UploadWorker extends Worker {

    public UploadWorker(
        @NonNull Context context,
        @NonNull WorkerParameters params) {
        super(context, params);
    }

    @Override
    public Result doWork() {
      // Do the work here--in this case, upload the images.

      uploadImages()

      // Indicate whether the task finished successfully with the Result
      return Result.success()
    }
}
```



The [`Result`](https://developer.android.com/reference/androidx/work/ListenableWorker.Result) returned from `doWork()` informs WorkManager whether the task:

- finished successfully via `Result.success()`
- failed via `Result.failure()`
- needs to be retried at a later time via `Result.retry()`

**Note:** `Worker` is the simplest way to run work; take a look at the WorkManager [Threading guide](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/threading) for information on more advanced worker options.

### Configure how and when to run the task

While a `Worker` defines the unit of work, a [`WorkRequest`](https://developer.android.com/reference/androidx/work/WorkRequest) defines how and when work should be run. Tasks may be one-off or periodic. For one-off `WorkRequest`s, use [`OneTimeWorkRequest`](https://developer.android.com/reference/androidx/work/OneTimeWorkRequest) and for periodic work [`PeriodicTimeWorkRequest`](https://developer.android.com/reference/androidx/work/PeriodicTimeWorkRequest). For more information on scheduling recurring work, read the [recurring work documentation](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/recurring-work).

In this case, the simplest example for building a `WorkRequest` for our UploadWorker is:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/basics#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/basics#java)

```java
OneTimeWorkRequest uploadWorkRequest = new OneTimeWorkRequest.Builder(UploadWorker.class)
        .build()
```



The `WorkRequest` can also include additional information, such as the constraints under which the task should run, input to the work, a delay, and backoff policy for retrying work. These options are explained in greater detail in the [Defining Work guide](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/define-work).

### Hand off your task to the system

Once you have defined your `WorkRequest`, you can now schedule it with [`WorkManager`](https://developer.android.com/reference/androidx/work/WorkManager) using the [`enqueue()`](https://developer.android.com/reference/androidx/work/WorkManager.html#enqueue(androidx.work.WorkRequest)) method.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/basics#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/basics#java)

```java
WorkManager.getInstance().enqueue(uploadWorkRequest);
```



The exact time that the worker is going to be executed depends on the constraints that are used in your `WorkRequest` and on system optimizations. WorkManager is designed to give the best possible behavior under these restrictions.



## How-To Guides

### Defining your Work Requests

The [getting started guide](https://developer.android.com/topic/libraries/architecture/workmanager/basics) covered how to create a simple [`WorkRequest`](https://developer.android.com/reference/androidx/work/WorkRequest) and enqueue it.

In this guide you will learn to customize work requests to handle common use cases:

- Handle task constraints like network availabilty
- Guarantee a minimum delay in task execution
- Handle task retries and back-off
- Handle task input & output
- Group tasks with tagging

#### Work constraints

You can add `Constraints` to your work to indicate when it can run.

For example, you can specify that the work should only run when the device is idle and connected to power.

The code below shows how you can add these constraints to a [`OneTimeWorkRequest`](https://developer.android.com/reference/androidx/work/OneTimeWorkRequest). For a full list of supported constraints, take a look at the [`Constraints.Builder` reference documentation](https://developer.android.com/reference/androidx/work/Constraints.Builder).

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/define-work#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/define-work#java)

```java
// Create a Constraints object that defines when the task should run
Constraints constraints = new Constraints.Builder()
    .setRequiresDeviceIdle(true)
    .setRequiresCharging(true)
     .build();

// ...then create a OneTimeWorkRequest that uses those constraints
OneTimeWorkRequest compressionWork =
                new OneTimeWorkRequest.Builder(CompressWorker.class)
     .setConstraints(constraints)
     .build();
```



When multiple constraints are specified, your task will run only when all the constraints are met.

In the event that a constraint fails while your task is running, WorkManager will stop your worker. The task will then be retried when the constraint(s) are met.

#### Initial Delays

In the event that your work has no constraints or that all the constraints are met when your work is enqueued, the system may choose to run the task immediately. If you do not want the task to be run immediately, you can specify your work to start after a minimum initial delay.

Here is an example of how to set your task to run atleast 10 minutes after it has been enqueued.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/define-work#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/define-work#java)

```java
OneTimeWorkRequest uploadWorkRequest = new OneTimeWorkRequest.Builder(UploadWorker.class)
        .setInitialDelay(10, TimeUnit.MINUTES)
        .build();
```



**Note:** The exact time that the worker is going to be executed also depends on the constraints that are used in your WorkRequest and on system optimizations. WorkManager is designed to give the best possible behavior under these restrictions.

#### Retries and Backoff Policy

If you require that WorkManager retry your task, you can return [`Result.retry()`](https://developer.android.com/reference/androidx/work/ListenableWorker.Result.html#retry()) from your worker.

Your work is then rescheduled with a default backoff delay and policy. The backoff delay specifies the minimum amount of time to wait before retrying the work. The [backoff policy](https://developer.android.com/reference/androidx/work/BackoffPolicy) defines how the backoff delay is going to increase over time for the following retry attempts; it is [`EXPONENTIAL`](https://developer.android.com/reference/androidx/work/BackoffPolicy) by default.

Here is an example of customizing the backoff delay and policy.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/define-work#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/define-work#java)

```java
OneTimeWorkRequest uploadWorkRequest = 
    new OneTimeWorkRequest.Builder(UploadWorker.class)
        .setBackoffCriteria(
                BackoffPolicy.LINEAR,
                OneTimeWorkRequest.MIN_BACKOFF_MILLIS,
                TimeUnit.MILLISECONDS)
        .build();
```



#### Defining input/output for your task

Your task may require data to be passed in as input parameters or be returned as a result. For example, a task that handles uploading an image requires the URI of the image to be uploaded as input and may require the URL of the uploaded image as the output.

Input and output values are stored as key-value pairs in a [`Data`](https://developer.android.com/reference/androidx/work/Data) object. The code below shows how you can set input data in your `WorkRequest`.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/define-work#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/define-work#java)

```java
Data imageData = new Data.Builder
                .putString(Constants.KEY_IMAGE_URI, imageUriString)
                .build();

OneTimeWorkRequest uploadWorkRequest = new OneTimeWorkRequest.Builder(UploadWorker.class)
        .setInputData(imageData)
        .build()
```



The `Worker` class can access the input arguments by calling Worker.getInputData().

Similarily, the `Data` class can be used to output a return value. Return the `Data` object by including it in the `Result` on `Result.success()` or `Result.failure()`, as shown below.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/define-work#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/define-work#java)

```java
public class UploadWorker extends Worker {

    public UploadWorker(
        @NonNull Context context,
        @NonNull WorkerParameters params) {
        super(context, params);
    }

    @Override
    public Result doWork() {

        // Get the input
        String imageUriInput = getInputData().getString(Constants.KEY_IMAGE_URI)
        // TODO: validate inputs.
        // Do the work
        Response response = uploadFile(imageUriInput)

        // Create the output of the work
        Data outputData = new Data.Builder
                .putString(Constants.KEY_IMAGE_URL, response.imageUrl)
                .build();

        // Return the output
        return Result.success(outputData)
    }
}
```



**Note:** `Data` objects are intended to be small and values can be Strings, primitive types, or their array variants. If you need to pass more data in and out of your Worker, you should put your data elsewhere, such as a Room database. There is a maximum size limit of 10KB for Data objects.

#### Tagging work

You can group your tasks logically by assigning a tag string to any [`WorkRequest`](https://developer.android.com/reference/androidx/work/WorkRequest) object. This allows you to operate on all tasks with a particular tag.

For example, [`WorkManager.cancelAllWorkByTag(String)`](https://developer.android.com/reference/androidx/work/WorkManager#cancelAllWorkByTag(java.lang.String)) cancels all tasks with a particular tag, and[`WorkManager.getWorkInfosByTagLiveData(String)`](https://developer.android.com/reference/androidx/work/WorkManager#getWorkInfosByTagLiveData(java.lang.String)) returns a [`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData) with a list of the status of all tasks with that tag.

The following code shows how you can add a "cleanup" tag to your task with [`WorkRequest.Builder.addTag(String)`](https://developer.android.com/reference/androidx/work/WorkRequest.Builder#addTag(java.lang.String)):

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/define-work#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/define-work#java)

```java
OneTimeWorkRequest cacheCleanupTask =
        new OneTimeWorkRequest.Builder(CacheCleanupWorker.class)
    .setConstraints(constraints)
    .addTag("cleanup")
    .build();
```

### Work States and observing work

#### Work States

As your work goes through its lifetime, it goes through various [`State`](https://developer.android.com/reference/androidx/work/WorkInfo.State.html)s. [Later in this document](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/states-and-observation#observing), we will talk about how to observe the changes. But first, you should learn about each of them:

- Work is in the [`BLOCKED`](https://developer.android.com/reference/androidx/work/WorkInfo.State.html#BLOCKED) `State` if it has [prerequisite work](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/chain-work.html) that hasn't finished yet.
- Work that is eligible to run as soon as its [`Constraints`](https://developer.android.com/reference/androidx/work/Constraints.html) and timing are met is considered to be [`ENQUEUED`](https://developer.android.com/reference/androidx/work/WorkInfo.State.html#ENQUEUED).
- When a worker is actively being executed, it is in the [`RUNNING`](https://developer.android.com/reference/androidx/work/WorkInfo.State.html#RUNNING) `State`.
- A worker that has returned [`Result.success()`](https://developer.android.com/reference/androidx/work/ListenableWorker.Result.html#success()) is considered to be [`SUCCEEDED`](https://developer.android.com/reference/androidx/work/WorkInfo.State.html#SUCCEEDED). This is a terminal `State`; only [`OneTimeWorkRequest`](https://developer.android.com/reference/androidx/work/OneTimeWorkRequest.html)s may enter this `State`.
- Conversely, a worker that returned [`Result.failure()`](https://developer.android.com/reference/androidx/work/ListenableWorker.Result.html#failure()) is considered to be [`FAILED`](https://developer.android.com/reference/androidx/work/WorkInfo.State.html#FAILED). This is also a terminal `State`; only [`OneTimeWorkRequest`](https://developer.android.com/reference/androidx/work/OneTimeWorkRequest.html)s may enter this `State`. All dependent work will also be marked as `FAILED`and will not run.
- When you explicitly [cancel](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/cancel-stop-work.html) a `WorkRequest` that hasn't already terminated, it enters the [`CANCELLED`](https://developer.android.com/reference/androidx/work/WorkInfo.State.html#CANCELLED) `State`. All dependent work will also be marked as `CANCELLED` and will not run.

#### Observing your work

After you enqueue your work, WorkManager allows you to check on its status. This information is available in a [`WorkInfo`](https://developer.android.com/reference/androidx/work/WorkInfo.html) object, which includes the `id` of the work, its tags, its current [`State`](https://developer.android.com/reference/androidx/work/WorkInfo.State.html), and any output data.

You can obtain `WorkInfo` in one of three ways:

- For a specific [`WorkRequest`](https://developer.android.com/reference/androidx/work/WorkRequest.html), you can retrieve its `WorkInfo` by the `WorkRequest` `id` using [`WorkManager.getWorkInfoById(UUID)`](https://developer.android.com/reference/androidx/work/WorkManager.html#getWorkInfoById(java.util.UUID)) or [`WorkManager.getWorkInfoByIdLiveData(UUID)`](https://developer.android.com/reference/androidx/work/WorkManager#getWorkInfoByIdLiveData(java.util.UUID)).
- For a given [tag](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/define-work.html#tag), you can retrieve `WorkInfo` objects for all matching `WorkRequest`s using [`WorkManager.getWorkInfosByTag(String)`](https://developer.android.com/reference/androidx/work/WorkManager#getWorkInfosByTag(java.lang.String)) or [`WorkManager.getWorkInfosByTagLiveData(String)`](https://developer.android.com/reference/androidx/work/WorkManager#getWorkInfosByTagLiveData(java.lang.String)).
- For a [unique work name](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/unique-work.html), you can retrieve `WorkInfo` objects for all matching `WorkRequest`s using [`WorkManager.getWorkInfosForUniqueWork(String)`](https://developer.android.com/reference/androidx/work/WorkManager#getWorkInfosForUniqueWork(java.lang.String)) or [`WorkManager.getWorkInfosForUniqueWorkLiveData(String)`](https://developer.android.com/reference/androidx/work/WorkManager#getWorkInfosForUniqueWorkLiveData(java.lang.String))

The [`LiveData`](https://developer.android.com/topic/libraries/architecture/livedata) variants of each of the methods allow you to *observe changes to the WorkInfo* by registering a listener. For example, if you wanted to display a message to the user when some work finishes successfully, you could set it up as follows:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/states-and-observation#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/states-and-observation#java)

```java
WorkManager.getInstance().getWorkInfoByIdLiveData(uploadWorkRequest.getId())
        .observe(lifecycleOwner, new Observer<WorkInfo>() {
            @Override
            public void onChanged(@Nullable WorkInfo workInfo) {
              if (workInfo != null && workInfo.state == WorkInfo.State.SUCCEEDED) {
                  displayMessage("Work finished!")
              }
            }
        });
```

### Chaining Work

#### Introduction

[WorkManager](https://developer.android.com/reference/androidx/work/WorkManager) allows you to create and enqueue a chain of work that specifies multiple dependent tasks, and defines what order they should run in. This is particularly useful when you need to run several tasks in a particular order.

To create a chain of work, you can use [`WorkManager.beginWith(OneTimeWorkRequest)`](https://developer.android.com/reference/androidx/work/WorkManager.html#beginWith(androidx.work.OneTimeWorkRequest)) or [`WorkManager.beginWith(List)`](https://developer.android.com/reference/androidx/work/WorkManager.html#beginWith(java.util.List)) , which return an instance of [`WorkContinuation`](https://developer.android.com/reference/androidx/work/WorkContinuation).

A `WorkContinuation` can then be used to add dependent `OneTimeWorkRequest`s using[`WorkContinuation.then(OneTimeWorkRequest)`](https://developer.android.com/reference/androidx/work/WorkContinuation.html#then(androidx.work.OneTimeWorkRequest)) or [`WorkContinuation.then(List)`](https://developer.android.com/reference/androidx/work/WorkContinuation.html#then(java.util.List)) .

Every invocation of the `WorkContinuation.then(...)`, returns a *new* instance of `WorkContinuation`. If you add a `List`of `OneTimeWorkRequest`s, these requests can potentially run in parallel.

Finally, you can use the [`WorkContinuation.enqueue()`](https://developer.android.com/reference/androidx/work/WorkContinuation.html#enqueue()) method to enqueue() your chain of `WorkContinuation`s.

Let's look at an example where an application runs image filters on 3 different images (potentially in parallel), then compresses those images together, and then uploads them.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/chain-work#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/chain-work#java)

```java
WorkManager.getInstance()
    // Candidates to run in parallel
    .beginWith(Arrays.asList(filter1, filter2, filter3))
    // Dependent work (only runs after all previous work in chain)
    .then(compress)
    .then(upload)
    // Don't forget to enqueue()
    .enqueue();
```



#### Input Mergers

When using chains of `OneTimeWorkRequest`s, the output of parent `OneTimeWorkRequest`s are passed in as inputs to the children. So in the above example, the outputs of `filter1`, `filter2` and `filter3` would be passed in as inputs to the `compress` request.

In order to manage inputs from multiple parent `OneTimeWorkRequest`s, WorkManager uses [`InputMerger`](https://developer.android.com/reference/androidx/work/InputMerger)s.

There are two different types of `InputMerger`s provided by WorkManager:

- [`OverwritingInputMerger`](https://developer.android.com/reference/androidx/work/OverwritingInputMerger.html) attempts to add all keys from all inputs to the output. In case of conflicts, it overwrites the previously-set keys.
- [`ArrayCreatingInputMerger`](https://developer.android.com/reference/androidx/work/ArrayCreatingInputMerger.html) attempts to merge the inputs, creating arrays when necessary.

For the above example, given we want to preserve the outputs from all image filters, we should use an `ArrayCreatingInputMerger`.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/chain-work#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/chain-work#java)

```java
OneTimeWorkRequest compress =
    new OneTimeWorkRequest.Builder(CompressWorker.class)
        .setInputMerger(ArrayCreatingInputMerger.class)
        .setConstraints(constraints)
        .build();
```



#### Chaining and Work Statuses

There are a couple of things to keep in mind when creating chains of `OneTimeWorkRequest`s.

- Dependent `OneTimeWorkRequest`s are only *unblocked* (transition to `ENQUEUED`), when all its parent `OneTimeWorkRequest`s are successful (that is, they return a `Result.success()`).
- When any parent `OneTimeWorkRequest` fails (returns a `Result.failure()`, then all dependent `OneTimeWorkRequest`s are also marked as `FAILED`.
- When any parent `OneTimeWorkRequest` is cancelled, all dependent `OneTimeWorkRequest`s are also marked as `CANCELLED`.

For more information, see [Cancelling and Stopping Work](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/cancel-stop-work.html).

### Cancelling and stopping work

If you no longer need your previously-enqueued work to run, you can ask for it to be cancelled. The simplest way to do this is by cancelling a single WorkRequest using its `id` and calling [`WorkManager.cancelWorkById(UUID)`](https://developer.android.com/reference/androidx/work/WorkManager.html#cancelWorkById(java.util.UUID)):

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/cancel-stop-work#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/cancel-stop-work#java)

```java
WorkManager.cancelWorkById(workRequest.getId());
```



Under the hood, WorkManager will check the [`State`](https://developer.android.com/reference/androidx/work/WorkInfo.State.html) of the work. If the work is already [finished](https://developer.android.com/reference/androidx/work/WorkInfo.State.html#isFinished()), nothing will happen. Otherwise, its state will be changed to [`CANCELLED`](https://developer.android.com/reference/androidx/work/WorkInfo.State.html#CANCELLED) and the work will not run in the future. Any [`WorkRequests`](https://developer.android.com/reference/androidx/work/WorkRequest.html) that are [dependent on this work](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/chain-work.html) will also be `CANCELLED`.

In addition, if the work is currently [`RUNNING`](https://developer.android.com/reference/androidx/work/WorkInfo.State.html#RUNNING), the worker will also receive a call to [`ListenableWorker.onStopped()`](https://developer.android.com/reference/androidx/work/ListenableWorker.html#onStopped()). Override this method to handle any potential cleanup. We discuss this more at length [further below](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/cancel-stop-work#stopping).

You can also cancel WorkRequests by tag using [`WorkManager.cancelAllWorkByTag(String)`](https://developer.android.com/reference/androidx/work/WorkManager.html#cancelAllWorkByTag(java.lang.String)). Note that this method cancels *all* work with this tag. Additionally, you can cancel all work with a unique name using [`WorkManager.cancelUniqueWork(String)`](https://developer.android.com/reference/androidx/work/WorkManager.html#cancelUniqueWork(java.lang.String)).

#### Stopping a running worker

There are a few different reasons your running worker may be stopped by WorkManager:

- You explicitly asked for it to be cancelled (by calling `WorkManager.cancelWorkById(UUID)`, for example).
- In the case of [unique work](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/unique-work.html), you explicitly enqueued a new `WorkRequest` with an [`ExistingWorkPolicy`](https://developer.android.com/reference/androidx/work/ExistingWorkPolicy) of [`REPLACE`](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/'reference/androidx/work/ExistingWorkPolicy#REPLACE). The old `WorkRequest` is immediately considered terminated.
- Your work's constraints are no longer met.
- The system instructed your app to stop your work for some reason. This can happen if you exceed the execution deadline of 10 minutes. The work is scheduled for retry at a later time.

Under these conditions, your worker will receive a call to [`ListenableWorker.onStopped()`](https://developer.android.com/reference/androidx/work/ListenableWorker.html#onStopped()). You should perform cleanup and cooperatively finish your worker in case the OS decides to shut down your app. For example, you should close open handles to databases and files at this point, or do so at the earliest available time. In addition, you may consult [`ListenableWorker.isStopped()`](https://developer.android.com/reference/androidx/work/ListenableWorker.html#isStopped()) whenever you want to check if you've already been stopped. *Even if you signal completion of your work by returning a Result after onStopped() is called, WorkManager will ignore that Result because the worker is already considered stopped.*

You can see examples of how to handle `onStopped()` in the [Threading in WorkManager](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/threading.html) section.

### Handling Recurring work

Your application may at times require that certain tasks run periodically. For example, you may want to periodically backup your data, download fresh content in your app, or upload logs to a server.

Use the [`PeriodicWorkRequest`](https://developer.android.com/reference/androidx/work/PeriodicWorkRequest) for such tasks that need to execute periodically.

`PeriodicWorkRequest` cannot be [chained](https://developer.android.com/topic/libraries/architecture/how-to/chain-workers.md). If your task requires chaining of tasks, consider [`OneTimeWorkRequest`](https://developer.android.com/reference/androidx/work/OneTimeWorkRequest).

Here is how you can create a PeriodicWorkRequest:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/recurring-work#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/recurring-work#java)

```java
Constraints constraints = new Constraints.Builder()
        .setRequiresCharging(true)
        .build();

PeriodicWorkRequest saveRequest =
        new PeriodicWorkRequest.Builder(SaveImageFileWorker.class, 1, TimeUnit.HOURS)
                  .setConstraints(constraints)
                  .build();

WorkManager.getInstance()
    .enqueue(saveRequest);
```



The example showcases a periodic work request with a one hour repeat interval.

The repeat interval is defined as the minimum time between repetitions. The exact time that the worker is going to be executed depends on the constraints that you are using in your work request and on the optimizations done by the system.

In the example, the PeriodicWorkRequest also requires the device to be plugged in. In this case, even if the defined repeat interval of an hour passes, the PeriodicWorkRequest will run only when the device is plugged in.

**Note:** The minimum repeat interval that can be defined is 15 minutes (same as the [JobScheduler API](https://developer.android.com/reference/android/app/job/JobScheduler)).

You can observe the status of PeriodicWorkRequests the same way as OneTimeWorkRequests. Read more about [observing work](https://developer.android.com/topic/libraries/architecture/how-to/observe-work.md).

### Handling Unique work

Unique work is a powerful concept that guarantees that you only have one chain of work with a particular *name* at a time. Unlike `id`s, unique names are human-readable and specified by the developer instead being auto-generated by WorkManager. Unlike [tags](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/define-work#tag), unique names are only associated with *one* chain of work.

You can create a unique work sequence by calling [`WorkManager.enqueueUniqueWork(String, ExistingWorkPolicy, OneTimeWorkRequest)`](https://developer.android.com/reference/androidx/work/WorkManager.html#enqueueUniqueWork(java.lang.String, androidx.work.ExistingWorkPolicy, androidx.work.OneTimeWorkRequest)) or [`WorkManager.enqueueUniquePeriodicWork(String, ExistingPeriodicWorkPolicy, PeriodicWorkRequest)`](https://developer.android.com/reference/androidx/work/WorkManager.html#enqueueUniquePeriodicWork(java.lang.String, androidx.work.ExistingPeriodicWorkPolicy, androidx.work.PeriodicWorkRequest)). The first argument is the unique name - this is the key we use to identify the `WorkRequest`s. The second argument is the conflict resolution policy, which specifies what WorkManager should do if there's already an unfinished chain of work with that unique name:

- Cancel the existing chain and [`REPLACE`](https://developer.android.com/reference/androidx/work/ExistingWorkPolicy.html#REPLACE) it with the new one.
- [`KEEP`](https://developer.android.com/reference/androidx/work/ExistingWorkPolicy.html#KEEP) the existing sequence and ignore your new request.
- [`APPEND`](https://developer.android.com/reference/androidx/work/ExistingWorkPolicy.html#APPEND) your new sequence to the existing one, running the new sequence's first task after the existing sequence's last task finishes. You cannot use `APPEND` with `PeriodicWorkRequest`s.

Unique work can be useful if you have a task that shouldn't be enqueued multiple times. For example, if your app needs to sync its data to the network, you might enqueue a sequence named "sync", and specify that your new task should be ignored if there's already a sequence with that name. Unique work sequences can also be useful if you need to gradually build up a long chain of tasks. For example, a photo editing app might let users undo a long chain of actions. Each of those undo operations might take a while, but they have to be performed in the correct order. In this case, the app could create an "undo" chain and append each undo operation to the chain as needed.

Finally, if you need to create a chain of unique work, you can use [`WorkManager.beginUniqueWork(String, ExistingWorkPolicy, OneTimeWorkRequest)`](https://developer.android.com/reference/androidx/work/WorkManager?hl=en#beginUniqueWork(java.lang.String, androidx.work.ExistingWorkPolicy, androidx.work.OneTimeWorkRequest)) instead of `beginWith()`.

### Testing your Workers

#### Introduction and Setup

[WorkManager](https://developer.android.com/topic/libraries/architecture/workmanager/) provides a `work-testing` artifact which helps with unit testing of your workers for Android Instrumentation tests.

To use the `work-testing` artifact, you should add it as an `androidTestImplementation` dependency in `build.gradle`. For more information on this, look at the Declaring dependencies section in the [WorkManager release notes](https://developer.android.com/jetpack/androidx/releases/work#declaring_dependencies).

**Note:** WorkManager 2.1.0 provides new [`TestWorkerBuilder`](https://developer.android.com/reference/androidx/work/testing/TestWorkerBuilder) and [`TestListenableWorkerBuilder`](https://developer.android.com/reference/androidx/work/testing/TestListenableWorkerBuilder) classes, which let you test the business logic in your workers without having to initialize `WorkManager` with `WorkManagerTestInitHelper`. The classes are currently in alpha, but are not expected to change significantly before release. For more information, see [Testing with WorkManager 2.1.0 (alpha)](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing-210).

#### Concepts

`work-testing` provides a special implementation of WorkManager for test mode, which is initialized using [`WorkManagerTestInitHelper`](https://developer.android.com/reference/androidx/work/testing/WorkManagerTestInitHelper).

The `work-testing` artifact also provides a [`SynchronousExecutor`](https://developer.android.com/reference/androidx/work/testing/SynchronousExecutor.html) which makes it easier to write tests in a synchronous manner, without having to deal with multiple threads, locks or latches.

Here is an example on how to use all these classes together.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing#java)

```java
@RunWith(AndroidJUnit4.class)
public class BasicInstrumentationTest {
    @Before
    public void setup() {
        Context context = InstrumentationRegistry.getTargetContext();
        Configuration config = new Configuration.Builder()
                // Set log level to Log.DEBUG to
                // make it easier to see why tests failed
                .setMinimumLoggingLevel(Log.DEBUG)
                // Use a SynchronousExecutor to make it easier to write tests
                .setExecutor(new SynchronousExecutor())
                .build();

        // Initialize WorkManager for instrumentation tests.
        WorkManagerTestInitHelper.initializeTestWorkManager(
            context, config);
    }
}
```



#### Structuring Tests

Now that WorkManager has been initialized in test mode, you are ready to test your Workers.

Let’s say you have an `EchoWorker` which expects some `inputData`, and simply copies (echoes) its input to its `outputData`.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing#java)

```java
public class EchoWorker extends Worker {
  public EchoWorker(Context context, WorkerParameters parameters) {
      super(context, parameters);
  }

  @NonNull
  @Override
  public Result doWork() {
      Data input = getInputData();
      if (input.size() == 0) {
          return Result.failure();
      } else {
          return Result.success(input);
      }
  }
}
```



##### Basic Tests

Below is an Android Instrumentation test that tests `EchoWorker`. The main takeaway here is that testing`EchoWorker` in test mode is very similar to how you would use `EchoWorker` in a real application.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing#java)

```java
@Test
public void testSimpleEchoWorker() throws Exception {
   // Define input data
   Data input = new Data.Builder()
           .put(KEY_1, 1)
           .put(KEY_2, 2)
           .build();

   // Create request
   OneTimeWorkRequest request =
       new OneTimeWorkRequest.Builder(EchoWorker.class)
           .setInputData(input)
           .build();

   WorkManager workManager = WorkManager.getInstance();
   // Enqueue and wait for result. This also runs the Worker synchronously
   // because we are using a SynchronousExecutor.
   workManager.enqueue(request).getResult().get();
   // Get WorkInfo and outputData
   WorkInfo workInfo = workManager.getWorkInfoById(request.getId()).get();
   Data outputData = workInfo.getOutputData();
   // Assert
   assertThat(workInfo.getState(), is(WorkInfo.State.SUCCEEDED));
   assertThat(outputData, is(input));
}
```



Let’s write another test which makes sure that when `EchoWorker` gets no input data, the expected `Result` is a `Result.failure()`.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing#java)

```java
@Test
public void testEchoWorkerNoInput() throws Exception {
  // Create request
  OneTimeWorkRequest request =
      new OneTimeWorkRequest.Builder(EchoWorker.class)
         .build();

  WorkManager workManager = WorkManager.getInstance();
  // Enqueue and wait for result. This also runs the Worker synchronously
  // because we are using a SynchronousExecutor.
  workManager.enqueue(request).getResult().get();
  // Get WorkInfo
  WorkInfo workInfo = workManager.getWorkInfoById(request.getId()).get();
  // Assert
  assertThat(workInfo.getState(), is(WorkInfo.State.FAILED));
}
```



#### Simulating constraints, delays and periodic work

`WorkManagerTestInitHelper` provides you with an instance of [`TestDriver`](https://developer.android.com/reference/androidx/work/testing/TestDriver.html) which can be used to simulate `initialDelay`s, conditions where `Constraint`s are met for `ListenableWorker`s, and intervals for `PeriodicWorkRequest`s.

##### Testing Initial Delays

`Worker`’s can have initial delays. To test `EchoWorker` with an `initialDelay`, rather than having to wait for the `initialDelay` in your test, you can use the `TestDriver` to mark the `WorkRequest`s initial delay as met.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing#java)

```java
@Test
public void testWithInitialDelay() throws Exception {
  // Define input data
  Data input = new Data.Builder()
          .put(KEY_1, 1)
          .put(KEY_2, 2)
          .build();

  // Create request
  OneTimeWorkRequest request = new OneTimeWorkRequest.Builder(EchoWorker.class)
          .setInputData(input)
          .setInitialDelay(10, TimeUnit.SECONDS)
          .build();

  WorkManager workManager = WorkManager.getInstance();
  // Get the TestDriver
  TestDriver testDriver = WorkManagerTestInitHelper.getTestDriver();
  // Enqueue
  workManager.enqueue(request).getResult().get();
  // Tells the WorkManager test framework that initial delays are now met.
  testDriver.setInitialDelayMet(request.getId());
  // Get WorkInfo and outputData
  WorkInfo workInfo = workManager.getWorkInfoById(request.getId()).get();
  Data outputData = workInfo.getOutputData();
  // Assert
  assertThat(workInfo.getState(), is(WorkInfo.State.SUCCEEDED));
  assertThat(outputData, is(input));
}
```



##### Testing Constraints

`TestDriver` can also be used to mark constraints as met using `setAllConstraintsMet`. Here is an example on how you can test a `Worker` with constraints.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing#java)

```java
@Test
public void testWithConstraints() throws Exception {
    // Define input data
    Data input = new Data.Builder()
            .put(KEY_1, 1)
            .put(KEY_2, 2)
            .build();

    // Define constraints
    Constraints constraints = new Constraints.Builder()
            .setRequiresDeviceIdle(true)
            .build();

    // Create request
    OneTimeWorkRequest request = new OneTimeWorkRequest.Builder(EchoWorker.class)
            .setInputData(input)
            .setConstraints(constraints)
            .build();

    WorkManager workManager = WorkManager.getInstance();
    TestDriver testDriver = WorkManagerTestInitHelper.getTestDriver();
    // Enqueue
    workManager.enqueue(request).getResult().get();
    // Tells the testing framework that all constraints are met.
    testDriver.setAllConstraintsMet(request.getId());
    // Get WorkInfo and outputData
    WorkInfo workInfo = workManager.getWorkInfoById(request.getId()).get();
    Data outputData = workInfo.getOutputData();
    // Assert
    assertThat(workInfo.getState(), is(WorkInfo.State.SUCCEEDED));
    assertThat(outputData, is(input));
}
```



##### Testing Periodic Work

The `TestDriver` also exposes a `setPeriodDelayMet` which can be used to indicate that an interval is complete. Here is an example of `setPeriodDelayMet` being used.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing#java)

```java
@Test
public void testPeriodicWork() throws Exception {
    // Define input data
    Data input = new Data.Builder()
            .put(KEY_1, 1)
            .put(KEY_2, 2)
            .build();

    // Create request
    PeriodicWorkRequest request =
            new PeriodicWorkRequest.Builder(EchoWorker.class, 15, MINUTES)
            .setInputData(input)
            .build();

    WorkManager workManager = WorkManager.getInstance();
    TestDriver testDriver = WorkManagerTestInitHelper.getTestDriver();
    // Enqueue
    workManager.enqueue(request).getResult().get();
    // Tells the testing framework the period delay is met
    testDriver.setPeriodDelayMet(request.getId());
    // Get WorkInfo and outputData
    WorkInfo workInfo = workManager.getWorkInfoById(request.getId()).get();
    // Assert
    assertThat(workInfo.getState(), is(WorkInfo.State.ENQUEUED));
}
```

### Testing with WorkManager 2.1.0 (alpha)

Beginning with version 2.1.0, WorkManager provides new APIs that make it easier to test [`Worker`](https://developer.android.com/reference/kotlin/androidx/work/Worker),[`ListenableWorker`](https://developer.android.com/reference/androidx/work/ListenableWorker), and the `ListenableWorker` variants ([`CoroutineWorker`](https://developer.android.com/reference/kotlin/androidx/work/CoroutineWorker.html) and [`RxWorker`](https://developer.android.com/reference/androidx/work/RxWorker)).

Previously, to test your workers you needed to use [`WorkManagerTestInitHelper`](https://developer.android.com/reference/androidx/work/testing/WorkManagerTestInitHelper) to initialize WorkManager. With 2.1.0, using `WorkManagerTestInitHelper` is optional. You no longer need to use `WorkManagerTestInitHelper` if all you need to do is test the business logic in the `Worker`.

**Important:** The new functionality is still in alpha at this time. The functionality is not expected to change, but the API names may change as the feature enters beta.

#### Testing ListenableWorker and its variants

To test a [`ListenableWorker`](https://developer.android.com/reference/androidx/work/ListenableWorker) or its variants ([`CoroutineWorker`](https://developer.android.com/reference/kotlin/androidx/work/CoroutineWorker.html) and [`RxWorker`](https://developer.android.com/reference/androidx/work/RxWorker)), you can now use[`TestListenableWorkerBuilder`](https://developer.android.com/reference/androidx/work/testing/TestListenableWorkerBuilder). This builder helps build instances of `ListenableWorker` that can be used for the purpose of testing the `Worker`'s business logic.

For example, suppose we need to test a `CoroutineWorker` which looks like this:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing-210#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing-210#java)

```java
public class SleepWorker extends ListenableWorker {
    private final ResolvableFuture<Result> mResult;
    private final Handler mHandler;
    private final Object mLock;
    private Runnable mRunnable;
    public SleepWorker(
            @NonNull Context context,
            @NonNull WorkerParameters workerParameters) {
        super(context, workerParameters);
        mHandler = new Handler(Looper.getMainLooper());
        mResult = new ResolvableFuture<>();
        mLock = new Object();
    }

    @NonNull
    @Override
    public ListenableFuture<Result> startWork() {
        mRunnable = new Runnable() {
            @Override
            public void run() {
                synchronized (mLock) {
                    mResult.set(Result.success());
                }
            }
        };

        mHandler.postDelayed(mRunnable, 1000L);
        return mResult;
    }

    @Override
    public void onStopped() {
        super.onStopped();
        if (mRunnable != null) {
            mHandler.removeCallbacks(mRunnable);
        }
        synchronized (mLock) {
            if (!mResult.isDone()) {
                mResult.set(Result.failure());
            }
        }
    }
}
```



To test `SleepWorker`, we first create an instance of the Worker using `TestListenableWorkerBuilder`. This builder can also be used to set tags, `inputData`, `runAttemptCount`, and so on. For details, see the [`TestListenableWorker`](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/reference/androidx/work/testing/TestListenableWorkerBuilder)reference page.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing-210#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing-210#java)

```java
@RunWith(AndroidJUnit4.class)
public class SleepWorkerJavaTest {
    private Context mContext;

    @Before
    public void setUp() {
        mContext = ApplicationProvider.getApplicationContext();
    }

    @Test
    public void testSleepWorker() throws Exception {
       ListenableWorker worker =
           TestListenableWorkerBuilder.from(mContext, SleepWorker.class)
                   .build();

        Result result = worker.startWork().get();
        assertThat(result, is(Result.success()));
    }
}
```



#### Testing Workers

Let’s say we have a `Worker` which looks like this:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing-210#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing-210#java)

```java
public class SleepWorker extends Worker {
    public static final String SLEEP_DURATION = "SLEEP_DURATION";

    public SleepWorker(
            @NonNull Context context,
            @NonNull WorkerParameters workerParameters) {
        super(context, workerParameters);
    }

    @NonNull
    @Override
    public Result doWork() {
        try {
            long duration = getInputData().getLong(SLEEP_DURATION, 1000);
            Thread.sleep(duration);
        } catch (InterruptedException ignore) {
        }
        return Result.success();
    }
}
```



To test this `Worker`, you can now use [`TestWorkerBuilder`](https://developer.android.com/reference/androidx/work/testing/TestWorkerBuilder). The main difference between `TestWorkerBuilder` and a[`TestListenableWorkerBuilder`](https://developer.android.com/reference/androidx/work/testing/TestListenableWorkerBuilder) is, `TestWorkerBuilder` lets you specify the background `Executor` used to run the `Worker`.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing-210#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/testing-210#java)

```java
@RunWith(AndroidJUnit4.class)
public class SleepWorkerJavaTest {
    private Context mContext;
    private Executor mExecutor;

    @Before
    public void setUp() {
        mContext = ApplicationProvider.getApplicationContext();
        mExecutor = Executors.newSingleThreadExecutor();
    }

    @Test
    public void testSleepWorker() {
        Data inputData = new Data.Builder()
                .putLong("SLEEP_DURATION", 10_000L)
                .build();

        SleepWorker worker =
                (SleepWorker) TestWorkerBuilder.from(mContext,
                        SleepWorker.class,
                        mExecutor)
                        .setInputData(inputData)
                        .build();

        Result result = worker.doWork();
        assertThat(result, is(Result.success()));
    }
}
```



## Advanced Concept

### Custom WorkManager Configuration and Initialization

By default, WorkManager configures itself automatically when your app starts, using reasonable options that are suitable for most apps. If you require more control of how WorkManager manages and schedules work, you can customize the WorkManager configuration by initializing WorkManager yourself.

There are three initialization options:

- [Default initialization](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/custom-configuration#default)

  In most cases, the default initialization is all you need.

- [Custom initialization](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/custom-configuration#custom)

  For more precise control of WorkManager, you can specify your own configuration.

- [On-demand initialization](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/custom-configuration#on-demand)

  Beginning with WorkManager 2.1.0-alpha01, you can initialize the WorkManager when you first need it, instead of initializing it at app startup. This approach may help your app launch faster. On-demand initialization is the preferred approach beginning with 2.1.0-alpha01.

#### Default initialization

WorkManager uses a custom `ContentProvider` to initialize itself when your app starts. This code lives in the internal class `androidx.work.impl.WorkManagerInitializer`, and uses the default [`Configuration`](https://developer.android.com/reference/androidx/work/Configuration). The default initializer is automatically used unless you [explicitly disable it](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/custom-configuration#remove-default). The default initializer is suitable for most apps.

#### Custom initialization

If you want to control the initialization process, you must disable the default initializer, then define your own custom configuration.

##### Disabling the default initializer

To provide your own configuration, you must first remove the default initializer.

To do so, update [`AndroidManifest.xml`](https://developer.android.com/guide/topics/manifest/manifest-intro) using the merge rule `tools:node="remove"`:

```xml
<provider
    android:name="androidx.work.impl.WorkManagerInitializer"
    android:authorities="${applicationId}.workmanager-init"
    tools:node="remove" />
```



To learn more about using merge rules in your manifest, see the documentation on [merging multiple manifest files](https://developer.android.com/studio/build/manifest-merge).

##### Adding a custom configuration

Once the default initializer is removed, you can manually initialize WorkManager:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/custom-configuration#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/custom-configuration#java)

```java
// provide custom configuration
Configuration myConfig = new Configuration.Builder()
    .setMinimumLoggingLevel(android.util.Log.INFO)
    .build();

//initialize WorkManager
WorkManager.initialize(this, myConfig);
```



the [`WorkManager`](https://developer.android.com/reference/androidx/work/WorkManager) singleton. Make sure the initialization runs either in [`Application.onCreate()`](https://developer.android.com/reference/android/app/Application#onCreate()) or in a [`ContentProvider.onCreate()`](https://developer.android.com/reference/android/content/ContentProvider#onCreate()).

For the complete list of customizations available, see the [`Configuration.Builder()`](https://developer.android.com/reference/androidx/work/Configuration.Builder) reference documentation.

#### On-demand initialization

**Note:** On-demand initialization is available in [WorkManager 2.1.0-alpha01](https://developer.android.com/jetpack/androidx/releases/work#2.1.0-alpha01) and higher.

The most flexible way to provide a custom initialization for WorkManager is to use *on-demand initialization*. On-demand initialization lets you initialize WorkManager only when that component is needed, instead of every time the app starts up. Doing so moves WorkManager off your critical startup path, improving app startup performance.

To use on-demand initialization:

1. Edit `AndroidManifest.xml` and [disable the default initializer](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/custom-configuration#remove-default).
2. Have your `Application` class implement the [`Configuration.Provider`](https://developer.android.com/reference/androidx/work/Configuration.Provider) interface, and providing your own implementation of [`Configuration.Provider.getWorkManagerConfiguration()`](https://developer.android.com/reference/androidx/work/Configuration.Provider.html#getWorkManagerConfiguration())
3. When you need to use WorkManager, call the method [`WorkManager.getInstance(Context)`](https://developer.android.com/reference/androidx/work/WorkManager.html#getInstance(android.content.Context)). WorkManager calls your app's custom `getWorkManagerConfiguration()` method to discover its `Configuration`. (You do not need to call `WorkManager.initialize()` yourself.)

**Note:** If you call the deprecated no-parameter `WorkManager.getInstance()` method before WorkManager has been initialized, the method throws an exception. You should always use the `WorkManager.getInstance(Context)` method, even if you're not customizing WorkManager.

Here's an example of a custom `getWorkManagerConfiguration()` implementation:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/custom-configuration#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/custom-configuration#java)

```java
class MyApplication extends Application implements Configuration.Provider {
    @Override
    public Configuration getWorkManagerConfiguration() {
        return Configuration.Builder()
                .setMinimumLoggingLevel(android.util.Log.INFO)
                .build();
    }
}
```

### Threading in WorkManager

#### Overview

In [previous sections](https://developer.android.com/topic/libraries/architecture/workmanager/basics.html), we mentioned that WorkManager performs background work asynchronously on your behalf. The basic implementation addresses the demands of most apps. For more advanced use cases, such as correctly handling work being stopped, you should learn about threading and concurrency in WorkManager.

There are four different types of work primitives provided by WorkManager:

- [`Worker`](https://developer.android.com/reference/androidx/work/Worker.html) is the simplest implementation, and the one you have seen in previous sections. WorkManager automatically runs it on a background thread (that you can override). Read more about threading in `Worker`s in [Threading in Worker](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/worker.html).
- [`CoroutineWorker`](https://developer.android.com/reference/kotlin/androidx/work/CoroutineWorker.html) is the recommended implementation for Kotlin users. `CoroutineWorker`s expose a suspending function for background work. By default, they run a default `Dispatcher`, which you can customize. Read more about threading in `CoroutineWorker`s in [Threading in CoroutineWorker](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/coroutineworker.html).
- [`RxWorker`](https://developer.android.com/reference/androidx/work/RxWorker.html) is the recommended implementation for RxJava2 users. RxWorkers should be used if a lot of your existing asynchronous code is modelled in RxJava. As with all RxJava2 concepts, you are free to choose the threading strategy of your choice. Read more about threading in `RxWorker`s in [Threading in RxWorker](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/rxworker.html).
- [`ListenableWorker`](https://developer.android.com/reference/androidx/work/ListenableWorker.html) is the base class for `Worker`, `CoroutineWorker`, and `RxWorker`. It is intended for Java developers who have to interact with callback-based asynchronous APIs such as `FusedLocationProviderClient` and are not using RxJava2. Read more about threading in `ListenableWorker`s in [Threading in ListenableWorker](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/listenableworker.html).

#### Threading in Worker

When you use a [`Worker`](https://developer.android.com/reference/androidx/work/Worker.html), WorkManager automatically calls [`Worker.doWork()`](https://developer.android.com/reference/androidx/work/Worker.html#doWork()) on a background thread. The background thread comes from the `Executor` specified in WorkManager's [`Configuration`](https://developer.android.com/reference/androidx/work/Configuration.html). By default, WorkManager sets up an `Executor` for you - but you can also customize your own. For example, you can share an existing background `Executor` in your app, or create a single-threaded `Executor` to make sure all your background work executes serially, or even specify a `ThreadPool` with a different thread count. To customize the `Executor`, make sure you have enabled [manual initialization of WorkManager](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/custom-configuration.html). When configuring WorkManager, you can specify your `Executor` as follows:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/worker#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/worker#java)

```java
WorkManager.initialize(
    context,
    new Configuration.Builder()
        .setExecutor(Executors.newFixedThreadPool(8))
        .build());
```



Here is an example of a simple Worker that downloads the content of some websites sequentially:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/worker#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/worker#java)

```java
public class DownloadWorker extends Worker {

    public DownloadWorker(Context context, WorkerParameters params) {
        super(context, params);
    }

    @NonNull
    @Override
    public Result doWork() {
        for (int i = 0; i < 100; ++i) {
            try {
                downloadSynchronously("https://www.google.com");
            } catch (IOException e) {
                return Result.failure();
            }
        }

        return Result.success();
    }

}
```



Note that [`Worker.doWork()`](https://developer.android.com/reference/androidx/work/Worker.html#doWork()) is a synchronous call - you are expected to do the entirety of your background work in a blocking fashion and finish it by the time the method exits. If you call an asynchronous API in `doWork()` and return a [`Result`](https://developer.android.com/reference/androidx/work/ListenableWorker.Result.html), your callback may not operate properly. If you find yourself in this situation, consider using a [`ListenableWorker`](https://developer.android.com/reference/androidx/work/ListenableWorker.html) (see [Threading in ListenableWorker](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/listenableworker.html)).

When a currently running `Worker` is [stopped for any reason](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/cancel-stop-work.html), it receives a call to [`Worker.onStopped()`](https://developer.android.com/reference/androidx/work/ListenableWorker.html#onStopped()). Override this method or call [`Worker.isStopped()`](https://developer.android.com/reference/androidx/work/ListenableWorker.html#isStopped()) to checkpoint your code and free up resources when necessary. When the `Worker` in the example above is stopped, it may be in the middle of its loop of downloading items and will continue doing so even though it has been stopped. To optimize this behavior, you can do something like this:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/worker#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/advanced/worker#java)

```java
public class DownloadWorker extends Worker {

    public DownloadWorker(Context context, WorkerParameters params) {
        super(context, params);
    }

    @NonNull
    @Override
    public Result doWork() {
        for (int i = 0; i < 100; ++i) {
            if (isStopped()) {
                break;
            }

            try {
                downloadSynchronously("https://www.google.com");
            } catch (IOException e) {
                return Result.failure();
            }
        }

        return Result.success();
    }
}
```



Once a `Worker` has been stopped, it doesn't matter what you return from `Worker.doWork()`; the `Result` will be ignored.

#### Threading in CoroutineWorker

For Kotlin users, WorkManager provides first-class support for [coroutines](https://kotlinlang.org/docs/reference/coroutines-overview.html). To get started, include [`work-runtime-ktx` in your gradle file](https://developer.android.com/jetpack/androidx/releases/work#declaring_dependencies). Instead of extending [`Worker`](https://developer.android.com/reference/androidx/work/Worker.html), you should extend [`CoroutineWorker`](https://developer.android.com/reference/kotlin/androidx/work/CoroutineWorker.html), which has a slightly different API. For example, if you wanted to build a simple `CoroutineWorker` to perform some network operations, you would do the following:

```kotlin
class CoroutineDownloadWorker(context: Context, params: WorkerParameters) : CoroutineWorker(context, params) {

    override suspend fun doWork(): Result = coroutineScope {
        val jobs = (0 until 100).map {
            async {
                downloadSynchronously("https://www.google.com")
            }
        }

        // awaitAll will throw an exception if a download fails, which CoroutineWorker will treat as a failure
        jobs.awaitAll()
        Result.success()
    }
}
```



Note that [`CoroutineWorker.doWork()`](https://developer.android.com/reference/kotlin/androidx/work/CoroutineWorker.html#doWork()) is a *suspending* function. Unlike `Worker`, this code does *not* run on the `Executor` specified in your [`Configuration`](https://developer.android.com/reference/androidx/work/Configuration.html). Instead, it defaults to `Dispatchers.Default`. You can customize this by providing your own `CoroutineContext`. In the above example, you would probably want to do this work on `Dispatchers.IO`, as follows:

```kotlin
class CoroutineDownloadWorker(context: Context, params: WorkerParameters) : CoroutineWorker(context, params) {

    override val coroutineContext = Dispatchers.IO

    override suspend fun doWork(): Result = coroutineScope {
        val jobs = (0 until 100).map {
            async {
                downloadSynchronously("https://www.google.com")
            }
        }

        // awaitAll will throw an exception if a download fails, which CoroutineWorker will treat as a failure
        jobs.awaitAll()
        Result.success()
    }
}
```



`CoroutineWorker`s handle stoppages automatically by cancelling the coroutine and propagating the cancellation signals. You don't need to do anything special to handle [work stoppages](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/cancel-stop-work.html).

#### Threading in RxWorker

We provide interoperability between WorkManager and RxJava2. To get started, include [`work-rxjava2`dependency in addition to `work-runtime`](https://developer.android.com/jetpack/androidx/releases/work#declaring_dependencies) in your gradle file. Then, instead of extending `Worker`, you should extend `RxWorker`. Finally override the [`RxWorker.createWork()`](https://developer.android.com/reference/androidx/work/RxWorker.html#createWork()) method to return a `Single<Result>` indicating the [`Result`](https://developer.android.com/reference/androidx/work/ListenableWorker.Result.html) of your execution, as follows:

```java
public class RxDownloadWorker extends RxWorker {

    public RxDownloadWorker(Context context, WorkerParameters params) {
        super(context, params);
    }

    @Override
    public Single<Result> createWork() {
        return Observable.range(0, 100)
            .flatMap { download("https://www.google.com") }
            .toList()
            .map { Result.success() };
    }
}
```



Note that `RxWorker.createWork()` is *called* on the main thread, but the return value is *subscribed* on a background thread by default. You can override [`RxWorker.getBackgroundScheduler()`](https://developer.android.com/reference/androidx/work/RxWorker.html#getBackgroundScheduler()) to change the subscribing thread.

Stopping an `RxWorker` will dispose the `Observer`s properly, so you don't need to handle [work stoppages](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/cancel-stop-work.html) in any special way.

#### Threading in ListenableWorker

In certain situations, you may need to provide a custom threading strategy. For example, you may need to handle a callback-based asynchronous operation. In this case, you cannot simply rely on a `Worker` because it can't do the work in a blocking fashion. WorkManager supports this use case with [`ListenableWorker`](https://developer.android.com/reference/androidx/work/ListenableWorker.html).`ListenableWorker` is the lowest-level worker API; [`Worker`](https://developer.android.com/reference/androidx/work/Worker.html), [`CoroutineWorker`](https://developer.android.com/reference/androidx/work/CoroutineWorker.html), and [`RxWorker`](https://developer.android.com/reference/androidx/work/RxWorker.html) all derive from this class. A `ListenableWorker` only signals when the work should start and stop and leaves the threading entirely up to you. The start work signal is invoked on the main thread, so it is very important that you go to a background thread of your choice manually.

The abstract method [`ListenableWorker.startWork()`](https://developer.android.com/reference/androidx/work/ListenableWorker.html#startWork()) returns a `ListenableFuture` of the [`Result`](https://developer.android.com/reference/androidx/work/ListenableWorker.Result.html). A `ListenableFuture` is a lightweight interface: it is a `Future` that provides functionality for attaching listeners and propagating exceptions. In the `startWork` method, you are expected to return a `ListenableFuture`, which you will set with the `Result` of the operation once it's completed. You can create `ListenableFuture`s one of two ways:

1. If you use Guava, use `ListeningExecutorService`.
2. Otherwise, include [`councurrent-futures`](https://developer.android.com/jetpack/androidx/releases/concurrent#declaring_dependencies) in your gradle file and use [`CallbackToFutureAdapter`](https://developer.android.com/reference/androidx/concurrent/futures/CallbackToFutureAdapter.html).

If you wanted to execute some work based on an asynchronous callback, you would do something like this:

```java
public class CallbackWorker extends ListenableWorker {

    public CallbackWorker(Context context, WorkerParameters params) {
        super(context, params);
    }

    @NonNull
    @Override
    public ListenableFuture<Result> startWork() {
        return CallbackToFutureAdapter.getFuture(completer -> {
            Callback callback = new Callback() {
                int successes = 0;

                @Override
                public void onFailure(Call call, IOException e) {
                    completer.setException(e);
                }

                @Override
                public void onResponse(Call call, Response response) {
                    ++successes;
                    if (successes == 100) {
                        completer.set(Result.success());
                    }
                }
            };

            for (int i = 0; i < 100; ++i) {
                downloadAsynchronously("https://www.google.com", callback);
            }
            return callback;
        });
    }
}
```



What happens if your work is [stopped](https://developer.android.com/topic/libraries/architecture/workmanager/how-to/cancel-stop-work.html)? A `ListenableWorker`'s `ListenableFuture` is always cancelled when the work is expected to stop. Using a `CallbackToFutureAdapter`, you simply have to add a cancellation listener, as follows:

```java
public class CallbackWorker extends ListenableWorker {

    public CallbackWorker(Context context, WorkerParameters params) {
        super(context, params);
    }

    @NonNull
    @Override
    public ListenableFuture<Result> startWork() {
        return CallbackToFutureAdapter.getFuture(completer -> {
            Callback callback = new Callback() {
                int successes = 0;

                @Override
                public void onFailure(Call call, IOException e) {
                    completer.setException(e);
                }

                @Override
                public void onResponse(Call call, Response response) {
                    ++successes;
                    if (successes == 100) {
                        completer.set(Result.success());
                    }
                }
            };

            completer.addCancellationListener(cancelDownloadsRunnable, executor);

            for (int i = 0; i < 100; ++i) {
                downloadAsynchronously("https://www.google.com", callback);
            }
            return callback;
        });
    }
}
```

## Migrating from Firebase JobDispatcher to WorkManager

WorkManager is a library for scheduling and executing deferrable background work in Android. It is the recommended replacement for Firebase JobDispatcher. The following guide will walk you through the process of migrating your Firebase JobDispatcher implementation to WorkManager.

### Gradle setup

**Note:** The first step in migrating away from Firebase JobDispatcher is to include WorkManager’s latest gradle dependencies.

To import WorkManager into your Android project, see the instructions for declaring dependencies in the[WorkManager release notes](https://developer.android.com/jetpack/androidx/releases/work#declaring_dependencies).

### From JobService to Workers

[`FirebaseJobDispatcher`](https://github.com/firebase/firebase-jobdispatcher-android/blob/e609dabf6cbd0fcc2451b8515f095cfbc3d9450a/jobdispatcher/src/main/java/com/firebase/jobdispatcher/FirebaseJobDispatcher.java) uses a subclass of [`JobService`](https://github.com/firebase/firebase-jobdispatcher-android/blob/master/jobdispatcher/src/main/java/com/firebase/jobdispatcher/JobService.java) as an entry point for defining the work which needs to be done. You might be using `JobService` directly, or using [`SimpleJobService`](https://github.com/firebase/firebase-jobdispatcher-android/blob/master/jobdispatcher/src/main/java/com/firebase/jobdispatcher/SimpleJobService.java).

A `JobService` will look something like this:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#java)

```java
import com.firebase.jobdispatcher.JobParameters;
import com.firebase.jobdispatcher.JobService;

public class MyJobService extends JobService {
    @Override
    public boolean onStartJob(JobParameters job) {
        // Do some work here

        return false; // Answers the question: "Is there still work going on?"
    }

    @Override
    public boolean onStopJob(JobParameters job) {
        return false; // Answers the question: "Should this job be retried?"
    }
}
```



If you are using `SimpleJobService` you will have overridden `onRunJob()`, which returns a `@JobResult int` type.

The key difference is when you are using `JobService` directly, `onStartJob()` is called on the main thread, and it is the app’s responsibility to offload the work to a background thread. On the other hand, if you are using`SimpleJobService`, that service is responsible for executing your work on a background thread.

WorkManager has similar concepts. The fundamental unit of work in WorkManager is a [`ListenableWorker`](https://developer.android.com/reference/androidx/work/ListenableWorker). There are also other useful subtypes of workers like [`Worker`](https://developer.android.com/reference/androidx/work/Worker), [`RxWorker`](https://developer.android.com/reference/androidx/work/RxWorker), and `CoroutineWorker` (when using Kotlin coroutines).

#### JobService maps to a ListenableWorker

If you are using `JobService` directly, then the worker it maps to is a `ListenableWorker`. If you are using `SimpleJobService` then you should use `Worker` instead.

Let’s use the above example (`MyJobService`) and look at how we can convert it to a `ListenableWorker`.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#java)

```java
import android.content.Context;
import androidx.work.ListenableWorker;
import androidx.work.ListenableWorker.Result;
import androidx.work.WorkerParameters;
import com.google.common.util.concurrent.ListenableFuture;

class MyWorker extends ListenableWorker {

  public MyWorker(@NonNull Context appContext, @NonNull WorkerParameters params) {
    super(appContext, params);
  }

  @Override
  public ListenableFuture<ListenableWorker.Result> startWork() {
    // Do your work here.
    Data input = getInputData();

    // Return a ListenableFuture<>
  }

  @Override
  public void onStopped() {
    // Cleanup because you are being stopped.
  }
}
```



The basic unit of work in WorkManager is a `ListenableWorker`. Just like `JobService.onStartJob()`, `startWork()` is called on the main thread. Here `MyWorker` implements `ListenableWorker` and returns an instance of[`ListenableFuture`](https://google.github.io/guava/releases/21.0-rc1/api/docs/com/google/common/util/concurrent/ListenableFuture.html), which is used to signal work completion *asynchronously.* You should choose your own threading strategy here.

The `ListenableFuture` here eventually returns a `ListenableWorker.Result` type which can be one of `Result.success()`, `Result.success(Data outputData)`, `Result.retry()`, `Result.failure()`, or `Result.failure(Data outputData)`. For more information, please see the reference page for [`ListenableWorker.Result`](https://developer.android.com/reference/androidx/work/ListenableWorker.Result).

`onStopped()` is called to signal that the `ListenableWorker` needs to stop, either because the constraints are no longer being met (for example, because the network is no longer available), or because a `WorkManager.cancel…()`method was called. `onStopped()` may also be called if the OS decides to shut down your work for some reason.

#### SimpleJobService maps to a Worker

When using `SimpleJobService` the above worker will look like:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#java)

```java
import android.content.Context;
import androidx.work.Data;
import androidx.work.ListenableWorker.Result;
import androidx.work.Worker;
import androidx.work.WorkerParameters;

class MyWorker extends Worker {

  public MyWorker(@NonNull Context appContext, @NonNull WorkerParameters params) {
    super(appContext, params);
  }

  @Override
  public ListenableWorker.Result doWork() {
    // Do your work here.
    Data input = getInputData();

    // Return a ListenableWorker.Result
    Data outputData = new Data.Builder()
        .putString(“Key”, “value”)
        .build();
    return Result.success(outputData);
  }

  @Override
  public void onStopped() {
    // Cleanup because you are being stopped.
  }
}
```



Here `doWork()` returns an instance of `ListenableWorker.Result` to signal work completion synchronously. This is similar to `SimpleJobService`, which schedules jobs on a background thread.

### JobBuilder maps to WorkRequests

FirebaseJobBuilder uses `Job.Builder` to represent `Job` metadata. WorkManager uses [`WorkRequest`](https://developer.android.com/reference/androidx/work/WorkRequest) to fill this role.

WorkManager has two types of `WorkRequest`s: [`OneTimeWorkRequest`](https://developer.android.com/reference/androidx/work/OneTimeWorkRequest) and [`PeriodicWorkRequest`](https://developer.android.com/reference/androidx/work/PeriodicWorkRequest).

If you are currently using `Job.Builder.setRecurring(true)`, then you should create a new `PeriodicWorkRequest`. Otherwise, you should use a `OneTimeWorkRequest`.

Let’s look at what scheduling a complex `Job` with `FirebaseJobDispatcher` might look like:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#java)

```java
Bundle input = new Bundle();
input.putString("some_key", "some_value");

Job myJob = dispatcher.newJobBuilder()
    // the JobService that will be called
    .setService(MyJobService.class)
    // uniquely identifies the job
    .setTag("my-unique-tag")
    // one-off job
    .setRecurring(false)
    // don't persist past a device reboot
    .setLifetime(Lifetime.UNTIL_NEXT_BOOT)
    // start between 0 and 60 seconds from now
    .setTrigger(Trigger.executionWindow(0, 60))
    // don't overwrite an existing job with the same tag
    .setReplaceCurrent(false)
    // retry with exponential backoff
    .setRetryStrategy(RetryStrategy.DEFAULT_EXPONENTIAL)
    // constraints that need to be satisfied for the job to run
    .setConstraints(
        // only run on an unmetered network
        Constraint.ON_UNMETERED_NETWORK,
        // only run when the device is charging
        Constraint.DEVICE_CHARGING
    )
    .setExtras(input)
    .build();

dispatcher.mustSchedule(myJob);
```



To achieve the same with WorkManager you will need to:

- Build input data which can be used as input for the `Worker`.
- Build a `WorkRequest` with the input data and constraints similar to the ones defined above for `FirebaseJobDispatcher`.
- Enqueue the `WorkRequest`.

#### Setting up inputs for the Worker

`FirebaseJobDispatcher` uses a `Bundle` to send input data to the `JobService`. WorkManager uses [`Data`](https://developer.android.com/reference/androidx/work/Data.Builder) instead. So that becomes:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#java)

```java
import androidx.work.Data;
Data input = new Data.Builder()
    .putString("some_key", "some_value")
    .build();
```



#### Setting up Constraints for the Worker

`FirebaseJobDispatcher` uses [`Job.Builder.setConstaints(...)`](https://github.com/firebase/firebase-jobdispatcher-android/blob/master/jobdispatcher/src/main/java/com/firebase/jobdispatcher/Job.java#L287) to set up constraints on jobs. WorkManager uses[`Constraints`](https://developer.android.com/reference/androidx/work/Constraints) instead.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#java)

```java
import androidx.work.Constraints;
import androidx.work.Constraints.Builder;
import androidx.work.NetworkType;

Constraints constraints = new Constraints.Builder()
    // The Worker needs Network connectivity
    .setRequiredNetworkType(NetworkType.CONNECTED)
    // Needs the device to be charging
    .setRequiresCharging(true)
    .build();
```



#### Creating the WorkRequest (OneTime or Periodic)

To create `OneTimeWorkRequest`s and `PeriodicWorkRequest`s you should use [`OneTimeWorkRequest.Builder`](https://developer.android.com/reference/androidx/work/OneTimeWorkRequest.Builder) and [`PeriodicWorkRequest.Builder`](https://developer.android.com/reference/androidx/work/PeriodicWorkRequest.Builder).

To create a `OneTimeWorkRequest` which is similar to the above `Job` you should do the following:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#java)

```java
import androidx.work.BackoffCriteria;
import androidx.work.Constraints;
import androidx.work.Constraints.Builder;
import androidx.work.NetworkType;
import androidx.work.OneTimeWorkRequest;
import androidx.work.OneTimeWorkRequest.Builder;
import androidx.work.Data;

// Define constraints (as above)
Constraints constraints = ...
OneTimeWorkRequest request =
    // Tell which work to execute
    new OneTimeWorkRequest.Builder(MyWorker.class)
        // Sets the input data for the ListenableWorker
        .setInputData(inputData)
        // If you want to delay the start of work by 60 seconds
        .setInitialDelay(60, TimeUnit.SECONDS)
        // Set a backoff criteria to be used when retry-ing
        .setBackoffCriteria(BackoffCriteria.EXPONENTIAL, 30000, TimeUnit.MILLISECONDS)
        // Set additional constraints
        .setConstraints(constraints)
        .build();
```



The key difference here is that WorkManager’s jobs are always persisted across device reboot automatically.

If you want to create a `PeriodicWorkRequest` then you would do something like:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#java)

```java
import androidx.work.BackoffCriteria;
import androidx.work.Constraints;
import androidx.work.Constraints.Builder;
import androidx.work.NetworkType;
import androidx.work.PeriodicWorkRequest;
import androidx.work.PeriodicWorkRequest.Builder;
import androidx.work.Data;

// Define constraints (as above)
Constraints constraints = ...

PeriodicWorkRequest request =
    // Executes MyWorker every 15 minutes
    new PeriodicWorkRequest.Builder(MyWorker.class, 15, TimeUnit.MINUTES)
        // Sets the input data for the ListenableWorker
        .setInputData(input)
        . // other setters (as above)
        .build();
```



### Scheduling work

Now that you have defined a `Worker` and a `WorkRequest`, you are ready to schedule work.

Every `Job` defined with `FirebaseJobDispatcher` had a `tag` which was used to *uniquely identify* a `Job`. It also provided a way for the application to tell the scheduler if this instance of a `Job` was to replace an existing copy of the `Job` by calling `setReplaceCurrent`.

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#java)

```java
Job myJob = dispatcher.newJobBuilder()
    // the JobService that will be called
    .setService(MyJobService.class)
    // uniquely identifies the job
    .setTag("my-unique-tag")
    // don't overwrite an existing job with the same tag
    .setReplaceCurrent(false)
    // other setters
    // ...

dispatcher.mustSchedule(myJob);
```



When using WorkManager, you can achieve the same result by using `enqueueUniqueWork()` and `enqueueUniquePeriodicWork()` APIs (when using a `OneTimeWorkRequest` and a `PeriodicWorkRequest`, respectively). For more information, see the reference pages for [`WorkManager.enqueueUniqueWork()`](https://developer.android.com/reference/androidx/work/WorkManager#enqueueUniqueWork(java.lang.String, androidx.work.ExistingWorkPolicy, androidx.work.OneTimeWorkRequest)) and [`WorkManager.enqueueUniquePeriodicWork()`](https://developer.android.com/reference/androidx/work/WorkManager.html#enqueueUniquePeriodicWork(java.lang.String, androidx.work.ExistingPeriodicWorkPolicy, androidx.work.PeriodicWorkRequest)).

This will look something like:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#java)

```java
import androidx.work.ExistingWorkPolicy;
import androidx.work.OneTimeWorkRequest;
import androidx.work.WorkManager;

OneTimeWorkRequest workRequest = // a WorkRequest;
WorkManager.getInstance()
    // Use ExistingWorkPolicy.REPLACE to cancel and delete any existing pending
    // (uncompleted) work with the same unique name. Then, insert the newly-specified
    // work.
    .enqueueUniqueWork("my-unique-name", ExistingWorkPolicy.KEEP, workRequest);
```



**Note:** `Job` tags in FirebaseJobDispatcher map to `name`s of `WorkRequest`s for WorkManager.

### Cancelling work

With `FirebaseJobDispatcher` you could cancel work using:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#java)

```java
dispatcher.cancel("my-unique-tag");
```



When using WorkManager you can use:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/workmanager/migrating-fb#java)

```java
import androidx.work.WorkManager;
WorkManager.getInstance().cancelUniqueWork("my-unique-name");
```



### Initializing WorkManager

WorkManager needs to be initialized once per app, typically using a `ContentProvider` or an `Application.onCreate()`.

WorkManager typically initializes itself by using a `ContentProvider`. However, there are some subtle differences in defaults with regard to the size of the threadpool, and the number of workers that can be scheduled at a given time. So you might need to customize WorkManager.

Typically, this customization is done using [`WorkManager.initialize()`](https://developer.android.com/reference/androidx/work/WorkManager.html#initialize(android.content.Context, androidx.work.Configuration)). This allows you to customize the background `Executor` used to run `Worker`s, and the [`WorkerFactory`](https://developer.android.com/reference/androidx/work/WorkerFactory) used to construct `Workers`. (`WorkerFactory` is useful in the context of dependency injection). Please read the documentation for this method to make sure you stop automatic initialization of WorkManager.

For more information, see the documentation for `initialize()` and for [`Configuration.Builder`](https://developer.android.com/reference/androidx/work/Configuration.Builder).



## Additional resources

### Samples

- [WorkManagerSample](https://github.com/googlesamples/android-architecture-components/tree/master/WorkManagerSample), a simple image-processing app
- [Sunflower](https://github.com/googlesamples/android-sunflower), a demo app demonstrating best practices with various architecture components, including WorkManager.

### Codelabs

- Working with WorkManager [(Kotlin)](https://codelabs.developers.google.com/codelabs/android-workmanager-kt/) and [(Java)](https://codelabs.developers.google.com/codelabs/android-workmanager/)

### Videos

- [Working with WorkManager](https://www.youtube.com/watch?v=83a4rYXsDs0), from the 2018 Android Dev Summit

### Blogs

- [Introducing WorkManager](https://medium.com/androiddevelopers/introducing-workmanager-2083bcfc4712)
- [WorkManger Basics](https://medium.com/androiddevelopers/workmanager-basics-beba51e94048)









