# Saved State module for ViewModel

As mentioned in the [Saving UI States](https://developer.android.com/topic/libraries/architecture/saving-states#use_onsaveinstancestate_as_backup_to_handle_system-initiated_process_death) article, [`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html) objects can handle configuration changes so you don't need to worry about state in rotations or other cases. However, if you need to handle system-initiated process death, you may want to use [`onSaveInstanceState()`](https://developer.android.com/reference/android/app/Activity#onSaveInstanceState(android.os.Bundle)) as backup.

UI State is usually stored or referenced in [`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html) objects, not activities; so using [`onSaveInstanceState()`](https://developer.android.com/reference/android/app/Activity#onSaveInstanceState(android.os.Bundle))requires some boilerplate that this module can handle for you.

When the module is set up, [`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html) objects receive a [`SavedStateHandle`](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle.html) object via its constructor. This is a key-value map that will let you write and retrieve objects to and from the saved state. These values will persist after the process is killed by the system and remain available via the same object.

**Note:** State must be simple and lightweight. For complex or large data you should use [local persistence](https://developer.android.com/topic/libraries/architecture/saving-states#use_local_persistence_to_handle_process_death_for_complex_or_large_data).

## Setup and usage

To import the Saved State module into your Android project, see the instructions for declaring dependencies in the [Lifecycle release notes](https://developer.android.com/jetpack/androidx/releases/lifecycle#declaring_dependencies).

In order to set up a [`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html) to receive a SavedStateHandle you need to create them using a Factory that extends [`AbstractSavedStateVMFactory`](https://developer.android.com/reference/androidx/lifecycle/AbstractSavedStateVMFactory.html).

[KOTLIN](https://developer.android.com/topic/libraries/architecture/viewmodel-savedstate#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/viewmodel-savedstate#java)

```java
SavedStateViewModel vm = new ViewModelProvider(this, new SavedStateVMFactory(this))
        .get(SavedStateViewModel.class);
```



After that your ViewModel can have a constructor that receives a SavedStateHandle:

[KOTLIN](https://developer.android.com/topic/libraries/architecture/viewmodel-savedstate#kotlin)[JAVA](https://developer.android.com/topic/libraries/architecture/viewmodel-savedstate#java)

```java
public class SavedStateViewModel extends ViewModel {
    private SavedStateHandle mState;

    public SavedStateViewModel(SavedStateHandle savedStateHandle) {
        mState = savedStateHandle;
    }
    ...
}
```



## Storing and retrieving values

The [`SavedStateHandle`](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle.html) class has the methods you expect for a key-value map:

- `get(String key)`
- `contains(String key)`
- `remove(String key)`
- `set(String key, T value)`
- `keys()`

Also, there is a special method: [`getLiveData(String key)`](https://developer.android.com/reference/androidx/lifecycle/SavedStateHandle.html#getLiveData(java.lang.String)) that returns the value wrapped in a [`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData.html) observable.

## Acceptable classes

| Type/Class                | Array support    |
| ------------------------- | ---------------- |
| `double`                  | `double[]`       |
| `int`                     | `int[]`          |
| `long`                    | `long[]`         |
| `String`                  | `String[]`       |
| `byte`                    | `byte[]`         |
| `char`                    | `char[]`         |
| `CharSequence`            | `CharSequence[]` |
| `float`                   | `float[]`        |
| `Parcelable`              | `Parcelable[]`   |
| `Serializable`            | `Serializable[]` |
| `short`                   | `short[]`        |
| `SparseArray`             |                  |
| `Binder`                  |                  |
| `Bundle`                  |                  |
| `ArrayList`               |                  |
| `Size (only in API 21+)`  |                  |
| `SizeF (only in API 21+)` |                  |

## Additional resources

For further information about the Saved State module for [`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel.html), consult the following resources.

### Codelabs

- [Android lifecycle-aware components codelab](https://codelabs.developers.google.com/codelabs/android-lifecycles/#6)