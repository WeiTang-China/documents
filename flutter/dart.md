# 官网资源

## [A tour of the Dart language](https://dart.dev/guides/language/language-tour)

### A basic Dart program

```dart
// Define a function.
printInteger(int aNumber) {
  print('The number is $aNumber.'); // Print to console.
}

// This is where the app starts executing.
main() {
  var number = 42; // Declare and initialize a variable.
  printInteger(number); // Call a function.
}
```

`// This is a comment.`

A single-line comment. Dart also supports multi-line and document comments. For details, see [Comments](https://dart.dev/guides/language/language-tour#comments).

`int`

A type. Some of the other [built-in types](https://dart.dev/guides/language/language-tour#built-in-types) are `String`, `List`, and `bool`.

`42`

A number literal. Number literals are a kind of compile-time constant.

`print()`

A handy way to display output.

`'...'` (or `"..."`)

A string literal.

`$*variableName*` (or `${*expression*}`)

String interpolation: including a variable or expression’s string equivalent inside of a string literal. For more information, see [Strings](https://dart.dev/guides/language/language-tour#strings).

`main()`

The special, *required*, top-level function where app execution starts. For more information, see [The main() function](https://dart.dev/guides/language/language-tour#the-main-function).

`var`

A way to declare a variable without specifying its type.



### Important concepts

As you learn about the Dart language, keep these facts and concepts in mind:

- Everything you can place in a variable is an *object*, and every object is an instance of a *class*. Even numbers, functions, and `null` are objects. All objects inherit from the [Object](https://api.dart.dev/stable/dart-core/Object-class.html) class.
- Although Dart is strongly typed, type annotations are optional because Dart can infer types. In the code above, `number` is inferred to be of type `int`. When you want to explicitly say that no type is expected, [use the special type `dynamic`](https://dart.dev/guides/language/effective-dart/design#do-annotate-with-object-instead-of-dynamic-to-indicate-any-object-is-allowed).
- Dart supports generic types, like `List` (a list of integers) or `List` (a list of objects of any type).
- Dart supports top-level functions (such as `main()`), as well as functions tied to a class or object (*static* and *instance methods*, respectively). You can also create functions within functions (*nested* or *local functions*).
- Similarly, Dart supports top-level *variables*, as well as variables tied to a class or object (static and instance variables). Instance variables are sometimes known as fields or properties.
- Unlike Java, Dart doesn’t have the keywords `public`, `protected`, and `private`. If an identifier starts with an underscore (_), it’s private to its library. For details, see [Libraries and visibility](https://dart.dev/guides/language/language-tour#libraries-and-visibility).
- *Identifiers* can start with a letter or underscore (_), followed by any combination of those characters plus digits.
- Dart has both *expressions* (which have runtime values) and *statements* (which don’t). For example, the [conditional expression](https://dart.dev/guides/language/language-tour#conditional-expressions) `condition ? expr1 : expr2` has a value of `expr1` or `expr2`. Compare that to an [if-else statement](https://dart.dev/guides/language/language-tour#if-and-else), which has no value. A statement often contains one or more expressions, but an expression can’t directly contain a statement.
- Dart tools can report two kinds of problems: *warnings* and *errors*. Warnings are just indications that your code might not work, but they don’t prevent your program from executing. Errors can be either compile-time or run-time. A compile-time error prevents the code from executing at all; a run-time error results in an [exception](https://dart.dev/guides/language/language-tour#exceptions) being raised while the code executes.



## Keywords

The following table lists the words that the Dart language treats specially.

| [abstract](https://dart.dev/guides/language/language-tour#abstract-classes) 2 | [dynamic](https://dart.dev/guides/language/language-tour#important-concepts) 2 | [implements](https://dart.dev/guides/language/language-tour#implicit-interfaces) 2 | [show](https://dart.dev/guides/language/language-tour#importing-only-part-of-a-library) 1 |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| [as](https://dart.dev/guides/language/language-tour#type-test-operators) 2 | [else](https://dart.dev/guides/language/language-tour#if-and-else) | [import](https://dart.dev/guides/language/language-tour#using-libraries) 2 | [static](https://dart.dev/guides/language/language-tour#class-variables-and-methods) 2 |
| [assert](https://dart.dev/guides/language/language-tour#assert) | [enum](https://dart.dev/guides/language/language-tour#enumerated-types) | [in](https://dart.dev/guides/language/language-tour#for-loops) | [super](https://dart.dev/guides/language/language-tour#extending-a-class) |
| [async](https://dart.dev/guides/language/language-tour#asynchrony-support) 1 | [export](https://dart.dev/guides/libraries/create-library-packages) 2 | [interface](https://stackoverflow.com/questions/28595501/was-the-interface-keyword-removed-from-dart) 2 | [switch](https://dart.dev/guides/language/language-tour#switch-and-case) |
| [await](https://dart.dev/guides/language/language-tour#asynchrony-support) 3 | [extends](https://dart.dev/guides/language/language-tour#extending-a-class) | [is](https://dart.dev/guides/language/language-tour#type-test-operators) | [sync](https://dart.dev/guides/language/language-tour#generators) 1 |
| [break](https://dart.dev/guides/language/language-tour#break-and-continue) | [external](https://stackoverflow.com/questions/24929659/what-does-external-mean-in-dart) 2 | [library](https://dart.dev/guides/language/language-tour#libraries-and-visibility) 2 | [this](https://dart.dev/guides/language/language-tour#constructors) |
| [case](https://dart.dev/guides/language/language-tour#switch-and-case) | [factory](https://dart.dev/guides/language/language-tour#factory-constructors) 2 | [mixin](https://dart.dev/guides/language/language-tour#adding-features-to-a-class-mixins) 2 | [throw](https://dart.dev/guides/language/language-tour#throw) |
| [catch](https://dart.dev/guides/language/language-tour#catch) | [false](https://dart.dev/guides/language/language-tour#booleans) | [new](https://dart.dev/guides/language/language-tour#using-constructors) | [true](https://dart.dev/guides/language/language-tour#booleans) |
| [class](https://dart.dev/guides/language/language-tour#instance-variables) | [final](https://dart.dev/guides/language/language-tour#final-and-const) | [null](https://dart.dev/guides/language/language-tour#default-value) | [try](https://dart.dev/guides/language/language-tour#catch)  |
| [const](https://dart.dev/guides/language/language-tour#final-and-const) | [finally](https://dart.dev/guides/language/language-tour#finally) | [on](https://dart.dev/guides/language/language-tour#catch) 1 | [typedef](https://dart.dev/guides/language/language-tour#typedefs) 2 |
| [continue](https://dart.dev/guides/language/language-tour#break-and-continue) | [for](https://dart.dev/guides/language/language-tour#for-loops) | [operator](https://dart.dev/guides/language/language-tour#overridable-operators) 2 | [var](https://dart.dev/guides/language/language-tour#variables) |
| [covariant](https://dart.dev/guides/language/sound-problems#the-covariant-keyword) 2 | [Function](https://dart.dev/guides/language/language-tour#functions) 2 | [part](https://dart.dev/guides/libraries/create-library-packages#organizing-a-library-package) 2 | [void](https://medium.com/dartlang/dart-2-legacy-of-the-void-e7afb5f44df0) |
| [default](https://dart.dev/guides/language/language-tour#switch-and-case) | [get](https://dart.dev/guides/language/language-tour#getters-and-setters) 2 | [rethrow](https://dart.dev/guides/language/language-tour#catch) | [while](https://dart.dev/guides/language/language-tour#while-and-do-while) |
| [deferred](https://dart.dev/guides/language/language-tour#lazily-loading-a-library) 2 | [hide](https://dart.dev/guides/language/language-tour#importing-only-part-of-a-library) 1 | [return](https://dart.dev/guides/language/language-tour#functions) | [with](https://dart.dev/guides/language/language-tour#adding-features-to-a-class-mixins) |
| [do](https://dart.dev/guides/language/language-tour#while-and-do-while) | [if](https://dart.dev/guides/language/language-tour#if-and-else) | [set](https://dart.dev/guides/language/language-tour#getters-and-setters) 2 | [yield](https://dart.dev/guides/language/language-tour#generators) 3 |

Avoid using these words as identifiers. However, if necessary, the keywords marked with superscripts can be identifiers:

- Words with the superscript **1** are **contextual keywords**, which have meaning only in specific places. They’re valid identifiers everywhere.
- Words with the superscript **2** are **built-in identifiers**. To simplify the task of porting JavaScript code to Dart, these keywords are valid identifiers in most places, but they can’t be used as class or type names, or as import prefixes.
- Words with the superscript **3** are newer, limited reserved words related to the [asynchrony support](https://dart.dev/guides/language/language-tour#asynchrony-support) that was added after Dart’s 1.0 release. You can’t use `await` or `yield` as an identifier in any function body marked with `async`, `async*`, or `sync*`.

All other words in the table are **reserved words**, which can’t be identifiers.



## built-in types

Dart支持如下类型：

- numbers
- strings
- booleans
- lists (also known as *arrays*)
- sets
- maps
- runes (for expressing Unicode characters in a string)
- symbols

### numbers

Dart有两种数字：

- int

  int不能超过64位，具体取决于不同的平台。

  在Dart VM上，取值范围是(-2<<63) 到 (2<<63 - 1)。

  编译为Javascript时，使用JavaScript numbers，其范围是(-2<<53) to (2<<53 - 1)。

- double

  64-bit 浮点数，遵循IEEE 754标准。

Both `int` and `double` are subtypes of [`num`.](https://api.dart.dev/stable/dart-core/num-class.html) The num type includes basic operators such as +, -, /, and *, and is also where you’ll find `abs()`,` ceil()`, and `floor()`, among other methods. (Bitwise operators, such as >>, are defined in the `int` class.) If num and its subtypes don’t have what you’re looking for, the [dart:math](https://api.dart.dev/stable/dart-math) library might.

### strings

Dart string是使用UTF-16字符组成的一个串。

你可以使用单引号 ' 或者双引号 " 来创建string：

```dart
var s1 = 'Single quotes work well for string literals.';
var s2 = "Double quotes work just as well.";
var s3 = 'It\'s easy to escape the string delimiter.';
var s4 = "It's even easier to use the other delimiter.";
```

You can put the value of an expression inside a string by using `${`*`expression`*`}`. If the expression is an identifier, you can skip the {}. To get the string corresponding to an object, Dart calls the object’s `toString()` method.

```dart
var s = 'string interpolation';

assert('Dart has $s, which is very handy.' ==
    'Dart has string interpolation, ' +
        'which is very handy.');
assert('That deserves all caps. ' +
        '${s.toUpperCase()} is very handy!' ==
    'That deserves all caps. ' +
        'STRING INTERPOLATION is very handy!');
```

 **Note:** The `==` operator tests whether two objects are equivalent. Two strings are equivalent if they contain the same sequence of code units.

Another way to create a multi-line string: use a triple quote with either single or double quotation marks:

```dart
var s1 = '''
You can create
multi-line strings like this one.
''';

var s2 = """This is also a
multi-line string.""";
```

You can create a “raw” string by prefixing it with `r`:

```dart
var s = r'In a raw string, not even \n gets special treatment.';
```

See [Runes and grapheme clusters](https://dart.dev/guides/language/language-tour#characters) for details on how to express Unicode characters in a string.

Literal strings are compile-time constants, as long as any interpolated expression is a compile-time constant that evaluates to null or a numeric, string, or boolean value.

> const的字符串拼接只能传入const变量，在编译时拼接完成，否则会报编译错误。

```dart
// These work in a const string.
const aConstNum = 0;
const aConstBool = true;
const aConstString = 'a constant string';

// These do NOT work in a const string.
var aNum = 0;
var aBool = true;
var aString = 'a string';
const aConstList = [1, 2, 3];

const validConstString = '$aConstNum $aConstBool $aConstString';
// const invalidConstString = '$aNum $aBool $aString $aConstList';
```

For more information on using strings, see [Strings and regular expressions](https://dart.dev/guides/libraries/library-tour#strings-and-regular-expressions).

### booleans

To represent boolean values, Dart has a type named `bool`. Only two objects have type bool: the boolean literals `true` and `false`, which are both compile-time constants.

Dart’s type safety means that you can’t use code like `if (*nonbooleanValue*)` or `assert (*nonbooleanValue*)`. Instead, explicitly check for values, like this:

```dart
// Check for an empty string.
var fullName = '';
assert(fullName.isEmpty);

// Check for zero.
var hitPoints = 0;
assert(hitPoints <= 0);

// Check for null.
var unicorn;
assert(unicorn == null);

// Check for NaN.
var iMeantToDoThis = 0 / 0;
assert(iMeantToDoThis.isNaN);
```

### lists

Perhaps the most common collection in nearly every programming language is the *array*, or ordered group of objects. In Dart, arrays are [List](https://api.dart.dev/stable/dart-core/List-class.html) objects, so most people just call them *lists*.

Dart list literals look like JavaScript array literals. Here’s a simple Dart list:

```dart
var list = [1, 2, 3];
```

 **Note:** Dart infers that `list` has type `List`. If you try to add non-integer objects to this list, the analyzer or runtime raises an error. For more information, read about [type inference.](https://dart.dev/guides/language/sound-dart#type-inference)

Lists use zero-based indexing, where 0 is the index of the first element and `list.length - 1` is the index of the last element. You can get a list’s length and refer to list elements just as you would in JavaScript:

```dart
var list = [1, 2, 3];
assert(list.length == 3);
assert(list[1] == 2);

list[1] = 1;
assert(list[1] == 1);
```

To create a list that’s a compile-time constant, add `const` before the list literal:

```dart
var constantList = const [1, 2, 3];
// constantList[1] = 1; // Uncommenting this causes an error.
```

> list就像array一样操作。
>
> const修饰在值上，意味着list中的成员都不能修改。

Dart 2.3 introduced the **spread operator** (`...`) and the **null-aware spread operator** (`...?`), which provide a concise way to insert multiple elements into a collection.

For example, you can use the spread operator (`...`) to insert all the elements of a list into another list:

```dart
var list = [1, 2, 3];
var list2 = [0, ...list];
assert(list2.length == 4);
```

If the expression to the right of the spread operator might be null, you can avoid exceptions by using a null-aware spread operator (`...?`):

```dart
var list;
var list2 = [0, ...?list];
assert(list2.length == 1);
```

For more details and examples of using the spread operator, see the [spread operator proposal](https://github.com/dart-lang/language/blob/master/accepted/2.3/spread-collections/feature-specification.md).

> ...表示强制扩展，即使为null
>
> ...?表示非null时才扩展
>
> 疑问：如果...null，是否会报错呢？

Dart 2.3 also introduced **collection if** and **collection for**, which you can use to build collections using conditionals (`if`) and repetition (`for`).

Here’s an example of using **collection if** to create a list with three or four items in it:

```dart
var nav = [
  'Home',
  'Furniture',
  'Plants',
  if (promoActive) 'Outlet'
];
```

Here’s an example of using **collection for** to manipulate the items of a list before adding them to another list:

```dart
var listOfInts = [1, 2, 3];
var listOfStrings = [
  '#0',
  for (var i in listOfInts) '#$i'
];
assert(listOfStrings[1] == '#1');
```

For more details and examples of using collection if and for, see the [control flow collections proposal.](https://github.com/dart-lang/language/blob/master/accepted/2.3/control-flow-collections/feature-specification.md)

> list的初始化过程支持if和for，带来了灵活性

The List type has many handy methods for manipulating lists. For more information about lists, see [Generics](https://dart.dev/guides/language/language-tour#generics) and [Collections](https://dart.dev/guides/libraries/library-tour#collections).

### sets

A set in Dart is an unordered collection of unique items. 

> set是元素唯一的集合

Dart support for sets is provided by set literals and the [Set](https://api.dart.dev/stable/dart-core/Set-class.html) type.

 **Version note:** Although the Set *type* has always been a core part of Dart, set *literals* were introduced in Dart 2.2.

Here is a simple Dart set, created using a set literal:

```dart
var halogens = {'fluorine', 'chlorine', 'bromine', 'iodine', 'astatine'};
```

 **Note:** Dart infers that `halogens` has the type `Set`. If you try to add the wrong type of value to the set, the analyzer or runtime raises an error. For more information, read about [type inference.](https://dart.dev/guides/language/sound-dart#type-inference)

> 用{}的方式申明set是dart2.2版本才支持的
>
> set内的元素类型需要一致

To create an empty set, use `{}` preceded by a type argument, or assign `{}` to a variable of type `Set`:

```dart
var names = <String>{};
// Set<String> names = {}; // This works, too.
// var names = {}; // Creates a map, not a set.
```

 **Set or map?** The syntax for map literals is similar to that for set literals. Because map literals came first, `{}` defaults to the `Map` type. If you forget the type annotation on `{}` or the variable it’s assigned to, then Dart creates an object of type `Map`.

> {}赋值给一个变量，如果没有申明具体类型，则默认为map

Add items to an existing set using the `add()` or `addAll()` methods:

```dart
var elements = <String>{};
elements.add('fluorine');
elements.addAll(halogens);
```

Use `.length` to get the number of items in the set:

```dart
var elements = <String>{};
elements.add('fluorine');
elements.addAll(halogens);
assert(elements.length == 5);
```

To create a set that’s a compile-time constant, add `const` before the set literal:

```dart
final constantSet = const {
  'fluorine',
  'chlorine',
  'bromine',
  'iodine',
  'astatine',
};
// constantSet.add('helium'); // Uncommenting this causes an error.
```

As of Dart 2.3, sets support spread operators (`...` and `...?`) and collection ifs and fors, just like lists do. For more information, see the [list spread operator](https://dart.dev/guides/language/language-tour#spread-operator) and [list collection operator](https://dart.dev/guides/language/language-tour#collection-operators) discussions.

For more information about sets, see [Generics](https://dart.dev/guides/language/language-tour#generics) and [Sets](https://dart.dev/guides/libraries/library-tour#sets).

### maps

n general, a map is an object that associates keys and values. Both keys and values can be any type of object. Each *key* occurs only once, but you can use the same *value* multiple times. Dart support for maps is provided by map literals and the [Map](https://api.dart.dev/stable/dart-core/Map-class.html) type.

Here are a couple of simple Dart maps, created using map literals:

```dart
var gifts = {
  // Key:    Value
  'first': 'partridge',
  'second': 'turtledoves',
  'fifth': 'golden rings'
};

var nobleGases = {
  2: 'helium',
  10: 'neon',
  18: 'argon',
};
```

 **Note:** Dart infers that `gifts` has the type `Map` and `nobleGases` has the type `Map`. If you try to add the wrong type of value to either map, the analyzer or runtime raises an error. For more information, read about [type inference.](https://dart.dev/guides/language/sound-dart#type-inference)

> dart会暗含map的key和value类型，如果试图添加一个不匹配的类型，将会报错

You can create the same objects using a Map constructor:

```dart
var gifts = Map();
gifts['first'] = 'partridge';
gifts['second'] = 'turtledoves';
gifts['fifth'] = 'golden rings';

var nobleGases = Map();
nobleGases[2] = 'helium';
nobleGases[10] = 'neon';
nobleGases[18] = 'argon';
```

 **Note:** You might expect to see `new Map()` instead of just `Map()`. As of Dart 2, the `new` keyword is optional. For details, see [Using constructors](https://dart.dev/guides/language/language-tour#using-constructors).

> dart2，可以省略new关键字，同样是创建一个对象

Add a new key-value pair to an existing map just as you would in JavaScript:

```dart
var gifts = {'first': 'partridge'};
gifts['fourth'] = 'calling birds'; // Add a key-value pair
```

Retrieve a value from a map the same way you would in JavaScript:

```dart
var gifts = {'first': 'partridge'};
assert(gifts['first'] == 'partridge');
```

If you look for a key that isn’t in a map, you get a null in return:

```dart
var gifts = {'first': 'partridge'};
assert(gifts['fifth'] == null);
```

Use `.length` to get the number of key-value pairs in the map:

```dart
var gifts = {'first': 'partridge'};
gifts['fourth'] = 'calling birds';
assert(gifts.length == 2);
```

To create a map that’s a compile-time constant, add `const` before the map literal:

```dart
final constantMap = const {
  2: 'helium',
  10: 'neon',
  18: 'argon',
};

// constantMap[2] = 'Helium'; // Uncommenting this causes an error.
```

As of Dart 2.3, maps support spread operators (`...` and `...?`) and collection if and for, just like lists do. For details and examples, see the [spread operator proposal](https://github.com/dart-lang/language/blob/master/accepted/2.3/spread-collections/feature-specification.md) and the [control flow collections proposal.](https://github.com/dart-lang/language/blob/master/accepted/2.3/control-flow-collections/feature-specification.md)

For more information about maps, see [Generics](https://dart.dev/guides/language/language-tour#generics) and [Maps](https://dart.dev/guides/libraries/library-tour#maps).

### Runes and grapheme clusters

In Dart, [runes](https://api.dart.dev/stable/dart-core/Runes-class.html) expose the Unicode code points of a string. As of Dart 2.6, use the [characters package](https://pub.dev/packages/characters) to view or manipulate user-perceived characters, also known as [Unicode (extended) grapheme clusters.](https://unicode.org/reports/tr29/#Grapheme_Cluster_Boundaries)

Unicode defines a unique numeric value for each letter, digit, and symbol used in all of the world’s writing systems. Because a Dart string is a sequence of UTF-16 code units, expressing Unicode code points within a string requires special syntax. The usual way to express a Unicode code point is `\uXXXX`, where XXXX is a 4-digit hexadecimal value. For example, the heart character (♥) is `\u2665`. To specify more or less than 4 hex digits, place the value in curly brackets. For example, the laughing emoji (😆) is `\u{1f606}`.

If you need to read or write individual Unicode characters, use the `characters` getter defined on String by the characters package. The returned [`Characters`](https://pub.dev/documentation/characters/latest/characters/Characters-class.html) object is the string as a sequence of grapheme clusters. Here’s an example of using the characters API:

```dart
import 'package:characters/characters.dart';
...
var hi = 'Hi 🇩🇰';
print(hi);
print('The end of the string: ${hi.substring(hi.length - 1)}');
print('The last character: ${hi.characters.last}\n');
```

The output, depending on your environment, looks something like this:

```shell
$ dart bin/main.dart
Hi 🇩🇰
The end of the string: ???
The last character: 🇩🇰
```

For details on using the characters package to manipulate strings, see the [example](https://pub.dev/packages/characters#-example-tab-) and [API reference](https://pub.dev/documentation/characters) for the characters package.

> 看上去像是解释characters的用法，牢记dart的string是基于UTF-16的，包括了所有字符

### symbols

A [Symbol](https://api.dart.dev/stable/dart-core/Symbol-class.html) object represents an operator or identifier declared in a Dart program. You might never need to use symbols, but they’re invaluable for APIs that refer to identifiers by name, because minification changes identifier names but not identifier symbols.

To get the symbol for an identifier, use a symbol literal, which is just `#` followed by the identifier:

```nocode
#radix
#bar
```

Symbol literals are compile-time constants.

## Functions

Dart is a true object-oriented language, so even functions are objects and have a type, [Function.](https://api.dart.dev/stable/dart-core/Function-class.html) This means that functions can be assigned to variables or passed as arguments to other functions. You can also call an instance of a Dart class as if it were a function. For details, see [Callable classes](https://dart.dev/guides/language/language-tour#callable-classes).

> 有点类似于C语言的函数指针吧，或者JavaScript中的function

Here’s an example of implementing a function:

```dart
bool isNoble(int atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

Although Effective Dart recommends [type annotations for public APIs](https://dart.dev/guides/language/effective-dart/design#prefer-type-annotating-public-fields-and-top-level-variables-if-the-type-isnt-obvious), the function still works if you omit the types:

```dart
isNoble(atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

> 省略返回值类型虽然是被允许的，但绝不推荐！
>
> 优秀的工程师还是尽量避免这种方式吧。

For functions that contain just one expression, you can use a shorthand syntax:

```dart
bool isNoble(int atomicNumber) => _nobleGases[atomicNumber] != null;
```

The `=> *expr*` syntax is a shorthand for `{ return *expr*; }`. The `=>` notation is sometimes referred to as *arrow* syntax.

 **Note:** Only an *expression*—not a *statement*—can appear between the arrow (=>) and the semicolon (;). For example, you can’t put an [if statement](https://dart.dev/guides/language/language-tour#if-and-else) there, but you can use a [conditional expression](https://dart.dev/guides/language/language-tour#conditional-expressions).

> 只能接收一个表达式，而不是语句！

A function can have two types of parameters: *required* and *optional*. The required parameters are listed first, followed by any optional parameters. Optional parameters can be *named* or *positional*.

 **Note:** Some APIs — notably [Flutter](https://flutter.dev/) widget constructors — use only named parameters, even for parameters that are mandatory. See the next section for details.

> 命名参数大量存在于Flutter的widget构造函数中

### Optional parameters

Optional parameters can be either named or positional, but not both.

> 可选参数，既可以用命名区分，也可以用位置区分；但是，不能命名和位置同时使用！

#### Named parameters

When calling a function, you can specify named parameters using `paramName: value`. For example:

```dart
enableFlags(bold: true, hidden: false);
```

When defining a function, use `{*param1*, *param2*, …}` to specify named parameters:

```dart
/// Sets the [bold] and [hidden] flags ...
void enableFlags({bool bold, bool hidden}) {...}
```

Although named parameters are a kind of optional parameter, you can annotate them with [@required](https://pub.dev/documentation/meta/latest/meta/required-constant.html) to indicate that the parameter is mandatory — that users must provide a value for the parameter. For example:

```dart
const Scrollbar({Key key, @required Widget child})
```

If someone tries to create a `Scrollbar` without specifying the `child` argument, then the analyzer reports an issue.

To use the [@required](https://pub.dev/documentation/meta/latest/meta/required-constant.html) annotation, depend on the [meta](https://pub.dev/packages/meta) package and import `package:meta/meta.dart`.

#### Positional parameters

Wrapping a set of function parameters in `[]` marks them as optional positional parameters:

```dart
String say(String from, String msg, [String device]) {
  var result = '$from says $msg';
  if (device != null) {
    result = '$result with a $device';
  }
  return result;
}
```

Here’s an example of calling this function without the optional parameter:

```dart
assert(say('Bob', 'Howdy') == 'Bob says Howdy');
```

And here’s an example of calling this function with the third parameter:

```dart
assert(say('Bob', 'Howdy', 'smoke signal') ==
    'Bob says Howdy with a smoke signal');
```

> 我觉得，还是尽量少用基于位置区分的参数吧，命名区分更科学，可读性更好。

#### Default parameter values

Your function can use `=` to define default values for both named and positional parameters. The default values must be compile-time constants. If no default value is provided, the default value is `null`.

Here’s an example of setting default values for named parameters:

```dart
/// Sets the [bold] and [hidden] flags ...
void enableFlags({bool bold = false, bool hidden = false}) {...}

// bold will be true; hidden will be false.
enableFlags(bold: true);
```

 **Deprecation note:** Old code might use a colon (`:`) instead of `=` to set default values of named parameters. The reason is that originally, only `:` was supported for named parameters. That support might be deprecated, so we recommend that you **[use `=` to specify default values.](https://dart.dev/guides/language/effective-dart/usage#do-use--to-separate-a-named-parameter-from-its-default-value)**

The next example shows how to set default values for positional parameters:

```dart
String say(String from, String msg,
    [String device = 'carrier pigeon', String mood]) {
  var result = '$from says $msg';
  if (device != null) {
    result = '$result with a $device';
  }
  if (mood != null) {
    result = '$result (in a $mood mood)';
  }
  return result;
}

assert(say('Bob', 'Howdy') ==
    'Bob says Howdy with a carrier pigeon');
```

You can also pass lists or maps as default values. The following example defines a function, `doStuff()`, that specifies a default list for the `list` parameter and a default map for the `gifts` parameter.

```dart
void doStuff(
    {List<int> list = const [1, 2, 3],
    Map<String, String> gifts = const {
      'first': 'paper',
      'second': 'cotton',
      'third': 'leather'
    }}) {
  print('list:  $list');
  print('gifts: $gifts');
}
```

> 熟悉C++的默认参数的话，应该不难理解

### The main() function

Every app must have a top-level `main()` function, which serves as the entrypoint to the app. The `main()` function returns `void` and has an optional `List` parameter for arguments.

Here’s an example of the `main()` function for a web app:

```dart
void main() {
  querySelector('#sample_text_id')
    ..text = 'Click me!'
    ..onClick.listen(reverseText);
}
```

 **Note:** The `..` syntax in the preceding code is called a [cascade](https://dart.dev/guides/language/language-tour#cascade-notation-). With cascades, you can perform multiple operations on the members of a single object.

> 相当于语言级别帮你实现了流式API，u.14！

Here’s an example of the `main()` function for a command-line app that takes arguments:

```dart
// Run the app like this: dart args.dart 1 test
void main(List<String> arguments) {
  print(arguments);

  assert(arguments.length == 2);
  assert(int.parse(arguments[0]) == 1);
  assert(arguments[1] == 'test');
}
```

You can use the [args library](https://pub.dev/packages/args) to define and parse command-line arguments.



























































# References

- [官方网站](https://dart.dev/guides/language)

