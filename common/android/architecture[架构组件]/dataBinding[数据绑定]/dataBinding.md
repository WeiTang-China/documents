# 1、官方文档摘要

## 1.1、Get Started

The Data Binding Library offers both flexibility and broad compatibility—it's a support library, so you can use it with devices running Android 4.0 (API level 14) or higher.

### 1.1.1、Build environment

To configure your app to use data binding, add the `dataBinding` element to your `build.gradle` file in the app module, as shown in the following example:

```groovy
android {
    ...
    dataBinding {
        enabled = true
    }
}
```

**Note:** You must configure data binding for app modules that depend on libraries that use data binding, even if the app module doesn't directly use data binding.



## 1.2、Layouts and binding expressions

Data binding layout files are slightly different and start with a root tag of `layout` followed by a `data` element and a `view` root element. This view element is what your root would be in a non-binding layout file. The following code shows a sample layout file:

```xml
<?xml version="1.0" encoding="utf-8"?>
<layout xmlns:android="http://schemas.android.com/apk/res/android">
   <data>
       <variable name="user" type="com.example.User"/>
   </data>
   <LinearLayout
       android:orientation="vertical"
       android:layout_width="match_parent"
       android:layout_height="match_parent">
       <TextView android:layout_width="wrap_content"
           android:layout_height="wrap_content"
           android:text="@{user.firstName}"/>
       <TextView android:layout_width="wrap_content"
           android:layout_height="wrap_content"
           android:text="@{user.lastName}"/>
   </LinearLayout>
</layout>
```

### 1.2.1、Binding data

A binding class is generated for each layout file. By default, the name of the class is based on the name of the layout file, converting it to Pascal case and adding the *Binding* suffix to it. The above layout filename is`activity_main.xml` so the corresponding generated class is `ActivityMainBinding`.

In Activity:

```java
ActivityMainBinding binding = DataBindingUtil.setContentView(this, R.layout.activity_main);
// or
ActivityMainBinding binding = ActivityMainBinding.inflate(getLayoutInflater());
```

Inside a `Fragment`, `ListView`, or `RecyclerView` adapter:

```java
ListItemBinding binding = ListItemBinding.inflate(layoutInflater, viewGroup, false);
// or
ListItemBinding binding = DataBindingUtil.inflate(layoutInflater, R.layout.list_item, viewGroup, false);
```

### 1.2.2、Expression language

#### Common features

The expression language looks a lot like expressions found in managed code. You can use the following operators and keywords in the expression language:

- Mathematical `+ - / * %`
- String concatenation `+`
- Logical `&& ||`
- Binary `& | ^`
- Unary `+ - ! ~`
- Shift `>> >>> <<`
- Comparison `== > < >= <=` (Note that `<` needs to be escaped as `&lt;`)
- `instanceof`
- Grouping `()`
- Literals - character, String, numeric, `null`
- Cast
- Method calls
- Field access
- Array access `[]`
- Ternary operator `?:`

Examples:

```xml
android:text="@{String.valueOf(index + 1)}"
android:visibility="@{age > 13 ? View.GONE : View.VISIBLE}"
android:transitionName='@{"image_" + id}'
```

#### Missing operations

The following operations are missing from the expression syntax that you can use in managed code:

- `this`
- `super`
- `new`
- Explicit generic invocation

#### Null coalescing operator

The null coalescing operator (`??`) chooses the left operand if it isn't `null` or the right if the former is `null`.

```xml
android:text="@{user.displayName ?? user.lastName}"
```

This is functionally equivalent to:

```xml
android:text="@{user.displayName != null ? user.displayName : user.lastName}"
```

#### Property Reference

An expression can reference a property in a class by using the following format, which is the same for fields, getters, and [`ObservableField`](https://developer.android.com/reference/androidx/databinding/ObservableField.html) objects:

```xml
android:text="@{user.lastName}"
```

#### Avoiding null pointer exceptions

Generated data binding code automatically checks for `null` values and avoid null pointer exceptions. For example, in the expression `@{user.name}`, if `user` is null, `user.name` is assigned its default value of `null`. If you reference `user.age`, where age is of type `int`, then data binding uses the default value of `0`.

#### Collections

Common collections, such as arrays, lists, sparse lists, and maps, can be accessed using the `[]` operator for convenience.

```xml
<data>
    <import type="android.util.SparseArray"/>
    <import type="java.util.Map"/>
    <import type="java.util.List"/>
    <variable name="list" type="List&lt;String>"/>
    <variable name="sparse" type="SparseArray&lt;String>"/>
    <variable name="map" type="Map&lt;String, String>"/>
    <variable name="index" type="int"/>
    <variable name="key" type="String"/>
</data>
…
android:text="@{list[index]}"
…
android:text="@{sparse[index]}"
…
android:text="@{map[key]}"
```

**Note:** For the XML to be syntactically correct, you have to escape the `<` characters. For example: instead of`List<String>` you have to write `List&lt;String>`.

You can also refer to a value in the map using the `object.key` notation. For example, `@{map[key]}` in the example above can be replaced with `@{map.key}`.

#### String literals

You can use single quotes to surround the attribute value, which allows you to use double quotes in the expression, as shown in the following example:

```xml
android:text='@{map["firstName"]}'
```

It is also possible to use double quotes to surround the attribute value. When doing so, string literals should be surrounded with back quotes ```:

```xml
android:text="@{map[`firstName`]}"
```

#### Resources

You can access resources in an expression by using the following syntax:

```xml
android:padding="@{large? @dimen/largePadding : @dimen/smallPadding}"
```

Format strings and plurals may be evaluated by providing parameters:

```xml
android:text="@{@string/nameFormat(firstName, lastName)}"
android:text="@{@plurals/banana(bananaCount)}"
```

When a plural takes multiple parameters, all parameters should be passed:

```xml
  Have an orange
  Have %d oranges

android:text="@{@plurals/orange(orangeCount, orangeCount)}"
```

Some resources require explicit type evaluation, as shown in the following table:

| Type              | Normal reference | Expression reference |
| ----------------- | ---------------- | -------------------- |
| String[]          | @array           | @stringArray         |
| int[]             | @array           | @intArray            |
| TypedArray        | @array           | @typedArray          |
| Animator          | @animator        | @animator            |
| StateListAnimator | @animator        | @stateListAnimator   |
| color int         | @color           | @color               |
| ColorStateList    | @color           | @colorStateList      |

### 1.2.3、Event handling

Data binding allows you to write expression handling events that are dispatched from the views (for example, the `onClick()` method). Event attribute names are determined by the name of the listener method with a few exceptions. For example, `View.OnClickListener` has a method `onClick()`, so the attribute for this event is `android:onClick`.

There are some specialized event handlers for the click event that need an attribute other than `android:onClick`to avoid a conflict. You can use the following attributes to avoid these type of conflicts:

| Class          | Listener setter                                   | Attribute               |
| -------------- | ------------------------------------------------- | ----------------------- |
| `SearchView`   | `setOnSearchClickListener(View.OnClickListener)`  | `android:onSearchClick` |
| `ZoomControls` | `setOnZoomInClickListener(View.OnClickListener)`  | `android:onZoomIn`      |
| `ZoomControls` | `setOnZoomOutClickListener(View.OnClickListener)` | `android:onZoomOut`     |

You can use the following mechanisms to handle an event:

- [Method references](https://developer.android.com/topic/libraries/data-binding/expressions#method_references): In your expressions, you can reference methods that conform to the signature of the listener method. When an expression evaluates to a method reference, Data binding wraps the method reference and owner object in a listener, and sets that listener on the target view. If the expression evaluates to `null`, Data binding doesn't create a listener and sets a `null` listener instead.
- [Listener bindings](https://developer.android.com/topic/libraries/data-binding/expressions#listener_bindings): These are lambda expressions that are evaluated when the event happens. Data binding always creates a listener, which it sets on the view. When the event is dispatched, the listener evaluates the lambda expression.

#### Method references

Events can be bound to handler methods directly, similar to the way [`android:onClick`](https://developer.android.com/reference/android/view/View.html#attr_android:onClick) can be assigned to a method in an activity. One major advantage compared to the `View` `onClick` attribute is that the expression is processed at compile time, so if the method doesn't exist or its signature is incorrect, you receive a compile time error.

The major difference between method references and listener bindings is that the actual listener implementation is created when the data is bound, not when the event is triggered. If you prefer to evaluate the expression when the event happens, you should use [listener binding](https://developer.android.com/topic/libraries/data-binding/expressions#listener_bindings).

To assign an event to its handler, use a normal binding expression, with the value being the method name to call. For example, consider the following example layout data object:

```java
public class MyHandlers {
    public void onClickFriend(View view) { ... }
}
```

The binding expression can assign the click listener for a view to the `onClickFriend()` method, as follows:

```xml
<?xml version="1.0" encoding="utf-8"?>
<layout xmlns:android="http://schemas.android.com/apk/res/android">
   <data>
       <variable name="handlers" type="com.example.MyHandlers"/>
       <variable name="user" type="com.example.User"/>
   </data>
   <LinearLayout
       android:orientation="vertical"
       android:layout_width="match_parent"
       android:layout_height="match_parent">
       <TextView android:layout_width="wrap_content"
           android:layout_height="wrap_content"
           android:text="@{user.firstName}"
           android:onClick="@{handlers::onClickFriend}"/>
   </LinearLayout>
</layout>
```

**Note:** The signature of the method in the expression must exactly match the signature of the method in the listener object.

#### Listener bindings

Listener bindings are binding expressions that run when an event happens. They are similar to method references, but they let you run arbitrary data binding expressions. This feature is available with Android Gradle Plugin for Gradle version 2.0 and later.

In method references, the parameters of the method must match the parameters of the event listener. In listener bindings, only your return value must match the expected return value of the listener (unless it is expecting void). For example, consider the following presenter class that has the `onSaveClick()` method:

```java
public class Presenter {
    public void onSaveClick(Task task){}
}
```

Then you can bind the click event to the `onSaveClick()` method, as follows:

```xml
<?xml version="1.0" encoding="utf-8"?>
<layout xmlns:android="http://schemas.android.com/apk/res/android">
    <data>
        <variable name="task" type="com.android.example.Task" />
        <variable name="presenter" type="com.android.example.Presenter" />
    </data>
    <LinearLayout android:layout_width="match_parent" android:layout_height="match_parent">
        <Button android:layout_width="wrap_content" android:layout_height="wrap_content"
        android:onClick="@{() -> presenter.onSaveClick(task)}" />
    </LinearLayout>
</layout>
```

When a callback is used in an expression, data binding automatically creates the necessary listener and registers it for the event. When the view fires the event, data binding evaluates the given expression. As in regular binding expressions, you still get null and thread safety of data binding while these listener expressions are being evaluated.

In the example above, we haven't defined the `view` parameter that is passed to `onClick(View)`. Listener bindings provide two choices for listener parameters: you can either ignore all parameters to the method or name all of them. If you prefer to name the parameters, you can use them in your expression. For example, the expression above could be written as follows:

```xml
android:onClick="@{(view) -> presenter.onSaveClick(task)}"
```

Or if you want to use the parameter in the expression, it could work as follows:

```java
public class Presenter {
    public void onSaveClick(View view, Task task){}
}
```

```xml
android:onClick="@{(theView) -> presenter.onSaveClick(theView, task)}"
```

You can use a lambda expression with more than one parameter:

```java
public class Presenter {
    public void onCompletedChanged(Task task, boolean completed){}
}
```

```xml
<CheckBox android:layout_width="wrap_content" android:layout_height="wrap_content"
      android:onCheckedChanged="@{(cb, isChecked) -> presenter.completeChanged(task, isChecked)}" />
```

If the event you are listening to returns a value whose type isn't `void`, your expressions must return the same type of value as well. For example, if you want to listen for the long click event, your expression should return a boolean.

```java
public class Presenter {
    public boolean onLongClick(View view, Task task) { }
}
```

```xml
android:onLongClick="@{(theView) -> presenter.onLongClick(theView, task)}"
```

If the expression cannot be evaluated due to `null` objects, data binding returns the default value for that type. For example, `null` for reference types, `0` for `int`, `false` for `boolean`, etc.

If you need to use an expression with a predicate (for example, ternary), you can use `void` as a symbol.

```xml
android:onClick="@{(v) -> v.isVisible() ? doSomething() : void}"
```

#### Avoid complex listeners

Listener expressions are very powerful and can make your code very easy to read. On the other hand, listeners containing complex expressions make your layouts hard to read and maintain. These expressions should be as simple as passing available data from your UI to your callback method. You should implement any business logic inside the callback method that you invoked from the listener expression.

### 1.2.4、Imports, variables, and includes

The Data Binding Library provides features such as imports, variables, and includes. Imports make easy to reference classes inside your layout files. Variables allow you to describe a property that can be used in binding expressions. Includes let you reuse complex layouts across your app.

#### Imports

Imports allow you to easily reference classes inside your layout file, just like in managed code. Zero or more `import` elements may be used inside the `data` element. The following code example imports the `View` class to the layout file:

```xml
<data>
    <import type="android.view.View"/>
</data>
```

Importing the `View` class allows you to reference it from your binding expressions. The following example shows how to reference the `VISIBLE` and `GONE` constants of the `View` class:

```xml
<TextView
   android:text="@{user.lastName}"
   android:layout_width="wrap_content"
   android:layout_height="wrap_content"
   android:visibility="@{user.isAdult ? View.VISIBLE : View.GONE}"/>
```

Type aliases

When there are class name conflicts, one of the classes may be renamed to an alias. The following example renames the `View` class in the `com.example.real.estate` package to `Vista`:

```xml
<import type="android.view.View"/>
<import type="com.example.real.estate.View"
        alias="Vista"/>
```

You can use `Vista` to reference the `com.example.real.estate.View` and `View` may be used to reference `android.view.View` within the layout file.

Import other classes

Imported types can be used as type references in variables and expressions. The following example shows `User`and `List` used as the type of a variable:

```xml
<data>
    <import type="com.example.User"/>
    <import type="java.util.List"/>
    <variable name="user" type="User"/>
    <variable name="userList" type="List&lt;User>"/>
</data>
```

**Caution:** Android Studio doesn't yet handle imports so the autocomplete for imported variables may not work in your IDE. Your app still compiles and you can work around the IDE issue by using fully qualified names in your variable definitions.

You can also use the imported types to cast part of an expression. The following example casts the `connection`property to a type of `User`:

```xml
<TextView
   android:text="@{((User)(user.connection)).lastName}"
   android:layout_width="wrap_content"
   android:layout_height="wrap_content"/>
```

Imported types may also be used when referencing static fields and methods in expressions. The following code imports the `MyStringUtils` class and references its `capitalize` method:

```xml
<data>
    <import type="com.example.MyStringUtils"/>
    <variable name="user" type="com.example.User"/>
</data>
…
<TextView
   android:text="@{MyStringUtils.capitalize(user.lastName)}"
   android:layout_width="wrap_content"
   android:layout_height="wrap_content"/>
```

Just as in managed code, `java.lang.*` is imported automatically.

#### Variables

You can use multiple `variable` elements inside the `data` element. Each `variable` element describes a property that may be set on the layout to be used in binding expressions within the layout file. The following example declares the `user`, `image`, and `note` variables:

```xml
<data>
    <import type="android.graphics.drawable.Drawable"/>
    <variable name="user" type="com.example.User"/>
    <variable name="image" type="Drawable"/>
    <variable name="note" type="String"/>
</data>
```

The variable types are inspected at compile time, so if a variable implements [`Observable`](https://developer.android.com/reference/androidx/databinding/Observable.html) or is an [observable collection](https://developer.android.com/topic/libraries/data-binding/observability.html#observable_collections), that should be reflected in the type. If the variable is a base class or interface that doesn't implement the `Observable` interface, the variables *are not* observed.

When there are different layout files for various configurations (for example, landscape or portrait), the variables are combined. There must not be conflicting variable definitions between these layout files.

The generated binding class has a setter and getter for each of the described variables. The variables take the default managed code values until the setter is called—`null` for reference types, `0` for `int`, `false` for `boolean`, etc.

A special variable named `context` is generated for use in binding expressions as needed. The value for `context`is the `Context` object from the root View's `getContext()` method. The `context` variable is overridden by an explicit variable declaration with that name.

#### Includes

Variables may be passed into an included layout's binding from the containing layout by using the app namespace and the variable name in an attribute. The following example shows included `user` variables from the `name.xml` and `contact.xml` layout files:

```xml
<?xml version="1.0" encoding="utf-8"?>
<layout xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:bind="http://schemas.android.com/apk/res-auto">
   <data>
       <variable name="user" type="com.example.User"/>
   </data>
   <LinearLayout
       android:orientation="vertical"
       android:layout_width="match_parent"
       android:layout_height="match_parent">
       <include layout="@layout/name"
           bind:user="@{user}"/>
       <include layout="@layout/contact"
           bind:user="@{user}"/>
   </LinearLayout>
</layout>
```

Data binding doesn't support include as a direct child of a merge element. For example, *the following layout isn't supported:*

```xml
<?xml version="1.0" encoding="utf-8"?>
<layout xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:bind="http://schemas.android.com/apk/res-auto">
   <data>
       <variable name="user" type="com.example.User"/>
   </data>
   <merge><!-- Doesn't work -->
       <include layout="@layout/name"
           bind:user="@{user}"/>
       <include layout="@layout/contact"
           bind:user="@{user}"/>
   </merge>
</layout>
```



## 1.3、Work with observable data objects

可观察性是指对象通知其他人数据变化的能力。 data-binding库允许您使对象，字段或集合可观察。

任何普通对象都可用于数据绑定，但修改对象不会自动导致UI更新。 data-binding提供在数据更改时通知其他对象（listeners）的能力。有三种不同类型的可观察类：[objects](https://developer.android.com/topic/libraries/data-binding/observability#observable_objects)，[fields](https://developer.android.com/topic/libraries/data-binding/observability#observable_fields)和[collections](https://developer.android.com/topic/libraries/data-binding/observability#observable_collections)。

当其中一个可观察数据对象绑定到UI并且数据对象的属性发生更改时，UI将自动更新。

### 1.3.1、Observable fields

有些工作涉及创建实现[`Observable`](https://developer.android.com/reference/androidx/databinding/Observable.html)接口的类（可能不值得，如果你的类只有少量属性）。 在这种情况下，您可以使用通用[`Observable`](https://developer.android.com/reference/androidx/databinding/Observable.html)类和以下特定于原语primitive的类来使字段可观察：

- [`ObservableBoolean`](https://developer.android.com/reference/androidx/databinding/ObservableBoolean.html)
- [`ObservableByte`](https://developer.android.com/reference/androidx/databinding/ObservableByte.html)
- [`ObservableChar`](https://developer.android.com/reference/androidx/databinding/ObservableChar.html)
- [`ObservableShort`](https://developer.android.com/reference/androidx/databinding/ObservableShort.html)
- [`ObservableInt`](https://developer.android.com/reference/androidx/databinding/ObservableInt.html)
- [`ObservableLong`](https://developer.android.com/reference/androidx/databinding/ObservableLong.html)
- [`ObservableFloat`](https://developer.android.com/reference/androidx/databinding/ObservableFloat.html)
- [`ObservableDouble`](https://developer.android.com/reference/androidx/databinding/ObservableDouble.html)
- [`ObservableParcelable`](https://developer.android.com/reference/androidx/databinding/ObservableParcelable.html)

可观察字段是具有单个字段的自包含可观察对象。 原生primitive类型在访问操作期间避免装箱和拆箱。 要使用此机制，请在Java编程语言中创建一个`public final`属性，或在Kotlin中创建一个只读属性，如以下示例所示：

```java
private static class User {
    public final ObservableField<String> firstName = new ObservableField<>();
    public final ObservableField<String> lastName = new ObservableField<>();
    public final ObservableInt age = new ObservableInt();
}
```

要访问字段值，请使用[`set（）`](https://developer.android.com/reference/androidx/databinding/ObservableField.html#set)和[`get（）`](https://developer.android.com/reference/androidx/databinding/ObservableField.html#get)访问器方法，如下：

```java
user.firstName.set("Google");
int age = user.age.get();
```

**Note:** Android Studio 3.1及更高版本允许您使用LiveData对象替换可观察字段，这为您的应用提供了额外的好处。 有关详细信息，请参阅[使用LiveData通知UI有关数据更改](https://developer.android.com/topic/libraries/data-binding/architecture.html#livedata)。

### 1.3.2、Observable collections

一些应用程序使用动态结构来保存数据。 可观察集合允许使用key访问这些数据。 当key是引用类型时，例如`String`，[`ObservableArrayMap`](https://developer.android.com/reference/androidx/databinding/ObservableArrayMap.html)类很有用，如下例所示：

```java
ObservableArrayMap<String, Object> user = new ObservableArrayMap<>();
user.put("firstName", "Google");
user.put("lastName", "Inc.");
user.put("age", 17);
```

在layout文件中，可以使用字符串key访问map，如下所示：

```xml
<data>
    <import type="android.databinding.ObservableMap"/>
    <variable name="user" type="ObservableMap<String, Object>"/>
</data>
…
<TextView
    android:text="@{user.lastName}"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"/>
<TextView
    android:text="@{String.valueOf(1 + (Integer)user.age)}"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"/>
```

当key是integer类型时，可以使用[`ObservableArrayList`](https://developer.android.com/reference/androidx/databinding/ObservableArrayList.html)类，如下所示：

```java
ObservableArrayList<Object> user = new ObservableArrayList<>();
user.add("Google");
user.add("Inc.");
user.add(17);
```

在layout文件中，集合对象可以通过下标访问，如下所示：

```xml
<data>
    <import type="android.databinding.ObservableList"/>
    <import type="com.example.my.app.Fields"/>
    <variable name="user" type="ObservableList<Object>"/>
</data>
…
<TextView
    android:text='@{user[Fields.LAST_NAME]}'
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"/>
<TextView
    android:text='@{String.valueOf(1 + (Integer)user[Fields.AGE])}'
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"/>
```

### 1.3.3、Observable objects

实现[`Observable`](https://developer.android.com/reference/androidx/databinding/Observable.html)接口的类可以注册listener，当属性被更改时会得到通知。

[`Observable`](https://developer.android.com/reference/androidx/databinding/Observable.html)有添加和删除侦听器的方法，但您必须决定何时发送通知。 为了简化开发，data-binding库提供了[`BaseObservable`](https://developer.android.com/reference/androidx/databinding/BaseObservable.html)类（它是`Observable`的子类），实现了侦听器注册机制。 实现`BaseObservable`的数据类负责通知属性何时发生变化。 通过为`getter`分配[`Bindable`](https://developer.android.com/reference/androidx/databinding/Bindable.html)注解和在`setter`中调用[`notifyPropertyChanged()`](https://developer.android.com/reference/androidx/databinding/BaseObservable.html#notifyPropertyChanged(int))方法来实现，如下例所示：

```java
private static class User extends BaseObservable {
    private String firstName;
    private String lastName;

    @Bindable
    public String getFirstName() {
        return this.firstName;
    }

    @Bindable
    public String getLastName() {
        return this.lastName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
        notifyPropertyChanged(BR.firstName);
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
        notifyPropertyChanged(BR.lastName);
    }
}
```

data-binding生成一个名为`BR`的类，该类包含用于data-binding的资源的ID。 [`Bindable`](https://developer.android.com/reference/androidx/databinding/Bindable.html)注解在编译期间在`BR`类文件中生成一个条目。如果无法更改数据类的基类，则可以implement[`Observable`](https://developer.android.com/reference/androidx/databinding/Observable.html)接口，并使用[`PropertyChangeRegistry`]（(https://developer.android.com/reference/androidx/databinding/PropertyChangeRegistry.html)来实现注册和通知listener。（参考一下[`BaseObservable`](https://developer.android.com/reference/androidx/databinding/BaseObservable.html)类的实现）



## 1.4、Generated binding classes

data-binding库将会生成用于访问布局的变量和视图的binding类。 本章节介绍如何创建和自定义生成的binding类。

生成的binding类将布局变量与布局中的视图链接起来。binding类的名称和包可以[自定义](https://developer.android.com/topic/libraries/data-binding/generated-binding#custom_binding_class_names)。所有生成的binding类都继承自[`ViewDataBinding`](https://developer.android.com/reference/androidx/databinding/ViewDataBinding.html)类。

binding类从每个布局文件生成而来。 默认情况下，binding类的名称基于布局文件的名称，并将布局文件的名称转换为Pascal大小写并向其添加*Binding*后缀。上面例子中的布局文件名是`active_main.xml`，所以相应生成的binding类是`ActivityMainBinding`。 此类包含布局属性（例如，`user`变量）到布局视图的所有绑定，并知道如何为binding表达式赋值。

### 1.4.1、Create a binding object

在inflate layout之后应该马上创建binding类的实例，以确保它在绑定给那些带有表达式的视图之前，视图层次结构不会被修改。最常用的绑定方法是使用binding类上的static方法。你可以使用`inflate()`方法来inflate视图并且绑定它，如下所示：

```java
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    MyLayoutBinding binding = MyLayoutBinding.inflate(getLayoutInflater());
}
```

还有一个替换版本的`inflate()`方法，它接受一个`ViewGroup`对象，如下所示：

```java
MyLayoutBinding binding = MyLayoutBinding.inflate(getLayoutInflater(), viewGroup, false);
```

如果使用不同的机制已经完成layout的inflate，则可以单独绑定，如下所示：

```java
MyLayoutBinding binding = MyLayoutBinding.bind(viewRoot);
```

有时不知道绑定类型，则可以使用[`DataBindingUtil`](https://developer.android.com/reference/androidx/databinding/DataBindingUtil.html)类创建绑定，如下所示：

```java
View viewRoot = LayoutInflater.from(this).inflate(layoutId, parent, attachToParent);
ViewDataBinding binding = DataBindingUtil.bind(viewRoot);
```

如果你在`Fragment`，`ListView`或`RecyclerView`的Adapter中使用data-binding项，使用binding类的或者[`DataBindingUtil`](https://developer.android.com/reference/androidx/databinding/DataBindingUtil)类的[`inflate()`](https://developer.android.com/reference/androidx/databinding/DataBindingUtil.html#inflate(android.view.LayoutInflater, int, android.view.ViewGroup, boolean, android.databinding.DataBindingComponent))方法将会更合适，如下所示：

```java
ListItemBinding binding = ListItemBinding.inflate(layoutInflater, viewGroup, false);
// or
ListItemBinding binding = DataBindingUtil.inflate(layoutInflater, R.layout.list_item, viewGroup, false);
```



### 1.4.2、Views with IDs

data-binding库在binding类中为每个layout中具有ID的View创建了`final`字段。 例如，data-binding库为如下layout创建`TextView`类型的`firstName`和`lastName`字段：

```xml
<layout xmlns:android="http://schemas.android.com/apk/res/android">
   <data>
       <variable name="user" type="com.example.User"/>
   </data>
   <LinearLayout
       android:orientation="vertical"
       android:layout_width="match_parent"
       android:layout_height="match_parent">
       <TextView android:layout_width="wrap_content"
           android:layout_height="wrap_content"
           android:text="@{user.firstName}"
   android:id="@+id/firstName"/>
       <TextView android:layout_width="wrap_content"
           android:layout_height="wrap_content"
           android:text="@{user.lastName}"
  android:id="@+id/lastName"/>
   </LinearLayout>
</layout>
```

data-binding库在一次传递中从视图层次结构中提取所有的有ID视图。 这比为布局中的每个视图调用`findViewById()`方法更快。

虽然那些没有数据绑定视图的ID值不是必需的，但仍有一些情况需要从代码访问这些视图。

### 1.4.3、Variables

data-binding库为layout中声明的每个变量生成getter和setter方法。 例如，如下layout对应的binding类中将会生成`user`，`image`和`note`变量的setter和getter方法：

```xml
<data>
   <import type="android.graphics.drawable.Drawable"/>
   <variable name="user" type="com.example.User"/>
   <variable name="image" type="Drawable"/>
   <variable name="note" type="String"/>
</data>
```



### 1.4.4、ViewStubs

与普通视图不同，`ViewStub`对象开始时是一个不可见的视图。 当它们被显示或被明确告知需要inflate时，它们会通过inflate另一个布局来替换自己。

因为`ViewStub`最终将从视图层次结构中消失，所以binding类的实例中的视图也必须消失来完成内存gc。 因为binding类中的View是final的，所以[`ViewStubProxy`](https://developer.android.com/reference/androidx/databinding/ViewStubProxy.html)对象取代了生成的binding类中的`ViewStub`，可以访问`ViewStub`本身，并且当`ViewStub`被inflate后也可以访问inflate的视图层次结构。

在inflate另一个layout时，必须为新layout建立绑定。 因此，`ViewStubProxy`必须侦听`ViewStub``OnInflateListener`并在需要时建立绑定。 由于`ViewStub`只能设置一个侦听器，因此`ViewStubProxy`允许在建立绑定后设置一个`OnInflateListener`。

### 1.4.5、Immediate Binding

当变量或可观察对象发生更改时，绑定计划在下一帧之前更改。 但是，有时必须立即执行绑定。 要强制执行，请使用[`executePendingBindings()`](https://developer.android.com/reference/androidx/databinding/ViewDataBinding.html#executePendingBindings())方法。

### 1.4.6、Advanced Binding

#### Dynamic Variables

有时，特定的binding类是未知的。 例如，针对任意布局操作的`RecyclerView.Adapter`不知道特定的binding类。 它仍然必须在调用`onBindViewHolder()`方法时设置binding值。

在下面的示例中，`RecyclerView`绑定的所有layout都有一个`item`变量。 `BindingHolder`object有一个`getBinding()`方法返回[`ViewDataBinding`](https://developer.android.com/reference/androidx/databinding/ViewDataBinding.html)基类。

```java
public void onBindViewHolder(BindingHolder holder, int position) {
    final T item = items.get(position);
    holder.getBinding().setVariable(BR.item, item);
    holder.getBinding().executePendingBindings();
}
```

**Note:** data-binding库将生成一个名为`BR`的类，其中包含用于数据绑定的资源的ID。 在上面的示例中，库自动生成`BR.item`变量。

### 1.4.7、Background Thread

您可以在后台线程中更改数据模型，只要它不是集合。Data binding localizes each variable / field during evaluation to avoid any concurrency issues.

### 1.4.8、Custom binding class names

默认情况下，将根据layout文件的名称生成绑定类，以大写字母开头，删除下划线(_)，驼峰命名，并为单词**Binding**添加后缀。 该类放在包名下的`databinding`包中。 例如，布局文件`contact_item.xml`生成`ContactItemBinding`类。 如果包名是`com.example.my.app`，则绑定类放在`com.example.my.app.databinding`包中。

通过调整`data`元素的`class`属性，可以重命名binding类或将binding类放在不同的包中。 例如，以下layout在当前模块的`databinding`包中生成`ContactItem`binding类：

```xml
<data class="ContactItem">
    …
</data>
```

可以通过在类名前加一个句点来为不同的包生成binding类。 以下示例在包名包中生成binding类：

```xml
<data class=".ContactItem">
    …
</data>
```

还可以使用要在其中生成binding类的完整包名称。 以下示例在`com.example`包中创建`ContactItem`binding类：

```xml
<data class="com.example.ContactItem">    
    …
</data>
```



## 1.5、Binding adapters

Binding adapters负责对设置值进行适当的框架调用。 一个例子是设置一个属性值，如调用`setText()`方法。 另一个例子是设置一个事件监听器，比如调用`setOnClickListener()`方法。

data-binding库允许指定方法来设置值，提供自己的绑定逻辑，并使用adapter指定返回对象的类型。

### 1.5.1、Setting attribute values

每当绑定值发生更改时，生成的binding class必须在使用了绑定表达式的View上调用setter方法。 您可以让data-binding库自动确定方法，显式声明方法或者提供自定义逻辑来选择方法。

#### Automatic method selection

对于名为`example`的属性，库自动尝试查找接受兼容类型作为参数的方法`setExample(arg)`。不考虑属性的名称空间，搜索方法时仅使用属性名称和类型。

例如，`android:text="@{user.name}"`表达式，库查找`setText(arg)`方法，该方法接受`user.getName()`返回的类型。如果`user.getName()`的返回类型是`String`，那么库会查找接受`String`参数的`setText()`方法。 如果表达式返回一个`int`，那么库会搜索一个接受`int`参数的`setText()`方法。因此，表达式必须返回正确的类型，如有必要，可以转换返回值。

即使没有给定名称的属性，data binding仍然有效。并且，您可以使用data binding为任何setter创建属性。例如，support类`DrawerLayout`没有任何属性，但有很多setter方法。以下layout自动将使用`setScrimColor(int)`和`setDrawerListener(DrawerListener)`方法分别作为`app:scrimColor`和`app:drawerListener`属性的setter：

```xml
<android.support.v4.widget.DrawerLayout
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    app:scrimColor="@{@color/scrim}"
    app:drawerListener="@{fragment.drawerListener}">
```

#### Specify a custom method name

某些属性具有名称不匹配的setter。在这些情况下，可以使用[`BindingMethods`](https://developer.android.com/reference/androidx/databinding/BindingMethods.html)注解将属性与setter相关联。注解与类一起使用，可以包含多个[`BindingMethod`](https://developer.android.com/reference/androidx/databinding/BindingMethod.html)注解，每个重命名的方法一个注解。`BindingMethods`是可以添加到应用程序中任何类的注解。在下面的示例中，`android:tint`属性与`setImageTintList(ColorStateList)`方法相关联，而不是与`setTint()`方法相关联：

```java
@BindingMethods({
       @BindingMethod(type = "android.widget.ImageView",
                      attribute = "android:tint",
                      method = "setImageTintList"),
})
```

大多数情况下，您不需要在AndroidFramework类中重命名setter。已使用名称约定实现的属性可自动查找匹配方法。

#### Provide custom logic

某些属性需要自定义绑定逻辑。 例如，`android:paddingLeft`属性没有关联的setter。相反，提供了`setPadding(left, top, right, bottom)`方法。 使用 [`BindingAdapter`](https://developer.android.com/reference/androidx/databinding/BindingAdapter.html)注解的静态绑定适配器方法允许您自定义如何调用属性的setter。

AndroidFramework类的属性已经创建了“BindingAdapter”注释。 例如，以下示例显示了`paddingLeft`属性的binding adapter：

```java
@BindingAdapter("android:paddingLeft")
public static void setPaddingLeft(View view, int padding) {
  view.setPadding(padding,
                  view.getPaddingTop(),
                  view.getPaddingRight(),
                  view.getPaddingBottom());
}
```

参数类型很重要。第一个参数确定与属性关联的视图的类型。第二个参数确定给定属性的binding expression中接受的类型。

Binding adapter可用于其他作用的自定义。例如，可以从工作线程调用自定义加载程序来加载图像。

当发生冲突时，您定义的binding adapter将覆盖AndroidFramework提供的默认adapter。

您还可以使用接收多个属性的adapter，如下所示：

```java
@BindingAdapter({"imageUrl", "error"})
public static void loadImage(ImageView view, String url, Drawable error) {
  Picasso.get().load(url).error(error).into(view);
}
```

您可以在layout中使用adapter，如下所示。请注意，`@drawable/venueError`指的是您应用中的资源。使用`@ {}`围绕资源使其成为有效的binding expression。

```xml
<ImageView app:imageUrl="@{venue.imageUrl}" app:error="@{@drawable/venueError}" />
```

**Note:** data-binding库进行匹配时会忽略自定义命名空间。

如果`imageUrl`和`error`都用于`ImageView`对象并且`imageUrl`是一个字符串而``error`是`Drawable`，则调用适配器。如果你想在设置*any*属性时调用适配器，你可以设置可选的[`requireAll`](https://developer.android.com/reference/androidx/databinding/BindingAdapter.html#requireAll())为`false`，如下所示：

```java
@BindingAdapter(value={"imageUrl", "placeholder"}, requireAll=false)
public static void setImageUrl(ImageView imageView, String url, Drawable placeHolder) {
  if (url == null) {
    imageView.setImageDrawable(placeholder);
  } else {
    MyImageLoader.loadInto(imageView, url, placeholder);
  }
}
```

**Note:** 发生冲突时，你的binding adapter会覆盖默认binding adapter。

Binding adapter方法可以选择在其处理程序中处理old value。处理old value和new value的方法应首先声明属性的*all* old value，然后是new value，如下例所示：

```java
@BindingAdapter("android:paddingLeft")
public static void setPaddingLeft(View view, int oldPadding, int newPadding) {
  if (oldPadding != newPadding) {
      view.setPadding(newPadding,
                      view.getPaddingTop(),
                      view.getPaddingRight(),
                      view.getPaddingBottom());
   }
}
```

事件处理程序只能与带有一个抽象方法的接口或抽象类一起使用，如下所示：

```java
@BindingAdapter("android:onLayoutChange")
public static void setOnLayoutChangeListener(View view, View.OnLayoutChangeListener oldValue, View.OnLayoutChangeListener newValue) {
  if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
    if (oldValue != null) {
      view.removeOnLayoutChangeListener(oldValue);
    }
    if (newValue != null) {
      view.addOnLayoutChangeListener(newValue);
    }
  }
}
```

在layout中使用此事件处理程序，如下所示：

```xml
<View android:onLayoutChange="@{() -> handler.layoutChanged()}"/>
```

当侦听器具有多个方法时，必须将其拆分为多个侦听器。 例如，`View.OnAttachStateChangeListener`有两个方法：`onViewAttachedToWindow(View)`和`onViewDetachedFromWindow(View)`。该库提供了两个接口来区分它们的属性和处理程序：

```java
@TargetApi(VERSION_CODES.HONEYCOMB_MR1)
public interface OnViewDetachedFromWindow {
  void onViewDetachedFromWindow(View v);
}

@TargetApi(VERSION_CODES.HONEYCOMB_MR1)
public interface OnViewAttachedToWindow {
  void onViewAttachedToWindow(View v);
}
```

因为更改一个listener也会影响另一个listener，所以需要一个适用于任一属性或适用于两者的adapter。您可以在注解中将[`requireAll`](https://developer.android.com/reference/androidx/databinding/BindingAdapter.html#requireAll())设置为“false”，以指定不是每个属性都必须分配一个binding expression，如下所示：

```java
@BindingAdapter({"android:onViewDetachedFromWindow", "android:onViewAttachedToWindow"}, requireAll=false)
public static void setListener(View view, OnViewDetachedFromWindow detach, OnViewAttachedToWindow attach) {
    if (VERSION.SDK_INT >= VERSION_CODES.HONEYCOMB_MR1) {
        OnAttachStateChangeListener newListener;
        if (detach == null && attach == null) {
            newListener = null;
        } else {
            newListener = new OnAttachStateChangeListener() {
                @Override
                public void onViewAttachedToWindow(View v) {
                    if (attach != null) {
                        attach.onViewAttachedToWindow(v);
                    }
                }
                @Override
                public void onViewDetachedFromWindow(View v) {
                    if (detach != null) {
                        detach.onViewDetachedFromWindow(v);
                    }
                }
            };
        }

        OnAttachStateChangeListener oldListener = ListenerUtil.trackListener(view, newListener, R.id.onAttachStateChangeListener);
        if (oldListener != null) {
            view.removeOnAttachStateChangeListener(oldListener);
        }
        if (newListener != null) {
            view.addOnAttachStateChangeListener(newListener);
        }
    }
}
```

上面的例子比正常情况稍微复杂一些，因为`View`类使用`addOnAttachStateChangeListener()`和`removeOnAttachStateChangeListener()`方法代替`OnAttachStateChangeListener`的setter方法。 `android.databinding.adapters.ListenerUtil`类有助于跟踪以前的listener，以便可以在binding adapter中删除它们。

通过使用`@TargetApi(VERSION_CODES.HONEYCOMB_MR1)`注解接口`OnViewDetachedFromWindow`和`OnViewAttachedToWindow`，data-binding代码生成器知道只应在Android 3.1(API级别12)及更高版本上运行时生成侦听器，等同于`addOnAttachStateChangeListener()`方法支持的版本。

### 1.5.2、Object conversions

#### Automatic object conversion

当从binding expression返回`Object`时，库会选择用于设置属性值的方法。`Object`被强制转换为所选方法的参数类型。在使用[`ObservableMap`](https://developer.android.com/reference/androidx/databinding/ObservableMap.html)类存储数据的应用程序中，此行为很方便，如下所示：

```xml
<TextView
   android:text='@{userMap["lastName"]}'
   android:layout_width="wrap_content"
   android:layout_height="wrap_content" />
```

**Note:** 您还可以使用`object.key`表示法引用map中的值。例如，上面示例中的`@{userMap["lastName"]}`可以替换为`@{userMap.lastName}`。

expression中的`userMap`对象返回一个值，该值自动转换为用于设置`android:text`属性值的`setText(CharSequence)`方法中的参数类型。如果参数类型有歧义，则必须在expression中强制转换返回类型。

#### Custom conversions

在某些情况下，特定类型之间需要自定义转换。 例如，View的`android:background`属性需要`Drawable`，但指定的`color`值是一个整数。以下示例显示了一个期望`Drawable`的属性，但是提供了一个整数的处理办法：

```xml
<View
   android:background="@{isError ? @color/red : @color/white}"
   android:layout_width="wrap_content"
   android:layout_height="wrap_content"/>
```

每当需要`Drawable`并返回一个整数时，`int`应转换为`ColorDrawable`。可以使用带有 [`BindingConversion`](https://developer.android.com/reference/androidx/databinding/BindingConversion.html)注解的静态方法完成转换，如下所示：

```java
@BindingConversion
public static ColorDrawable convertColorToDrawable(int color) {
    return new ColorDrawable(color);
}
```

但是，binding expression中提供的值类型必须一致。 您不能在同一表达式中使用不同的类型，如下所示：

```xml
<View
   android:background="@{isError ? @drawable/error : @color/white}"
   android:layout_width="wrap_content"
   android:layout_height="wrap_content"/>
```



## 1.6、Bind layout views to Architecture Components

AndroidX库包含[Architecture Components](https://developer.android.com/topic/libraries/architecture/index.html)，您可以使用它来设计健壮、可测试和可维护的应用程序。data-binding库可与架构组件无缝协作，进一步简化UI的开发。应用程序中的layout可以绑定到体系结构组件中的数据，这些数据已经帮助您管理UI控制器生命周期并通知数据中的更改。

本章节介绍如何将架构组件合并到您的应用程序，以进一步增强使用data-binding库的好处。

### 1.6.1、Use LiveData to notify the UI about data changes

您可以使用[`LiveData`](https://developer.android.com/reference/androidx/lifecycle/LiveData)对象作为数据绑定源，自动通知UI有关数据更改的信息。 有关此体系结构组件的更多信息，请参阅[LiveData概述](https://developer.android.com/topic/libraries/architecture/livedata)。

与实现[`Observable`](https://developer.android.com/reference/androidx/databinding/Observable.html)的对象不同 - 例如[observable fields](https://developer.android.com/topic/libraries/data-binding/observability.html#observable_fields) -`LiveData`对象知道订阅数据更改的观察者的生命周期。 这些知识带来了许多好处，[使用LiveData的优点](https://developer.android.com/topic/libraries/architecture/livedata.html#the_advantages_of_using_livedata)中对此进行了解释。在Android Studio 3.1及更高版本中，您可以使用数据绑定代码中的`LiveData`对象替换[observable fields](https://developer.android.com/topic/libraries/data-binding/observability.html#observable_fields)。

要在binding class中使用`LiveData`对象，需要指定生命周期所有者来定义`LiveData`对象的范围。 以下示例在实例化绑定类之后将活动指定为生命周期所有者：

```java
class ViewModelActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // Inflate view and obtain an instance of the binding class.
        UserBinding binding = DataBindingUtil.setContentView(this, R.layout.user);

        // Specify the current activity as the lifecycle owner.
        binding.setLifecycleOwner(this);
    }
}
```

您可以使用[`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel) 组件，如[使用ViewModel管理UI相关数据](https://developer.android.com/topic/libraries/data-binding/architecture#viewmodel)，将数据绑定到布局。 在`ViewModel`组件中，您可以使用`LiveData`对象来转换数据或合并多个数据源。 以下示例显示如何转换`ViewModel`中的数据：

```java
class ScheduleViewModel extends ViewModel {
    LiveData username;

    public ScheduleViewModel() {
        String result = Repository.userName;
        userName = Transformations.map(result, result -> result.value);
    }
}
```

### 1.6.2、Use ViewModel to manage UI-related data

data-binding库与[`ViewModel`](https://developer.android.com/reference/androidx/lifecycle/ViewModel)组件无缝协作，这些组件暴露布局观察到的数据并对其更改作出反应。 使用带有data-binding库的`ViewModel`组件，您可以将UI逻辑从布局移动到组件中，这些组件更易于测试。data-binding库可确保在需要时绑定和取消绑定数据源。剩下的大部分工作都在于确保您暴露了正确的数据。有关此体系结构组件的更多信息，请参阅[ViewModel概述](https://developer.android.com/topic/libraries/architecture/viewmodel.html)。

要将`ViewModel`组件与data-binding库一起使用，必须实例化继承自`ViewModel`类的组件，获取binding class的实例，并将`ViewModel`组件分配给binding class中的属性。 以下示例显示如何将该组件与库一起使用：

```java
class ViewModelActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // Obtain the ViewModel component.
        UserModel userModel = ViewModelProviders.of(getActivity())
                                                  .get(UserModel.class);

        // Inflate view and obtain an instance of the binding class.
        UserBinding binding = DataBindingUtil.setContentView(this, R.layout.user);

        // Assign the component to a property in the binding class.
        binding.viewmodel = userModel;
    }
}
```

在layout中，使用binding expression将`ViewModel`组件的属性和方法分配给相应的View，如下所示：

```xml
<CheckBox
    android:id="@+id/rememberMeCheckBox"
    android:checked="@{viewmodel.rememberMe}"
    android:onCheckedChanged="@{() -> viewmodel.rememberMeChanged()}" />
```

### 1.6.3、Use an Observable ViewModel for more control over binding adapters

您可以使用实现`Observable`的`ViewModel`组件通知其他应用程序组件有关数据的更改，类似于使用[`LiveData`]的对象。

在某些情况下，您可能更喜欢使用实现`Observable`接口的`ViewModel`组件而不是使用`LiveData`对象，即使你失去了`LiveData`的生命周期管理功能。使用实现`Observable`的`ViewModel`组件可以更好地控制应用中的binding adapter。 例如，此模式使您可以在数据更改时更好地控制通知，还允许您指定自定义方法以在双向数据绑定中设置属性的值。

要实现一个可观察的`ViewModel`组件，您必须创建一个继承自`ViewModel`类的类并实现`Observable`接口。当观察者使用[`addOnPropertyChangedCallback()`](https://developer.android.com/reference/androidx/databinding/Observable.html#addOnPropertyChangedCallback(android.databinding.Observable.OnPropertyChangedCallback))和[`removeOnPropertyChangedCallback()`](https://developer.android.com/reference/androidx/databinding/Observable.html#removeOnPropertyChangedCallback(android.databinding.Observable.OnPropertyChangedCallback))订阅或取消订阅通知时，您可以提供自定义逻辑。您还可以提供在[`notifyPropertyChanged()`](https://developer.android.com/reference/androidx/databinding/BaseObservable.html#notifyPropertyChanged(int))方法中属性更改时运行的自定义逻辑。以下代码示例演示如何实现可观察的`ViewModel`：

```java
/**
 * A ViewModel that is also an Observable,
 * to be used with the Data Binding Library.
 */
class ObservableViewModel extends ViewModel implements Observable {
    private PropertyChangeRegistry callbacks = new PropertyChangeRegistry();

    @Override
    protected void addOnPropertyChangedCallback(
            Observable.OnPropertyChangedCallback callback) {
        callbacks.add(callback);
    }

    @Override
    protected void removeOnPropertyChangedCallback(
            Observable.OnPropertyChangedCallback callback) {
        callbacks.remove(callback);
    }

    /**
     * Notifies observers that all properties of this instance have changed.
     */
    void notifyChange() {
        callbacks.notifyCallbacks(this, 0, null);
    }

    /**
     * Notifies observers that a specific property has changed. The getter for the
     * property that changes should be marked with the @Bindable annotation to
     * generate a field in the BR class to be used as the fieldId parameter.
     *
     * @param fieldId The generated BR id for the Bindable field.
     */
    void notifyPropertyChanged(int fieldId) {
        callbacks.notifyCallbacks(this, fieldId, null);
    }
}
```



## 1.7、Two-way data binding

使用单向数据绑定，您可以在属性上设置值，并设置对该属性中的更改作出反应的listener：

```xml
<CheckBox
    android:id="@+id/rememberMeCheckBox"
    android:checked="@{viewmodel.rememberMe}"
    android:onCheckedChanged="@{viewmodel.rememberMeChanged}"
/>
```

双向数据绑定提供了此过程的快捷方式：

```xml
<CheckBox
    android:id="@+id/rememberMeCheckBox"
    android:checked="@={viewmodel.rememberMe}"
/>
```

`@={}`表示法，其中重要的是包含“=”符号，它接收属性的数据更改并同时监听用户更新。

为了对backing数据的变化做出反应，你可以使你的layout中的变量成为`Observable`的实现，通常是[`BaseObservable`](https://developer.android.com/reference/androidx/databinding/BaseObservable)， 并使用[`@Bindable`](https://developer.android.com/reference/androidx/databinding/Bindable)注解，如下所示：

```java
public class LoginViewModel extends BaseObservable {
    // private Model data = ...

    @Bindable
    public Boolean getRememberMe() {
        return data.rememberMe;
    }

    public void setRememberMe(Boolean value) {
        // Avoids infinite loops.
        if (data.rememberMe != value) {
            data.rememberMe = value;

            // React to the change.
            saveData();

            // Notify observers of a new value.
            notifyPropertyChanged(BR.remember_me);
        }
    }
}
```

因为bindable属性的getter方法叫做`getRememberMe()`，所以属性的相应setter方法自动使用名称`setRememberMe()`。

有关使用`BaseObservable`和`@Bindable`的更多信息，请参阅[使用可观察数据对象](#1.3、Work with observable data objects)。

### 1.7.1、Two-way data binding using custom attributes

该平台为[最常见的双向属性](#1.7.4、Two-way attributes)提供双向数据绑定实现并更改listener，您可以将其用作应用程序的一部分。如果你想使用自定义属性的双向数据绑定，你需要使用[`@InverseBindingAdapter`](https://developer.android.com/reference/androidx/databinding/InverseBindingAdapter)和[`@InverseBindingMethod `](https://developer.android.com/reference/androidx/databinding/InverseBindingMethod)注解。

例如，如果要在名为“MyView”的自定义View中的“time”属性上启用双向数据绑定，请完成以下步骤：

1. 注解设置初始值的方法，并使用`@BindingAdapter`在值更改时更新：

   ```java
   @BindingAdapter("time")
   public static void setTime(MyView view, Time newValue) {
       // Important to break potential infinite loops.
       if (view.time != newValue) {
           view.time = newValue;
       }
   }
   ```

2. 使用`@InverseBindingAdapter`注解从View中读取值的方法：

   ```java
   @InverseBindingAdapter("time")
   public static Time getTime(MyView view) {
       return view.getTime();
   }
   ```

此时，data-binding知道数据更改时要做什么（它调用`@BindingAdapter`注解的方法）和View属性更改时要做什么（它调用`@InverseBindingListener`注解的方法）。但是，它不知道属性何时或如何更改。

为此，您需要在View上设置一个listener。它可以是与自定义View关联的自定义listener，也可以是通用事件，例如失去焦点或文本更改。将`@BindingAdapter`注解添加到为listener设置属性更改的方法中：

```java
@BindingAdapter("app:timeAttrChanged")
public static void setListeners(
        MyView view, final InverseBindingListener attrChange) {
    // Set a listener for click, focus, touch, etc.
}
```

listener包含一个`InverseBindingListener`作为参数。使用`InverseBindingListener`告诉data-binding系统该属性已更改。然后系统可以使用`@InverseBindingAdapter`开始调用注解方法，依此类推。

**Note:** 每个双向绑定都会生成*合成事件属性*。此属性与基本属性具有相同的名称，但它包含后缀`"AttrChanged"`。合成事件属性允许库创建一个使用`@BindingAdapter`注解的方法，并将事件listener关联到`View`的相应实例。

实际上，该listener包括一些非平凡的逻辑，包括用于单向数据绑定的listener。有关示例，请参阅适配器以获取文本属性更改，[`TextViewBindingAdapter`](https://android.googlesource.com/platform/frameworks/data-binding/+/3b920788e90bb0abe615a5d5c899915f0014444b/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/TextViewBindingAdapter.java#344)。

### 1.7.2、Converters

如果绑定到`View`对象的变量需要在显示之前以某种方式进行format、translate或change，则可以使用一个`Converter`对象。

例如，使用显示日期的`EditText`对象：

```xml
<EditText
    android:id="@+id/birth_date"
    android:text="@={Converter.dateToString(viewmodel.birthDate)}"
/>
```

`viewmodel.birthDate`属性包含类型为`Long`的值，因此需要使用converter对其进行format。

因为正在使用双向表达式，所以还需要一个*inverse converter*让库知道如何将用户提供的字符串转换回backing数据类型，在本例中为`Long`。通过将[`@InverseMethod`](https://developer.android.com/reference/androidx/databinding/InverseMethod)注解添加到其中一个converter并将此注解引用到inverse converter来完成此过程。 以下代码段中显示了此配置的示例：

```java
public class Converter {
    @InverseMethod("stringToDate")
    public static String dateToString(EditText view, long oldValue,
            long value) {
        // Converts long to String.
    }

    public static long stringToDate(EditText view, String oldValue,
            String value) {
        // Converts String to long.
    }
}
```

### 1.7.3、Infinite loops using two-way data binding

使用双向数据绑定时，请注意不要引入无限循环。当用户更改属性时，将调用使用`@InverseBindingAdapter`注释的方法，并将值分配给backing属性。反过来，这将调用使用`@BindingAdapter`注释的方法，这将触发对使用`@InverseBindingAdapter`注释的方法的又一次调用，依此类推。

因此，通过比较使用`@BindingAdapter`注释的方法中的新旧值来打破可能的无限循环非常重要。

### 1.7.4、Two-way attributes

当您使用下表中的属性时，该平台为双向数据绑定提供内置支持。 有关平台如何提供此支持的详细信息，请参阅相应binding adapter的实现：

| Class                                                        | Attribute(s)                                                 | Binding adapter                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| [`AdapterView`](https://developer.android.com/reference/android/widget/AdapterView) | `android:selectedItemPosition` `android:selection`           | [`AdapterViewBindingAdapter`](https://android.googlesource.com/platform/frameworks/data-binding/+/3b920788e90bb0abe615a5d5c899915f0014444b/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/AdapterViewBindingAdapter.java) |
| [`CalendarView`](https://developer.android.com/reference/android/widget/CalendarView) | `android:date`                                               | [`CalendarViewBindingAdapter`](https://android.googlesource.com/platform/frameworks/data-binding/+/3b920788e90bb0abe615a5d5c899915f0014444b/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/CalendarViewBindingAdapter.java) |
| [`CompoundButton`](https://developer.android.com/reference/android/widget/CompoundButton) | [`android:checked`](https://developer.android.com/reference/android/R.attr#checked) | [`CompoundButtonBindingAdapter`](https://android.googlesource.com/platform/frameworks/data-binding/+/3b920788e90bb0abe615a5d5c899915f0014444b/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/CompoundButtonBindingAdapter.java) |
| [`DatePicker`](https://developer.android.com/reference/android/widget/DatePicker) | `android:year` `android:month` `android:day`                 | [`DatePickerBindingAdapter`](https://android.googlesource.com/platform/frameworks/data-binding/+/3b920788e90bb0abe615a5d5c899915f0014444b/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/DatePickerBindingAdapter.java) |
| [`NumberPicker`](https://developer.android.com/reference/android/widget/NumberPicker) | [`android:value`](https://developer.android.com/reference/android/R.attr#value) | [`NumberPickerBindingAdapter`](https://android.googlesource.com/platform/frameworks/data-binding/+/3b920788e90bb0abe615a5d5c899915f0014444b/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/NumberPickerBindingAdapter.java) |
| [`RadioButton`](https://developer.android.com/reference/android/widget/RadioButton) | [`android:checkedButton`](https://developer.android.com/reference/android/R.attr#checkedButton) | [`RadioGroupBindingAdapter`](https://android.googlesource.com/platform/frameworks/data-binding/+/3b920788e90bb0abe615a5d5c899915f0014444b/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/RadioGroupBindingAdapter.java) |
| [`RatingBar`](https://developer.android.com/reference/android/widget/RatingBar) | [`android:rating`](https://developer.android.com/reference/android/R.attr#rating) | [`RatingBarBindingAdapter`](https://android.googlesource.com/platform/frameworks/data-binding/+/3b920788e90bb0abe615a5d5c899915f0014444b/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/RatingBarBindingAdapter.java) |
| [`SeekBar`](https://developer.android.com/reference/android/widget/SeekBar) | [`android:progress`](https://developer.android.com/reference/android/R.attr#progress) | [`SeekBarBindingAdapter`](https://android.googlesource.com/platform/frameworks/data-binding/+/3b920788e90bb0abe615a5d5c899915f0014444b/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/SeekBarBindingAdapter.java) |
| [`TabHost`](https://developer.android.com/reference/android/widget/TabHost) | `android:currentTab`                                         | [`TabHostBindingAdapter`](https://android.googlesource.com/platform/frameworks/data-binding/+/3b920788e90bb0abe615a5d5c899915f0014444b/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/TabHostBindingAdapter.java) |
| [`TextView`](https://developer.android.com/reference/android/widget/TextView) | [`android:text`](https://developer.android.com/reference/android/R.attr#text) | [`TextViewBindingAdapter`](https://android.googlesource.com/platform/frameworks/data-binding/+/3b920788e90bb0abe615a5d5c899915f0014444b/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/TextViewBindingAdapter.java) |
| [`TimePicker`](https://developer.android.com/reference/android/widget/TimePicker) | `android:hour` `android:minute`                              | [`TimePickerBindingAdapter`](https://android.googlesource.com/platform/frameworks/data-binding/+/3b920788e90bb0abe615a5d5c899915f0014444b/extensions/baseAdapters/src/main/java/androidx/databinding/adapters/TimePickerBindingAdapter.java) |
























# Memo备忘









# References

- [官方文档](<https://developer.android.com/topic/libraries/data-binding>)
- [googleSample: data-bindings](<https://github.com/googlesamples/android-databinding>)
- [googleSample: MVVM data-bindings](<https://github.com/googlesamples/android-architecture/tree/todo-mvvm-databinding>)
```

```