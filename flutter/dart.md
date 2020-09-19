# [A tour of the Dart language](https://dart.dev/guides/language/language-tour)

## A basic Dart program

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



## Important concepts

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

### Functions as first-class objects

You can pass a function as a parameter to another function. For example:

```dart
void printElement(int element) {
  print(element);
}

var list = [1, 2, 3];

// Pass printElement as a parameter.
list.forEach(printElement);
```

You can also assign a function to a variable, such as:

```dart
var loudify = (msg) => '!!! ${msg.toUpperCase()} !!!';
assert(loudify('hello') == '!!! HELLO !!!');
```

This example uses an anonymous function. More about those in the next section.

> 带来方便性的同时，感觉代码的复杂程度增加了不少

### Anonymous functions

Most functions are named, such as `main()` or `printElement()`. You can also create a nameless function called an *anonymous function*, or sometimes a *lambda* or *closure*. You might assign an anonymous function to a variable so that, for example, you can add or remove it from a collection.

An anonymous function looks similar to a named function— zero or more parameters, separated by commas and optional type annotations, between parentheses.

The code block that follows contains the function’s body:

```dart
([[Type] param1[, …]]) {
	codeBlock;
};
```

The following example defines an anonymous function with an untyped parameter, `item`. The function, invoked for each item in the list, prints a string that includes the value at the specified index.

```dart
var list = ['apples', 'bananas', 'oranges'];
list.forEach((item) {
  print('${list.indexOf(item)}: $item');
});
```

If the function contains only one statement, you can shorten it using arrow notation. Paste the following line into DartPad and click **Run** to verify that it is functionally equivalent.

```dart
list.forEach(
    (item) => print('${list.indexOf(item)}: $item'));
```

> 能在同一个上下文处理，就尽量不要匿名方法吧
>

### Lexical scope

Dart is a lexically scoped language, which means that the scope of variables is determined statically, simply by the layout of the code. You can “follow the curly braces outwards” to see if a variable is in scope.

Here is an example of nested functions with variables at each scope level:

```dart
bool topLevel = true;

void main() {
  var insideMain = true;

  void myFunction() {
    var insideFunction = true;

    void nestedFunction() {
      var insideNestedFunction = true;

      assert(topLevel);
      assert(insideMain);
      assert(insideFunction);
      assert(insideNestedFunction);
    }
  }
}
```

Notice how `nestedFunction()` can use variables from every level, all the way up to the top level.

> 变量可见性的闭包原则，很普遍，没什么特殊的
>

### Lexical closures

A *closure* is a function object that has access to variables in its lexical scope, even when the function is used outside of its original scope.

Functions can close over variables defined in surrounding scopes. In the following example, `makeAdder()` captures the variable `addBy`. Wherever the returned function goes, it remembers `addBy`.

```dart
/// Returns a function that adds [addBy] to the
/// function's argument.
Function makeAdder(num addBy) {
  return (num i) => addBy + i;
}

void main() {
  // Create a function that adds 2.
  var add2 = makeAdder(2);

  // Create a function that adds 4.
  var add4 = makeAdder(4);

  assert(add2(3) == 5);
  assert(add4(3) == 7);
}
```

> 上述例子中，创建了两个Function，并各自记住了传入的addBy变量
>
> 对Java工程师来说，理解这种代码，感觉有点困难
>
> 虽然能看懂，但不推荐大量使用吧

### Testing functions for equality

Here’s an example of testing top-level functions, static methods, and instance methods for equality:

```dart
void foo() {} // A top-level function

class A {
  static void bar() {} // A static method
  void baz() {} // An instance method
}

void main() {
  var x;

  // Comparing top-level functions.
  x = foo;
  assert(foo == x);

  // Comparing static methods.
  x = A.bar;
  assert(A.bar == x);

  // Comparing instance methods.
  var v = A(); // Instance #1 of A
  var w = A(); // Instance #2 of A
  var y = w;
  x = w.baz;

  // These closures refer to the same instance (#2),
  // so they're equal.
  assert(y.baz == x);

  // These closures refer to different instances,
  // so they're unequal.
  assert(v.baz != w.baz);
}
```

> top-level：全局函数，相等
>
> static method：类静态函数，相等
>
> instance method：对象实例函数，对象不同则不相等

### Return values

All functions return a value. If no return value is specified, the statement `return null;` is implicitly appended to the function body.

```dart
foo() {}

assert(foo() == null);
```

> 不像Java有void类型，当然Java中的返回值是必须强制指定的，这点与dart语法不同。
>
> dart默认返回值是null

## Operators

Dart defines the operators shown in the following table. You can override many of these operators, as described in [Overridable operators](https://dart.dev/guides/language/language-tour#overridable-operators).

| Description              | Operator                                                     |
| ------------------------ | ------------------------------------------------------------ |
| unary postfix            | `*expr*++`  `*expr*--`  `()`  `[]`  `.`  `?.`                |
| unary prefix             | `-*expr*`  `!*expr*`  `~*expr*`  `++*expr*`  `--*expr*`   `await *expr*` |
| multiplicative           | `*`  `/`  `%` `~/`                                           |
| additive                 | `+`  `-`                                                     |
| shift                    | `<<`  `>>`  `>>>`                                            |
| bitwise AND              | `&`                                                          |
| bitwise XOR              | `^`                                                          |
| bitwise OR               | `|`                                                          |
| relational and type test | `>=`  `>`  `<=`  `<`  `as`  `is`  `is!`                      |
| equality                 | `==`  `!=`                                                   |
| logical AND              | `&&`                                                         |
| logical OR               | `||`                                                         |
| if null                  | `??`                                                         |
| conditional              | `*expr1* ? *expr2* : *expr3*`                                |
| cascade                  | `..`                                                         |
| assignment               | `=`  `*=`  `/=`  `+=`  `-=`  `&=`  `^=`  *etc.*              |

 **Warning:** Operator precedence is an approximation of the behavior of a Dart parser. For definitive answers, consult the grammar in the [Dart language specification](https://dart.dev/guides/language/spec).

When you use operators, you create expressions. Here are some examples of operator expressions:

```dart
a++
a + b
a = b
a == b
c ? a : b
a is T
```

In the [operator table](https://dart.dev/guides/language/language-tour#operators), each operator has higher precedence than the operators in the rows that follow it. For example, the multiplicative operator `%` has higher precedence than (and thus executes before) the equality operator `==`, which has higher precedence than the logical AND operator `&&`. That precedence means that the following two lines of code execute the same way:

```dart
// Parentheses improve readability.
if ((n % i == 0) && (d % i == 0)) ...

// Harder to read, but equivalent.
if (n % i == 0 && d % i == 0) ...
```

> 运算符表中的优先级，从上到下，由高到低排列

 **Warning:** For operators that work on two operands, the leftmost operand determines which version of the operator is used. For example, if you have a Vector object and a Point object, `aVector + aPoint` uses the Vector version of +.

> 双目运算符，用左边的类型靠齐。

### Arithmetic operators

Dart supports the usual arithmetic operators, as shown in the following table.

| Operator  | Meaning                                                      |
| --------- | ------------------------------------------------------------ |
| `+`       | Add                                                          |
| `–`       | Subtract                                                     |
| `-*expr*` | Unary minus, also known as negation (reverse the sign of the expression) |
| `*`       | Multiply                                                     |
| `/`       | Divide                                                       |
| `~/`      | Divide, returning an integer result                          |
| `%`       | Get the remainder of an integer division (modulo)            |

> / 和 ~/ 分开了，/ 得到的结果是double（可能带小数），~/ 得到的结果是int（整除，类似于Java中的/）

Example:

```dart
assert(2 + 3 == 5);
assert(2 - 3 == -1);
assert(2 * 3 == 6);
assert(5 / 2 == 2.5); // Result is a double
assert(5 ~/ 2 == 2); // Result is an int
assert(5 % 2 == 1); // Remainder

assert('5/2 = ${5 ~/ 2} r ${5 % 2}' == '5/2 = 2 r 1');
```

Dart also supports both prefix and postfix increment and decrement operators.

| Operator | Meaning                                            |
| -------- | -------------------------------------------------- |
| `++var`  | `vart = vart + 1` (expression value is `vart + 1`) |
| `vart++` | `vart = vart + 1` (expression value is `vart`)     |
| `--vart` | `vart = vart – 1` (expression value is `vart – 1`) |
| `vart--` | `vart = vart – 1` (expression value is `vart`)     |

Example:

```dart
var a, b;

a = 0;
b = ++a; // Increment a before b gets its value.
assert(a == b); // 1 == 1

a = 0;
b = a++; // Increment a AFTER b gets its value.
assert(a != b); // 1 != 0

a = 0;
b = --a; // Decrement a before b gets its value.
assert(a == b); // -1 == -1

a = 0;
b = a--; // Decrement a AFTER b gets its value.
assert(a != b); // -1 != 0
```

### Equality and relational operators

The following table lists the meanings of equality and relational operators.

| Operator | Meaning                     |
| -------- | --------------------------- |
| `==`     | Equal; see discussion below |
| `!=`     | Not equal                   |
| `>`      | Greater than                |
| `<`      | Less than                   |
| `>=`     | Greater than or equal to    |
| `<=`     | Less than or equal to       |

To test whether two objects x and y represent the same thing, use the `==` operator. (In the rare case where you need to know whether two objects are the exact same object, use the [identical()](https://api.dart.dev/stable/dart-core/identical.html) function instead.) Here’s how the `==` operator works:

1. If *x* or *y* is null, return true if both are null, and false if only one is null.
2. Return the result of the method invocation `x==(y)`. (That’s right, operators such as `==` are methods that are invoked on their first operand. You can even override many operators, including `==`, as you’ll see in [Overridable operators](https://dart.dev/guides/language/language-tour#overridable-operators).)

> == 类似于Java中的equals()方法，比较内容
>
> identical() 类似于Java中的==方法，判断是否同一个对象，比较内存地址

Here’s an example of using each of the equality and relational operators:

```dart
assert(2 == 2);
assert(2 != 3);
assert(3 > 2);
assert(2 < 3);
assert(3 >= 3);
assert(2 <= 3);
```

### Type test operators

The `as`, `is`, and `is!` operators are handy for checking types at runtime.

| Operator | Meaning                                                      |
| -------- | ------------------------------------------------------------ |
| `as`     | Typecast (also used to specify [library prefixes](https://dart.dev/guides/language/language-tour#specifying-a-library-prefix)) |
| `is`     | True if the object has the specified type                    |
| `is!`    | False if the object has the specified type                   |

The result of `obj is T` is true if `obj` implements the interface specified by `T`. For example, `obj is Object` is always true.

Use the `as` operator to cast an object to a particular type if and only if you are sure that the object is of that type. Example:

```dart
(emp as Person).firstName = 'Bob';
```

If you aren’t sure that the object is of type `T`, then use `is T` to check the type before using the object.

```dart
if (emp is Person) {
  // Type check
  emp.firstName = 'Bob';
}
```

 **Note:** The code isn’t equivalent. If `emp` is null or not a `Person`, the first example throws an exception; the second does nothing.

### Assignment operators

As you’ve already seen, you can assign values using the `=` operator. To assign only if the assigned-to variable is null, use the `??=` operator.

```dart
// Assign value to a
a = value;
// Assign value to b if b is null; otherwise, b stays the same
b ??= value;
```

> ??= 相当于只初始化一次
>
> 如果对此运算符不太熟悉，通过代码实现，可读性更好

Compound assignment operators such as `+=` combine an operation with an assignment.

| `=`  | `–=` | `/=`  | `%=`  | `>>=` | `^=` |
| ---- | ---- | ----- | ----- | ----- | ---- |
| `+=` | `*=` | `~/=` | `<<=` | `&=`  | `|=` |

Here’s how compound assignment operators work:

|                         | Compound assignment | Equivalent expression |
| ----------------------- | ------------------- | --------------------- |
| **For an operator op:** | `a op= b`           | `a = a op b`          |
| **Example:**            | `a += b`            | `a = a + b`           |

The following example uses assignment and compound assignment operators:

```dart
var a = 2; // Assign using =
a *= 3; // Assign and multiply: a = a * 3
assert(a == 6);
```

### Logical operators

You can invert or combine boolean expressions using the logical operators.

| Operator | Meaning                                                      |
| -------- | ------------------------------------------------------------ |
| `!expr`  | inverts the following expression (changes false to true, and vice versa) |
| `||`     | logical OR                                                   |
| `&&`     | logical AND                                                  |

Here’s an example of using the logical operators:

```dart
if (!done && (col == 0 || col == 3)) {
  // ...Do something...
}
```

### Bitwise and shift operators

You can manipulate the individual bits of numbers in Dart. Usually, you’d use these bitwise and shift operators with integers.

| Operator | Meaning                                               |
| -------- | ----------------------------------------------------- |
| `&`      | AND                                                   |
| `|`      | OR                                                    |
| `^`      | XOR                                                   |
| `~expr`  | Unary bitwise complement (0s become 1s; 1s become 0s) |
| `<<`     | Shift left                                            |
| `>>`     | Shift right                                           |

Here’s an example of using bitwise and shift operators:

```dart
final value = 0x22;
final bitmask = 0x0f;

assert((value & bitmask) == 0x02); // AND
assert((value & ~bitmask) == 0x20); // AND NOT
assert((value | bitmask) == 0x2f); // OR
assert((value ^ bitmask) == 0x2d); // XOR
assert((value << 4) == 0x220); // Shift left
assert((value >> 4) == 0x02); // Shift right
```

### Conditional expressions

Dart has two operators that let you concisely evaluate expressions that might otherwise require [if-else](https://dart.dev/guides/language/language-tour#if-and-else) statements:

- `condition ? expr1 : expr2`

  If *condition* is true, evaluates *expr1* (and returns its value); otherwise, evaluates and returns the value of *expr2*.

- `expr1 ?? expr2`

  If *expr1* is non-null, returns its value; otherwise, evaluates and returns the value of *expr2*.

> ?? 运算符可能挺常用的，尤其是在拼接输出的时候，大大增强代码简洁性

When you need to assign a value based on a boolean expression, consider using `?:`.

```dart
var visibility = isPublic ? 'public' : 'private';
```

If the boolean expression tests for null, consider using `??`.

```dart
String playerName(String name) => name ?? 'Guest';
```

The previous example could have been written at least two other ways, but not as succinctly:

```dart
// Slightly longer version uses ?: operator.
String playerName(String name) => name != null ? name : 'Guest';

// Very long version uses if-else statement.
String playerName(String name) {
  if (name != null) {
    return name;
  } else {
    return 'Guest';
  }
}
```

### Cascade notation (..)

Cascades (`..`) allow you to make a sequence of operations on the same object. In addition to function calls, you can also access fields on that same object. This often saves you the step of creating a temporary variable and allows you to write more fluid code.

Consider the following code:

```dart
querySelector('#confirm') // Get an object.
  ..text = 'Confirm' // Use its members.
  ..classes.add('important')
  ..onClick.listen((e) => window.alert('Confirmed!'));
```

The first method call, `querySelector()`, returns a selector object. The code that follows the cascade notation operates on this selector object, ignoring any subsequent values that might be returned.

The previous example is equivalent to:

```dart
var button = querySelector('#confirm');
button.text = 'Confirm';
button.classes.add('important');
button.onClick.listen((e) => window.alert('Confirmed!'));
```

You can also nest your cascades. For example:

```dart
final addressBook = (AddressBookBuilder()
      ..name = 'jenny'
      ..email = 'jenny@example.com'
      ..phone = (PhoneNumberBuilder()
            ..number = '415-555-0100'
            ..label = 'home')
          .build())
    .build();
```

Be careful to construct your cascade on a function that returns an actual object. For example, the following code fails:

```dart
var sb = StringBuffer();
sb.write('foo')
  ..write('bar'); // Error: method 'write' isn't defined for 'void'.
```

The `sb.write()` call returns void, and you can’t construct a cascade on `void`.

 **Note:** Strictly speaking, the “double dot” notation for cascades is not an operator. It’s just part of the Dart syntax.

> 相当于在语法级别支持了流式设计模式，u.14！

### Other operators

You’ve seen most of the remaining operators in other examples:

| Operator | Name                      | Meaning                                                      |
| -------- | ------------------------- | ------------------------------------------------------------ |
| `()`     | Function application      | Represents a function call                                   |
| `[]`     | List access               | Refers to the value at the specified index in the list       |
| `.`      | Member access             | Refers to a property of an expression; example: `foo.bar` selects property `bar` from expression `foo` |
| `?.`     | Conditional member access | Like `.`, but the leftmost operand can be null; example: `foo?.bar` selects property `bar` from expression `foo` unless `foo` is null (in which case the value of `foo?.bar` is null) |

For more information about the `.`, `?.`, and `..` operators, see [Classes](https://dart.dev/guides/language/language-tour#classes).

> ?. 简化了判空逻辑，增强代码的简洁性

## Control flow statements

You can control the flow of your Dart code using any of the following:

- `if` and `else`
- `for` loops
- `while` and `do`-`while` loops
- `break` and `continue`
- `switch` and `case`
- `assert`

You can also affect the control flow using `try-catch` and `throw`, as explained in [Exceptions](https://dart.dev/guides/language/language-tour#exceptions).

### If and else

Dart supports `if` statements with optional `else` statements, as the next sample shows. Also see [conditional expressions](https://dart.dev/guides/language/language-tour#conditional-expressions).

```dart
if (isRaining()) {
  you.bringRainCoat();
} else if (isSnowing()) {
  you.wearJacket();
} else {
  car.putTopDown();
}
```

Unlike JavaScript, conditions must use boolean values, nothing else. See [Booleans](https://dart.dev/guides/language/language-tour#booleans) for more information.

### For loops

You can iterate with the standard `for` loop. For example:

```dart
var message = StringBuffer('Dart is fun');
for (var i = 0; i < 5; i++) {
  message.write('!');
}
```

Closures inside of Dart’s `for` loops capture the *value* of the index, avoiding a common pitfall found in JavaScript. For example, consider:

```dart
var callbacks = [];
for (var i = 0; i < 2; i++) {
  callbacks.add(() => print(i));
}
callbacks.forEach((c) => c());
```

The output is `0` and then `1`, as expected. In contrast, the example would print `2` and then `2` in JavaScript.

If the object that you are iterating over is an Iterable, you can use the [forEach()](https://api.dart.dev/stable/dart-core/Iterable/forEach.html) method. Using `forEach()` is a good option if you don’t need to know the current iteration counter:

```dart
candidates.forEach((candidate) => candidate.interview());
```

Iterable classes such as List and Set also support the `for-in` form of [iteration](https://dart.dev/guides/libraries/library-tour#iteration):

```dart
var collection = [0, 1, 2];
for (var x in collection) {
  print(x); // 0 1 2
}
```

### While and do-while

A `while` loop evaluates the condition before the loop:

```dart
while (!isDone()) {
  doSomething();
}
```

A `do`-`while` loop evaluates the condition *after* the loop:

```dart
do {
  printLine();
} while (!atEndOfPage());
```

### Break and continue

Use `break` to stop looping:

```dart
while (true) {
  if (shutDownRequested()) break;
  processIncomingRequests();
}
```

Use `continue` to skip to the next loop iteration:

```dart
for (int i = 0; i < candidates.length; i++) {
  var candidate = candidates[i];
  if (candidate.yearsExperience < 5) {
    continue;
  }
  candidate.interview();
}
```

You might write that example differently if you’re using an [Iterable](https://api.dart.dev/stable/dart-core/Iterable-class.html) such as a list or set:

```dart
candidates
    .where((c) => c.yearsExperience >= 5)
    .forEach((c) => c.interview());
```

> where方法很赞，增强了代码可读性！

### Switch and case

Switch statements in Dart compare integer, string, or compile-time constants using `==`. The compared objects must all be instances of the same class (and not of any of its subtypes), and the class must not override `==`. [Enumerated types](https://dart.dev/guides/language/language-tour#enumerated-types) work well in `switch` statements.

> int、string、编译时常量可以被switch...case...
>
> 被switch的类是精确地同一种类型（不能是子类），并且不能重载==运算符
>
> 枚举类型在switch中工作的很顺畅，推荐使用

 **Note:** Switch statements in Dart are intended for limited circumstances, such as in interpreters or scanners.

Each non-empty `case` clause ends with a `break` statement, as a rule. Other valid ways to end a non-empty `case` clause are a `continue`, `throw`, or `return` statement.

Use a `default` clause to execute code when no `case` clause matches:

```dart
var command = 'OPEN';
switch (command) {
  case 'CLOSED':
    executeClosed();
    break;
  case 'PENDING':
    executePending();
    break;
  case 'APPROVED':
    executeApproved();
    break;
  case 'DENIED':
    executeDenied();
    break;
  case 'OPEN':
    executeOpen();
    break;
  default:
    executeUnknown();
}
```

The following example omits the `break` statement in a `case` clause, thus generating an error:

```dart
var command = 'OPEN';
switch (command) {
  case 'OPEN':
    executeOpen();
    // ERROR: Missing break

  case 'CLOSED':
    executeClosed();
    break;
}
```

However, Dart does support empty `case` clauses, allowing a form of fall-through:

```dart
var command = 'CLOSED';
switch (command) {
  case 'CLOSED': // Empty case falls through.
  case 'NOW_CLOSED':
    // Runs for both CLOSED and NOW_CLOSED.
    executeNowClosed();
    break;
}
```

If you really want fall-through, you can use a `continue` statement and a label:

```dart
var command = 'CLOSED';
switch (command) {
  case 'CLOSED':
    executeClosed();
    continue nowClosed;
  // Continues executing at the nowClosed label.

  nowClosed:
  case 'NOW_CLOSED':
    // Runs for both CLOSED and NOW_CLOSED.
    executeNowClosed();
    break;
}
```

A `case` clause can have local variables, which are visible only inside the scope of that clause.

### Assert

During development, use an assert statement — `assert(condition, optionalMessage)`; — to disrupt normal execution if a boolean condition is false. You can find examples of assert statements throughout this tour. Here are some more:

```dart
// Make sure the variable has a non-null value.
assert(text != null);

// Make sure the value is less than 100.
assert(number < 100);

// Make sure this is an https URL.
assert(urlString.startsWith('https'));
```

To attach a message to an assertion, add a string as the second argument to `assert`.

```dart
assert(urlString.startsWith('https'),
    'URL ($urlString) should start with "https".');
```

The first argument to `assert` can be any expression that resolves to a boolean value. If the expression’s value is true, the assertion succeeds and execution continues. If it’s false, the assertion fails and an exception (an [AssertionError](https://api.dart.dev/stable/dart-core/AssertionError-class.html)) is thrown.

When exactly do assertions work? That depends on the tools and framework you’re using:

- Flutter enables assertions in [debug mode.](https://flutter.dev/docs/testing/debugging#debug-mode-assertions)
- Development-only tools such as [dartdevc](https://dart.dev/tools/dartdevc) typically enable assertions by default.
- Some tools, such as [dart](https://dart.dev/server/tools/dart-vm) and [dart2js,](https://dart.dev/tools/dart2js) support assertions through a command-line flag: `--enable-asserts`.

In production code, assertions are ignored, and the arguments to `assert` aren’t evaluated.

> debug模式默认开启assert，product模式默认关闭
>
> 开发工具环境下，比如dartdevc默认开启assert
>
> 某些工具，比如dart和dart2js，可以接收命令行参数开启assert

## Exceptions

Your Dart code can throw and catch exceptions. Exceptions are errors indicating that something unexpected happened. If the exception isn’t caught, the [isolate](https://dart.dev/guides/language/language-tour#isolates) that raised the exception is suspended, and typically the isolate and its program are terminated.

In contrast to Java, all of Dart’s exceptions are unchecked exceptions. Methods do not declare which exceptions they might throw, and you are not required to catch any exceptions.

Dart provides [Exception](https://api.dart.dev/stable/dart-core/Exception-class.html) and [Error](https://api.dart.dev/stable/dart-core/Error-class.html) types, as well as numerous predefined subtypes. You can, of course, define your own exceptions. However, Dart programs can throw any non-null object—not just Exception and Error objects—as an exception.

### Throw

Here’s an example of throwing, or *raising*, an exception:

```dart
throw FormatException('Expected at least 1 section');
```

You can also throw arbitrary objects:

```dart
throw 'Out of llamas!';
```

 **Note:** Production-quality code usually throws types that implement [Error](https://api.dart.dev/stable/dart-core/Error-class.html) or [Exception](https://api.dart.dev/stable/dart-core/Exception-class.html).

> throw 非Exception or Error对象时，只能通过catch捕获，不能用on，下面的catch章节有介绍

Because throwing an exception is an expression, you can throw exceptions in => statements, as well as anywhere else that allows expressions:

```dart
void distanceTo(Point other) => throw UnimplementedError();
```

### Catch

Catching, or capturing, an exception stops the exception from propagating (unless you rethrow the exception). Catching an exception gives you a chance to handle it:

```dart
try {
  breedMoreLlamas();
} on OutOfLlamasException {
  buyMoreLlamas();
}
```

To handle code that can throw more than one type of exception, you can specify multiple catch clauses. The first catch clause that matches the thrown object’s type handles the exception. If the catch clause does not specify a type, that clause can handle any type of thrown object:

```dart
try {
  breedMoreLlamas();
} on OutOfLlamasException {
  // A specific exception
  buyMoreLlamas();
} on Exception catch (e) {
  // Anything else that is an exception
  print('Unknown exception: $e');
} catch (e) {
  // No specified type, handles all
  print('Something really unknown: $e');
}
```

As the preceding code shows, you can use either `on` or `catch` or both. Use `on` when you need to specify the exception type. Use `catch` when your exception handler needs the exception object.

You can specify one or two parameters to `catch()`. The first is the exception that was thrown, and the second is the stack trace (a [StackTrace](https://api.dart.dev/stable/dart-core/StackTrace-class.html) object).

```dart
try {
  // ···
} on Exception catch (e) {
  print('Exception details:\n $e');
} catch (e, s) {
  print('Exception details:\n $e');
  print('Stack trace:\n $s');
}
```

To partially handle an exception, while allowing it to propagate, use the `rethrow` keyword.

```dart
void misbehave() {
  try {
    dynamic foo = true;
    print(foo++); // Runtime error
  } catch (e) {
    print('misbehave() partially handled ${e.runtimeType}.');
    rethrow; // Allow callers to see the exception.
  }
}

void main() {
  try {
    misbehave();
  } catch (e) {
    print('main() finished handling ${e.runtimeType}.');
  }
}
```

### Finally

To ensure that some code runs whether or not an exception is thrown, use a `finally` clause. If no `catch` clause matches the exception, the exception is propagated after the `finally` clause runs:

```dart
try {
  breedMoreLlamas();
} finally {
  // Always clean up, even if an exception is thrown.
  cleanLlamaStalls();
}
```

The `finally` clause runs after any matching `catch` clauses:

```dart
try {
  breedMoreLlamas();
} catch (e) {
  print('Error: $e'); // Handle the exception first.
} finally {
  cleanLlamaStalls(); // Then clean up.
}
```

Learn more by reading the [Exceptions](https://dart.dev/guides/libraries/library-tour#exceptions) section of the library tour.

## Classes

Dart is an object-oriented language with classes and mixin-based inheritance. Every object is an instance of a class, and all classes descend from [Object.](https://api.dart.dev/stable/dart-core/Object-class.html) *Mixin-based inheritance* means that although every class (except for Object) has exactly one superclass, a class body can be reused in multiple class hierarchies. [Extension methods](https://dart.dev/guides/language/language-tour#extension-methods) are a way to add functionality to a class without changing the class or creating a subclass.

### Using class members

Objects have *members* consisting of functions and data (*methods* and *instance variables*, respectively). When you call a method, you *invoke* it on an object: the method has access to that object’s functions and data.

Use a dot (`.`) to refer to an instance variable or method:

```dart
var p = Point(2, 2);

// Set the value of the instance variable y.
p.y = 3;

// Get the value of y.
assert(p.y == 3);

// Invoke distanceTo() on p.
num distance = p.distanceTo(Point(4, 4));
```

Use `?.` instead of `.` to avoid an exception when the leftmost operand is null:

```dart
// If p is non-null, set its y value to 4.
p?.y = 4;
```

> ?. 带来代码的简洁性，付出的代价是程序员多理解一个操作符

### Using constructors

You can create an object using a *constructor*. Constructor names can be either `*ClassName*` or `*ClassName*.*identifier*`. For example, the following code creates `Point` objects using the `Point()` and `Point.fromJson()` constructors:

```dart
var p1 = Point(2, 2);
var p2 = Point.fromJson({'x': 1, 'y': 2});
```

The following code has the same effect, but uses the optional `new` keyword before the constructor name:

```dart
var p1 = new Point(2, 2);
var p2 = new Point.fromJson({'x': 1, 'y': 2});
```

 **Version note:** The `new` keyword became optional in Dart 2.

Some classes provide [constant constructors](https://dart.dev/guides/language/language-tour#constant-constructors). To create a compile-time constant using a constant constructor, put the `const` keyword before the constructor name:

```dart
var p = const ImmutablePoint(2, 2);
```

Constructing two identical compile-time constants results in a single, canonical instance:

```dart
var a = const ImmutablePoint(1, 1);
var b = const ImmutablePoint(1, 1);

assert(identical(a, b)); // They are the same instance!
```

> const变量在compile-time被创建为singleton

Within a *constant context*, you can omit the `const` before a constructor or literal. For example, look at this code, which creates a const map:

```dart
// Lots of const keywords here.
const pointAndLine = const {
  'point': const [const ImmutablePoint(0, 0)],
  'line': const [const ImmutablePoint(1, 10), const ImmutablePoint(-2, 11)],
};
```

You can omit all but the first use of the `const` keyword:

```dart
// Only one const, which establishes the constant context.
const pointAndLine = {
  'point': [ImmutablePoint(0, 0)],
  'line': [ImmutablePoint(1, 10), ImmutablePoint(-2, 11)],
};
```

If a constant constructor is outside of a constant context and is invoked without `const`, it creates a **non-constant object**:

```dart
var a = const ImmutablePoint(1, 1); // Creates a constant
var b = ImmutablePoint(1, 1); // Does NOT create a constant

assert(!identical(a, b)); // NOT the same instance!
```

 **Version note:** The `const` keyword became optional within a constant context in Dart 2.

### Getting an object’s type

To get an object’s type at runtime, you can use Object’s `runtimeType` property, which returns a [Type](https://api.dart.dev/stable/dart-core/Type-class.html) object.

```dart
print('The type of a is ${a.runtimeType}');
```

Up to here, you’ve seen how to *use* classes. The rest of this section shows how to *implement* classes.

> 类似于Java的getClass()

### Instance variables

Here’s how you declare instance variables:

```dart
class Point {
  num x; // Declare instance variable x, initially null.
  num y; // Declare y, initially null.
  num z = 0; // Declare z, initially 0.
}
```

All uninitialized instance variables have the value `null`.

All instance variables generate an implicit *getter* method. Non-final instance variables also generate an implicit *setter* method. For details, see [Getters and setters](https://dart.dev/guides/language/language-tour#getters-and-setters).

```dart
class Point {
  num x;
  num y;
}

void main() {
  var point = Point();
  point.x = 4; // Use the setter method for x.
  assert(point.x == 4); // Use the getter method for x.
  assert(point.y == null); // Values default to null.
}
```

If you initialize an instance variable where it is declared (instead of in a constructor or method), the value is set when the instance is created, which is before the constructor and its initializer list execute.

> initializer list，不太理解这个的意思，可能后面会讲到

### Constructors

Declare a constructor by creating a function with the same name as its class (plus, optionally, an additional identifier as described in [Named constructors](https://dart.dev/guides/language/language-tour#named-constructors)). The most common form of constructor, the generative constructor, creates a new instance of a class:

```dart
class Point {
  num x, y;

  Point(num x, num y) {
    // There's a better way to do this, stay tuned.
    this.x = x;
    this.y = y;
  }
}
```

The `this` keyword refers to the current instance.

 **Note:** Use `this` only when there is a name conflict. Otherwise, Dart style omits the `this`.

The pattern of assigning a constructor argument to an instance variable is so common, Dart has syntactic sugar to make it easy:

```dart
class Point {
  num x, y;

  // Syntactic sugar for setting x and y
  // before the constructor body runs.
  Point(this.x, this.y);
}
```

> 这个语法糖很实用，增加代码的简洁度

#### Default constructors

If you don’t declare a constructor, a default constructor is provided for you. The default constructor has no arguments and invokes the no-argument constructor in the superclass.

#### Constructors aren’t inherited

Subclasses don’t inherit constructors from their superclass. A subclass that declares no constructors has only the default (no argument, no name) constructor.

#### Named constructors

Use a named constructor to implement multiple constructors for a class or to provide extra clarity:

```dart
class Point {
  num x, y;

  Point(this.x, this.y);

  // Named constructor
  Point.origin() {
    x = 0;
    y = 0;
  }
}
```

Remember that constructors are not inherited, which means that a superclass’s named constructor is not inherited by a subclass. If you want a subclass to be created with a named constructor defined in the superclass, you must implement that constructor in the subclass.

> 构造函数不能被集成，子类需要自己实现

#### Invoking a non-default superclass constructor

By default, a constructor in a subclass calls the superclass’s unnamed, no-argument constructor. The superclass’s constructor is called at the beginning of the constructor body. If an [initializer list](https://dart.dev/guides/language/language-tour#initializer-list) is also being used, it executes before the superclass is called. In summary, the order of execution is as follows:

1. initializer list
2. superclass’s no-arg constructor
3. main class’s no-arg constructor

If the superclass doesn’t have an unnamed, no-argument constructor, then you must manually call one of the constructors in the superclass. Specify the superclass constructor after a colon (`:`), just before the constructor body (if any).

In the following example, the constructor for the Employee class calls the named constructor for its superclass, Person. Click **Run** to execute the code.

<iframe src="https://dartpad.dev/embed-inline.html?id=e57aa06401e6618d4eb8&amp;split=90&amp;ga_id=non_default_superclass_constructor" width="100%" height="500px" style="box-sizing: border-box; color: rgb(33, 37, 41); font-family: Roboto, sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 300; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial; border: 1px solid rgb(204, 204, 204);"></iframe>



Because the arguments to the superclass constructor are evaluated before invoking the constructor, an argument can be an expression such as a function call:

```dart
class Employee extends Person {
  Employee() : super.fromJson(defaultData);
  // ···
}
```

 **Warning:** Arguments to the superclass constructor do not have access to `this`. For example, arguments can call static methods but not instance methods.

#### Initializer list

Besides invoking a superclass constructor, you can also initialize instance variables before the constructor body runs. Separate initializers with commas.

```dart
// Initializer list sets instance variables before
// the constructor body runs.
Point.fromJson(Map<String, num> json)
    : x = json['x'],
      y = json['y'] {
  print('In Point.fromJson(): ($x, $y)');
}
```

 **Warning:** The right-hand side of an initializer does not have access to `this`.

During development, you can validate inputs by using `assert` in the initializer list.

```dart
Point.withAssert(this.x, this.y) : assert(x >= 0) {
  print('In Point.withAssert(): ($x, $y)');
}
```

Initializer lists are handy when setting up final fields. The following example initializes three final fields in an initializer list. Click **Run** to execute the code.

<iframe src="https://dartpad.dev/embed-inline.html?id=7a9764702c0608711e08&amp;split=90&amp;ga_id=initializer_list" width="100%" height="420px" style="box-sizing: border-box; color: rgb(33, 37, 41); font-family: Roboto, sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 300; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial; border: 1px solid rgb(204, 204, 204);"></iframe>



#### Redirecting constructors

Sometimes a constructor’s only purpose is to redirect to another constructor in the same class. A redirecting constructor’s body is empty, with the constructor call appearing after a colon (:).

```dart
class Point {
  num x, y;

  // The main constructor for this class.
  Point(this.x, this.y);

  // Delegates to the main constructor.
  Point.alongXAxis(num x) : this(x, 0);
}
```

#### Constant constructors

If your class produces objects that never change, you can make these objects compile-time constants. To do this, define a `const` constructor and make sure that all instance variables are `final`.

```dart
class ImmutablePoint {
  static final ImmutablePoint origin =
      const ImmutablePoint(0, 0);

  final num x, y;

  const ImmutablePoint(this.x, this.y);
}
```

Constant constructors don’t always create constants. For details, see the section on [using constructors](https://dart.dev/guides/language/language-tour#using-constructors).

> 牢记，const是compile-time常量，这点与Java不同

#### Factory constructors

Use the `factory` keyword when implementing a constructor that doesn’t always create a new instance of its class. For example, a factory constructor might return an instance from a cache, or it might return an instance of a subtype.

The following example demonstrates a factory constructor returning objects from a cache:

```dart
class Logger {
  final String name;
  bool mute = false;

  // _cache is library-private, thanks to
  // the _ in front of its name.
  static final Map<String, Logger> _cache =
      <String, Logger>{};

  factory Logger(String name) {
    return _cache.putIfAbsent(
        name, () => Logger._internal(name));
  }

  Logger._internal(this.name);

  void log(String msg) {
    if (!mute) print(msg);
  }
}
```

 **Note:** Factory constructors have no access to `this`.

Invoke a factory constructor just like you would any other constructor:

```dart
var logger = Logger('UI');
logger.log('Button clicked');
```

> factory关键字带来实例的灵活性，例如可以实现cache
>
> 变量命名之前加_，应该是某种特殊用法，library-private，暂时还不清楚，可能后面会讲到
>
> factory类型的构造函数，不能访问this

### Methods

Methods are functions that provide behavior for an object.

#### Instance methods

Instance methods on objects can access instance variables and `this`. The `distanceTo()` method in the following sample is an example of an instance method:

```dart
import 'dart:math';

class Point {
  num x, y;

  Point(this.x, this.y);

  num distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
}
```

#### Getters and setters

Getters and setters are special methods that provide read and write access to an object’s properties. Recall that each instance variable has an implicit getter, plus a setter if appropriate. You can create additional properties by implementing getters and setters, using the `get` and `set` keywords:

```dart
class Rectangle {
  num left, top, width, height;

  Rectangle(this.left, this.top, this.width, this.height);

  // Define two calculated properties: right and bottom.
  num get right => left + width;
  set right(num value) => left = value - width;
  num get bottom => top + height;
  set bottom(num value) => top = value - height;
}

void main() {
  var rect = Rectangle(3, 4, 20, 15);
  assert(rect.left == 3);
  rect.right = 12;
  assert(rect.left == -8);
}
```

With getters and setters, you can start with instance variables, later wrapping them with methods, all without changing client code.

 **Note:** Operators such as increment (++) work in the expected way, whether or not a getter is explicitly defined. To avoid any unexpected side effects, the operator calls the getter exactly once, saving its value in a temporary variable.

#### Abstract methods

Instance, getter, and setter methods can be abstract, defining an interface but leaving its implementation up to other classes. Abstract methods can only exist in [abstract classes](https://dart.dev/guides/language/language-tour#abstract-classes).

To make a method abstract, use a semicolon (;) instead of a method body:

```dart
abstract class Doer {
  // Define instance variables and methods...

  void doSomething(); // Define an abstract method.
}

class EffectiveDoer extends Doer {
  void doSomething() {
    // Provide an implementation, so the method is not abstract here...
  }
}
```

> 与Java不同，abstract方法不需要用关键字申明，只需要用;代替方法体即可

### Abstract classes

Use the `abstract` modifier to define an *abstract class*—a class that can’t be instantiated. Abstract classes are useful for defining interfaces, often with some implementation. If you want your abstract class to appear to be instantiable, define a [factory constructor](https://dart.dev/guides/language/language-tour#factory-constructors).

Abstract classes often have [abstract methods](https://dart.dev/guides/language/language-tour#abstract-methods). Here’s an example of declaring an abstract class that has an abstract method:

```dart
// This class is declared abstract and thus
// can't be instantiated.
abstract class AbstractContainer {
  // Define constructors, fields, methods...

  void updateChildren(); // Abstract method.
}
```

> abstract类不能直接初始化，但可以定义factory构造函数
>

### Implicit interfaces

Every class implicitly defines an interface containing all the instance members of the class and of any interfaces it implements. If you want to create a class A that supports class B’s API without inheriting B’s implementation, class A should implement the B interface.

A class implements one or more interfaces by declaring them in an `implements` clause and then providing the APIs required by the interfaces. For example:

```dart
// A person. The implicit interface contains greet().
class Person {
  // In the interface, but visible only in this library.
  final _name;

  // Not in the interface, since this is a constructor.
  Person(this._name);

  // In the interface.
  String greet(String who) => 'Hello, $who. I am $_name.';
}

// An implementation of the Person interface.
class Impostor implements Person {
  get _name => '';

  String greet(String who) => 'Hi $who. Do you know who I am?';
}

String greetBob(Person person) => person.greet('Bob');

void main() {
  print(greetBob(Person('Kathy')));
  print(greetBob(Impostor()));
}
```

Here’s an example of specifying that a class implements multiple interfaces:

```dart
class Point implements Comparable, Location {...}
```

### Extending a class

Use `extends` to create a subclass, and `super` to refer to the superclass:

```dart
class Television {
  void turnOn() {
    _illuminateDisplay();
    _activateIrSensor();
  }
  // ···
}

class SmartTelevision extends Television {
  void turnOn() {
    super.turnOn();
    _bootNetworkInterface();
    _initializeMemory();
    _upgradeApps();
  }
  // ···
}
```

#### Overriding members

Subclasses can override instance methods, getters, and setters. You can use the `@override` annotation to indicate that you are intentionally overriding a member:

```dart
class SmartTelevision extends Television {
  @override
  void turnOn() {...}
  // ···
}
```

To narrow the type of a method parameter or instance variable in code that is [type safe](https://dart.dev/guides/language/sound-dart), you can use the [`covariant` keyword](https://dart.dev/guides/language/sound-problems#the-covariant-keyword).

#### Overridable operators

You can override the operators shown in the following table. For example, if you define a Vector class, you might define a `+` method to add two vectors.

| `<`  | `+`  | `|`  | `[]`  |
| ---- | ---- | ---- | ----- |
| `>`  | `/`  | `^`  | `[]=` |
| `<=` | `~/` | `&`  | `~`   |
| `>=` | `*`  | `<<` | `==`  |
| `–`  | `%`  | `>>` |       |

 **Note:** You may have noticed that `!=` is not an overridable operator. The expression `e1 != e2` is just syntactic sugar for `!(e1 == e2)`.

Here’s an example of a class that overrides the `+` and `-` operators:

```dart
class Vector {
  final int x, y;

  Vector(this.x, this.y);

  Vector operator +(Vector v) => Vector(x + v.x, y + v.y);
  Vector operator -(Vector v) => Vector(x - v.x, y - v.y);

  // Operator == and hashCode not shown. For details, see note below.
  // ···
}

void main() {
  final v = Vector(2, 3);
  final w = Vector(2, 2);

  assert(v + w == Vector(4, 5));
  assert(v - w == Vector(0, 1));
}
```

If you override `==`, you should also override Object’s `hashCode` getter. For an example of overriding `==` and `hashCode`, see [Implementing map keys](https://dart.dev/guides/libraries/library-tour#implementing-map-keys).

For more information on overriding, in general, see [Extending a class](https://dart.dev/guides/language/language-tour#extending-a-class).

> 运算符重载属于高阶操作，一般不推荐使用
>
> 但不同于Java的是，没看到equals()方法，估计都是通过==来比对的吧
>
> 看上去这个章节是绕不过去了

#### noSuchMethod()

To detect or react whenever code attempts to use a non-existent method or instance variable, you can override `noSuchMethod()`:

```dart
class A {
  // Unless you override noSuchMethod, using a
  // non-existent member results in a NoSuchMethodError.
  @override
  void noSuchMethod(Invocation invocation) {
    print('You tried to use a non-existent member: ' +
        '${invocation.memberName}');
  }
}
```

You **can’t invoke** an unimplemented method unless **one** of the following is true:

- The receiver has the static type `dynamic`.
- The receiver has a static type that defines the unimplemented method (abstract is OK), and the dynamic type of the receiver has an implemention of `noSuchMethod()` that’s different from the one in class `Object`.

For more information, see the informal [noSuchMethod forwarding specification.](https://github.com/dart-lang/sdk/blob/master/docs/language/informal/nosuchmethod-forwarding.md)

> 这也太灵活了吧！
>
> 我还是接受报错吧，在没有掌握得很好之前，不要瞎搞

### Extension methods

Extension methods, introduced in Dart 2.7, are a way to add functionality to existing libraries. You might use extension methods without even knowing it. For example, when you use code completion in an IDE, it suggests extension methods alongside regular methods.

Here’s an example of using an extension method on `String` named `parseInt()` that’s defined in `string_apis.dart`:

```dart
import 'string_apis.dart';
...
print('42'.padLeft(5)); // Use a String method.
print('42'.parseInt()); // Use an extension method.
```

For details of using and implementing extension methods, see the [extension methods page](https://dart.dev/guides/language/extension-methods).

> 这个特性，非常有想象力！
>
> I like the Dart world!

### Enumerated types

Enumerated types, often called *enumerations* or *enums*, are a special kind of class used to represent a fixed number of constant values.

#### Using enums

Declare an enumerated type using the `enum` keyword:

```dart
enum Color { red, green, blue }
```

Each value in an enum has an `index` getter, which returns the zero-based position of the value in the enum declaration. For example, the first value has index 0, and the second value has index 1.

```dart
assert(Color.red.index == 0);
assert(Color.green.index == 1);
assert(Color.blue.index == 2);
```

To get a list of all of the values in the enum, use the enum’s `values` constant.

```dart
List<Color> colors = Color.values;
assert(colors[2] == Color.blue);
```

You can use enums in [switch statements](https://dart.dev/guides/language/language-tour#switch-and-case), and you’ll get a warning if you don’t handle all of the enum’s values:

```dart
var aColor = Color.blue;

switch (aColor) {
  case Color.red:
    print('Red as roses!');
    break;
  case Color.green:
    print('Green as grass!');
    break;
  default: // Without this, you see a WARNING.
    print(aColor); // 'Color.blue'
}
```

Enumerated types have the following limits:

- You can’t subclass, mix in, or implement an enum.
- You can’t explicitly instantiate an enum.

For more information, see the [Dart language specification](https://dart.dev/guides/language/spec).

> - 枚举使用enum关键字
> - 每个enum项都默认有index这个属性，它是从0开始递增的
> - enum可以在switch...case...中使用
> - enum有两个限制：
>   1. 不能子类、mix in或者implement
>   2. 不能显式的初始化它

### Adding features to a class: mixins

Mixins are a way of reusing a class’s code in multiple class hierarchies.

To *use* a mixin, use the `with` keyword followed by one or more mixin names. The following example shows two classes that use mixins:

```dart
class Musician extends Performer with Musical {
  // ···
}

class Maestro extends Person
    with Musical, Aggressive, Demented {
  Maestro(String maestroName) {
    name = maestroName;
    canConduct = true;
  }
}
```

To *implement* a mixin, create a class that extends Object and declares no constructors. Unless you want your mixin to be usable as a regular class, use the `mixin` keyword instead of `class`. For example:

```dart
mixin Musical {
  bool canPlayPiano = false;
  bool canCompose = false;
  bool canConduct = false;

  void entertainMe() {
    if (canPlayPiano) {
      print('Playing piano');
    } else if (canConduct) {
      print('Waving hands');
    } else {
      print('Humming to self');
    }
  }
}
```

To specify that only certain types can use the mixin — for example, so your mixin can invoke a method that it doesn’t define — use `on` to specify the required superclass:

```dart
mixin MusicalPerformer on Musician {
  // ···
}
```

> on关键字表示只有Musician的子类能使用with附加上MusicalPerformer

 **Version note:** Support for the `mixin` keyword was introduced in Dart 2.1. Code in earlier releases usually used `abstract class` instead. For more information on 2.1 mixin changes, see the [Dart SDK changelog](https://github.com/dart-lang/sdk/blob/master/CHANGELOG.md) and [2.1 mixin specification.](https://github.com/dart-lang/language/blob/master/accepted/2.1/super-mixins/feature-specification.md#dart-2-mixin-declarations)

> mixin机制比较难理解，并且Java不具备这种机制，要多看多理解
>
> 可以参考如下网页内容：
>
> https://juejin.im/post/5d3d9ccc6fb9a07ef81a45fb
>
> https://my.oschina.net/zzxzzg/blog/2962518
>
> https://medium.com/flutter-community/https-medium-com-shubhamhackzz-dart-for-flutter-mixins-in-dart-f8bb10a3d341

### Class variables and methods

Use the `static` keyword to implement class-wide variables and methods.

#### Static variables

Static variables (class variables) are useful for class-wide state and constants:

```dart
class Queue {
  static const initialCapacity = 16;
  // ···
}

void main() {
  assert(Queue.initialCapacity == 16);
}
```

Static variables aren’t initialized until they’re used.

 **Note:** This page follows the [style guide recommendation](https://dart.dev/guides/language/effective-dart/style#identifiers) of preferring `lowerCamelCase` for constant names.

#### Static methods

Static methods (class methods) do not operate on an instance, and thus do not have access to `this`. For example:

```dart
import 'dart:math';

class Point {
  num x, y;
  Point(this.x, this.y);

  static num distanceBetween(Point a, Point b) {
    var dx = a.x - b.x;
    var dy = a.y - b.y;
    return sqrt(dx * dx + dy * dy);
  }
}

void main() {
  var a = Point(2, 2);
  var b = Point(4, 4);
  var distance = Point.distanceBetween(a, b);
  assert(2.8 < distance && distance < 2.9);
  print(distance);
}
```

 **Note:** Consider using top-level functions, instead of static methods, for common or widely used utilities and functionality.

You can use static methods as compile-time constants. For example, you can pass a static method as a parameter to a constant constructor.

## Generics

If you look at the API documentation for the basic array type, [List,](https://api.dart.dev/stable/dart-core/List-class.html) you’ll see that the type is actually `List`. The <…> notation marks List as a *generic* (or *parameterized*) type—a type that has formal type parameters. [By convention](https://dart.dev/guides/language/effective-dart/design#do-follow-existing-mnemonic-conventions-when-naming-type-parameters), most type variables have single-letter names, such as E, T, S, K, and V.

### Why use generics?

Generics are often required for type safety, but they have more benefits than just allowing your code to run:

- Properly specifying generic types results in better generated code.
- You can use generics to reduce code duplication.

If you intend for a list to contain only strings, you can declare it as `List` (read that as “list of string”). That way you, your fellow programmers, and your tools can detect that assigning a non-string to the list is probably a mistake. Here’s an example:

```dart
var names = List<String>();
names.addAll(['Seth', 'Kathy', 'Lars']);
names.add(42); // Error
```

Another reason for using generics is to reduce code duplication. Generics let you share a single interface and implementation between many types, while still taking advantage of static analysis. For example, say you create an interface for caching an object:

```dart
abstract class ObjectCache {
  Object getByKey(String key);
  void setByKey(String key, Object value);
}
```

You discover that you want a string-specific version of this interface, so you create another interface:

```dart
abstract class StringCache {
  String getByKey(String key);
  void setByKey(String key, String value);
}
```

Later, you decide you want a number-specific version of this interface… You get the idea.

Generic types can save you the trouble of creating all these interfaces. Instead, you can create a single interface that takes a type parameter:

```dart
abstract class Cache<T> {
  T getByKey(String key);
  void setByKey(String key, T value);
}
```

In this code, T is the stand-in type. It’s a placeholder that you can think of as a type that a developer will define later.

> 使用泛型有两个好处：
>
> 1. 规定了参数类型，比如List<String>，传入num会报错
> 2. 代码复用

### Using collection literals

List, set, and map literals can be parameterized. Parameterized literals are just like the literals you’ve already seen, except that you add `<type>` (for lists and sets) or `<keyType, valueType>` (for maps) before the opening bracket. Here is an example of using typed literals:

```dart
var names = <String>['Seth', 'Kathy', 'Lars'];
var uniqueNames = <String>{'Seth', 'Kathy', 'Lars'};
var pages = <String, String>{
  'index.html': 'Homepage',
  'robots.txt': 'Hints for web robots',
  'humans.txt': 'We are people, not machines'
};
```

> 列举了三种常用数据结构的泛型定义方式
>

### Using parameterized types with constructors

To specify one or more types when using a constructor, put the types in angle brackets (`<...>`) just after the class name. For example:

```dart
var nameSet = Set<String>.from(names);
```

The following code creates a map that has integer keys and values of type View:

```dart
var views = Map<int, View>();
```

### Generic collections and the types they contain

Dart generic types are *reified*, which means that they carry their type information around at runtime. For example, you can test the type of a collection:

```dart
var names = List<String>();
names.addAll(['Seth', 'Kathy', 'Lars']);
print(names is List<String>); // true
```

 **Note:** In contrast, generics in Java use *erasure*, which means that generic type parameters are removed at runtime. In Java, you can test whether an object is a List, but you can’t test whether it’s a `List`.

### Restricting the parameterized type

When implementing a generic type, you might want to limit the types of its parameters. You can do this using `extends`.

```dart
class Foo<T extends SomeBaseClass> {
  // Implementation goes here...
  String toString() => "Instance of 'Foo<$T>'";
}

class Extender extends SomeBaseClass {...}
```

It’s OK to use `SomeBaseClass` or any of its subclasses as generic argument:

```dart
var someBaseClassFoo = Foo<SomeBaseClass>();
var extenderFoo = Foo<Extender>();
```

It’s also OK to specify no generic argument:

```dart
var foo = Foo();
print(foo); // Instance of 'Foo<SomeBaseClass>'
```

Specifying any non-`SomeBaseClass` type results in an error:

```dart
var foo = Foo<Object>();
```

### Using generic methods

Initially, Dart’s generic support was limited to classes. A newer syntax, called *generic methods*, allows type arguments on methods and functions:

```dart
T first<T>(List<T> ts) {
  // Do some initial work or error checking, then...
  T tmp = ts[0];
  // Do some additional checking or processing...
  return tmp;
}
```

Here the generic type parameter on `first` (``) allows you to use the type argument `T` in several places:

- In the function’s return type (`T`).
- In the type of an argument (`List`).
- In the type of a local variable (`T tmp`).

For more information about generics, see [Using Generic Methods.](https://github.com/dart-lang/sdk/blob/master/pkg/dev_compiler/doc/GENERIC_METHODS.md)



## Libraries and visibility

The `import` and `library` directives can help you create a modular and shareable code base. Libraries not only provide APIs, but are a unit of privacy: identifiers that start with an underscore (_) are visible only inside the library. *Every Dart app is a library*, even if it doesn’t use a `library` directive.

Libraries can be distributed using [packages](https://dart.dev/guides/packages).

### Using libraries

Use `import` to specify how a namespace from one library is used in the scope of another library.

For example, Dart web apps generally use the [dart:html](https://api.dart.dev/stable/dart-html) library, which they can import like this:

```dart
import 'dart:html';
```

The only required argument to `import` is a URI specifying the library. For built-in libraries, the URI has the special `dart:` scheme. For other libraries, you can use a file system path or the `package:` scheme. The `package:` scheme specifies libraries provided by a package manager such as the pub tool. For example:

```dart
import 'package:test/test.dart';
```

 **Note:** *URI* stands for uniform resource identifier. *URLs* (uniform resource locators) are a common kind of URI.

> Dart官方库使用dart作为URI的specific
>
> 自定义库使用package作为URI的specific，后面跟文件路径

#### Specifying a library prefix

If you import two libraries that have conflicting identifiers, then you can specify a prefix for one or both libraries. For example, if library1 and library2 both have an Element class, then you might have code like this:

```dart
import 'package:lib1/lib1.dart';
import 'package:lib2/lib2.dart' as lib2;

// Uses Element from lib1.
Element element1 = Element();

// Uses Element from lib2.
lib2.Element element2 = lib2.Element();
```

#### Importing only part of a library

If you want to use only part of a library, you can selectively import the library. For example:

```dart
// Import only foo.
import 'package:lib1/lib1.dart' show foo;

// Import all names EXCEPT foo.
import 'package:lib2/lib2.dart' hide foo;
```

#### Lazily loading a library

*Deferred loading* (also called *lazy loading*) allows a web app to load a library on demand, if and when the library is needed. Here are some cases when you might use deferred loading:

- To reduce a web app’s initial startup time.
- To perform A/B testing—trying out alternative implementations of an algorithm, for example.
- To load rarely used functionality, such as optional screens and dialogs.

 **Only dart2js supports deferred loading.** Flutter, the Dart VM, and dartdevc don’t support deferred loading. For more information, see [issue #33118](https://github.com/dart-lang/sdk/issues/33118) and [issue #27776.](https://github.com/dart-lang/sdk/issues/27776)

To lazily load a library, you must first import it using `deferred as`.

```dart
import 'package:greetings/hello.dart' deferred as hello;
```

When you need the library, invoke `loadLibrary()` using the library’s identifier.

```dart
Future greet() async {
  await hello.loadLibrary();
  hello.printGreeting();
}
```

In the preceding code, the `await` keyword pauses execution until the library is loaded. For more information about `async` and `await`, see [asynchrony support](https://dart.dev/guides/language/language-tour#asynchrony-support).

You can invoke `loadLibrary()` multiple times on a library without problems. The library is loaded only once.

Keep in mind the following when you use deferred loading:

- A deferred library’s constants aren’t constants in the importing file. Remember, these constants don’t exist until the deferred library is loaded.
- You can’t use types from a deferred library in the importing file. Instead, consider moving interface types to a library imported by both the deferred library and the importing file.
- Dart implicitly inserts `loadLibrary()` into the namespace that you define using `deferred as namespace`. The `loadLibrary()` function returns a [Future](https://dart.dev/guides/libraries/library-tour#future).

> 只有dart2js支持defferred load！

### Implementing libraries

See [Create Library Packages](https://dart.dev/guides/libraries/create-library-packages) for advice on how to implement a library package, including:

- How to organize library source code.
- How to use the `export` directive.
- When to use the `part` directive.
- When to use the `library` directive.
- How to use conditional imports and exports to implement a library that supports multiple platforms.

> 如何实现一个库？
>
> 内容比较多，需要另行展开



## Asynchrony support

Dart libraries are full of functions that return [Future](https://api.dart.dev/stable/dart-async/Future-class.html) or [Stream](https://api.dart.dev/stable/dart-async/Stream-class.html) objects. These functions are *asynchronous*: they return after setting up a possibly time-consuming operation (such as I/O), without waiting for that operation to complete.

The `async` and `await` keywords support asynchronous programming, letting you write asynchronous code that looks similar to synchronous code.



### Handling Futures

When you need the result of a completed Future, you have two options:

- Use `async` and `await`.
- Use the Future API, as described [in the library tour](https://dart.dev/guides/libraries/library-tour#future).

Code that uses `async` and `await` is asynchronous, but it looks a lot like synchronous code. For example, here’s some code that uses `await` to wait for the result of an asynchronous function:

```dart
await lookUpVersion();
```

To use `await`, code must be in an `async` function—a function marked as `async`:

```dart
Future checkVersion() async {
  var version = await lookUpVersion();
  // Do something with version
}
```

 **Note:** Although an `async` function might perform time-consuming operations, it doesn’t wait for those operations. Instead, the `async` function executes only until it encounters its first `await` expression ([details](https://github.com/dart-lang/sdk/blob/master/docs/newsletter/20170915.md#synchronous-async-start)). Then it returns a Future object, resuming execution only after the `await` expression completes.

Use `try`, `catch`, and `finally` to handle errors and cleanup in code that uses `await`:

```dart
try {
  version = await lookUpVersion();
} catch (e) {
  // React to inability to look up the version
}
```

You can use `await` multiple times in an `async` function. For example, the following code waits three times for the results of functions:

```dart
var entrypoint = await findEntrypoint();
var exitCode = await runExecutable(entrypoint, args);
await flushThenExit(exitCode);
```

In `await *expression*`, the value of `*expression*` is usually a Future; if it isn’t, then the value is automatically wrapped in a Future. This Future object indicates a promise to return an object. The value of `await *expression*` is that returned object. The await expression makes execution pause until that object is available.

**If you get a compile-time error when using `await`, make sure `await` is in an `async` function.** For example, to use `await` in your app’s `main()` function, the body of `main()` must be marked as `async`:

```dart
Future main() async {
  checkVersion();
  print('In main: version is ${await lookUpVersion()}');
}
```



### Declaring async functions

An `async` function is a function whose body is marked with the `async` modifier.

Adding the `async` keyword to a function makes it return a Future. For example, consider this synchronous function, which returns a String:

```dart
String lookUpVersion() => '1.0.0';
```

If you change it to be an `async` function—for example, because a future implementation will be time consuming—the returned value is a Future:

```dart
Future<String> lookUpVersion() async => '1.0.0';
```

Note that the function’s body doesn’t need to use the Future API. Dart creates the Future object if necessary. If your function doesn’t return a useful value, make its return type `Future`.

For an interactive introduction to using futures, `async`, and `await`, see the [asynchronous programming codelab](https://dart.dev/codelabs/async-await).



### Handling Streams

When you need to get values from a Stream, you have two options:

- Use `async` and an *asynchronous for loop* (`await for`).
- Use the Stream API, as described [in the library tour](https://dart.dev/guides/libraries/library-tour#stream).

 **Note:** Before using `await for`, be sure that it makes the code clearer and that you really do want to wait for all of the stream’s results. For example, you usually should **not** use `await for` for UI event listeners, because UI frameworks send endless streams of events.

An asynchronous for loop has the following form:

```dart
await for (varOrType identifier in expression) {
  // Executes each time the stream emits a value.
}
```

The value of `expression` must have type Stream. Execution proceeds as follows:

1. Wait until the stream emits a value.
2. Execute the body of the for loop, with the variable set to that emitted value.
3. Repeat 1 and 2 until the stream is closed.

To stop listening to the stream, you can use a `break` or `return` statement, which breaks out of the for loop and unsubscribes from the stream.

**If you get a compile-time error when implementing an asynchronous for loop, make sure the `await for` is in an `async` function.** For example, to use an asynchronous for loop in your app’s `main()` function, the body of `main()` must be marked as `async`:

```dart
Future main() async {
  // ...
  await for (var request in requestServer) {
    handleRequest(request);
  }
  // ...
}
```

For more information about asynchronous programming, in general, see the [dart:async](https://dart.dev/guides/libraries/library-tour#dartasync---asynchronous-programming) section of the library tour.

> 使用await for，必须等待一个Stream对象来产生值



## Generators

When you need to lazily produce a sequence of values, consider using a *generator function*. Dart has built-in support for two kinds of generator functions:

- **Synchronous** generator: Returns an **[Iterable](https://api.dart.dev/stable/dart-core/Iterable-class.html)** object.
- **Asynchronous** generator: Returns a **[Stream](https://api.dart.dev/stable/dart-async/Stream-class.html)** object.

To implement a **synchronous** generator function, mark the function body as `sync*`, and use `yield` statements to deliver values:

```dart
Iterable<int> naturalsTo(int n) sync* {
  int k = 0;
  while (k < n) yield k++;
}
```

To implement an **asynchronous** generator function, mark the function body as `async*`, and use `yield` statements to deliver values:

```dart
Stream<int> asynchronousNaturalsTo(int n) async* {
  int k = 0;
  while (k < n) yield k++;
}
```

If your generator is recursive, you can improve its performance by using `yield*`:

```dart
Iterable<int> naturalsDownFrom(int n) sync* {
  if (n > 0) {
    yield n;
    yield* naturalsDownFrom(n - 1);
  }
}
```

> 写法可以死记硬背，关键是背后的原理难理解
>
> yield关键字是怎么执行的？为什么同步、异步都用它？
>
> 为什么yield*能提升性能？
>
> 满脑子是问号呀！



## Callable classes

To allow an instance of your Dart class to be called like a function, implement the `call()` method.

In the following example, the `WannabeFunction` class defines a call() function that takes three strings and concatenates them, separating each with a space, and appending an exclamation. Click **Run** to execute the code.

<iframe src="https://dartpad.dev/embed-inline.html?id=3723fcf3915ca935d13393b8a9f86fd5&amp;ga_id=callable_classes" width="100%" height="350px" data-gtm-vis-first-on-screen-13029053_11="455060658" data-gtm-vis-total-visible-time-13029053_11="100" data-gtm-vis-has-fired-13029053_11="1" style="box-sizing: border-box; color: rgb(33, 37, 41); font-family: Roboto, sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 300; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: rgb(255, 255, 255); text-decoration-style: initial; text-decoration-color: initial; border: 1px solid rgb(204, 204, 204);"></iframe>

> 确实很灵活，但不是已经有类似函数指针的用法了吗？
>
> 感觉这个没必要吧，可能还没有理解到精髓



## Isolates

Most computers, even on mobile platforms, have multi-core CPUs. To take advantage of all those cores, developers traditionally use shared-memory threads running concurrently. However, shared-state concurrency is error prone and can lead to complicated code.

Instead of threads, all Dart code runs inside of *isolates*. Each isolate has its own memory heap, ensuring that no isolate’s state is accessible from any other isolate.

For more information, see the following:

- [Dart asynchronous programming: Isolates and event loops](https://medium.com/dartlang/dart-asynchronous-programming-isolates-and-event-loops-bffc3e296a6a)
- [dart:isolate API reference,](https://api.dart.dev/stable/dart-isolate) including [Isolate.spawn()](https://api.dart.dev/stable/dart-isolate/Isolate/spawn.html) and [TransferableTypedData](https://api.dart.dev/stable/dart-isolate/TransferableTypedData-class.html)
- [Background parsing](https://flutter.dev/docs/cookbook/networking/background-parsing) cookbook on the Flutter site
- [Isolate sample app](https://github.com/flutter/samples/tree/master/isolate_example)

> 多线程，重点知识，需要展开
>



## Typedefs

In Dart, functions are objects, just like strings and numbers are objects. A *typedef*, or *function-type alias*, gives a function type a name that you can use when declaring fields and return types. A typedef retains type information when a function type is assigned to a variable.

Consider the following code, which doesn’t use a typedef:

```dart
class SortedCollection {
  Function compare;

  SortedCollection(int f(Object a, Object b)) {
    compare = f;
  }
}

// Initial, broken implementation.
int sort(Object a, Object b) => 0;

void main() {
  SortedCollection coll = SortedCollection(sort);

  // All we know is that compare is a function,
  // but what type of function?
  assert(coll.compare is Function);
}
```

Type information is lost when assigning `f` to `compare`. The type of `f` is `(Object, ``Object)` → `int` (where → means returns), yet the type of `compare` is Function. If we change the code to use explicit names and retain type information, both developers and tools can use that information.

```dart
typedef Compare = int Function(Object a, Object b);

class SortedCollection {
  Compare compare;

  SortedCollection(this.compare);
}

// Initial, broken implementation.
int sort(Object a, Object b) => 0;

void main() {
  SortedCollection coll = SortedCollection(sort);
  assert(coll.compare is Function);
  assert(coll.compare is Compare);
}
```

 **Note:** Currently, typedefs are restricted to function types. We expect this to change.

Because typedefs are simply aliases, they offer a way to check the type of any function. For example:

```dart
typedef Compare<T> = int Function(T a, T b);

int sort(int a, int b) => a - b;

void main() {
  assert(sort is Compare<int>); // True!
}
```

> 有点吃力，感觉用起来很复杂，还没想明白什么时候使用
>

## Metadata

Use metadata to give additional information about your code. A metadata annotation begins with the character `@`, followed by either a reference to a compile-time constant (such as `deprecated`) or a call to a constant constructor.

Two annotations are available to all Dart code: `@deprecated` and `@override`. For examples of using `@override`, see [Extending a class](https://dart.dev/guides/language/language-tour#extending-a-class). Here’s an example of using the `@deprecated` annotation:

```dart
class Television {
  /// _Deprecated: Use [turnOn] instead._
  @deprecated
  void activate() {
    turnOn();
  }

  /// Turns the TV's power on.
  void turnOn() {...}
}
```

You can define your own metadata annotations. Here’s an example of defining a @todo annotation that takes two arguments:

```dart
library todo;

class Todo {
  final String who;
  final String what;

  const Todo(this.who, this.what);
}
```

And here’s an example of using that @todo annotation:

```dart
import 'todo.dart';

@Todo('seth', 'make this do something')
void doSomething() {
  print('do something');
}
```

Metadata can appear before a library, class, typedef, type parameter, constructor, factory, function, field, parameter, or variable declaration and before an import or export directive. You can retrieve metadata at runtime using reflection.



## Comments

Dart supports single-line comments, multi-line comments, and documentation comments.

### Single-line comments

A single-line comment begins with `//`. Everything between `//` and the end of line is ignored by the Dart compiler.

```dart
void main() {
  // TODO: refactor into an AbstractLlamaGreetingFactory?
  print('Welcome to my Llama farm!');
}
```

### Multi-line comments

A multi-line comment begins with `/*` and ends with `*/`. Everything between `/*` and `*/` is ignored by the Dart compiler (unless the comment is a documentation comment; see the next section). Multi-line comments can nest.

```dart
void main() {
  /*
   * This is a lot of work. Consider raising chickens.

  Llama larry = Llama();
  larry.feed();
  larry.exercise();
  larry.clean();
   */
}
```

### Documentation comments

Documentation comments are multi-line or single-line comments that begin with `///` or `/**`. Using `///` on consecutive lines has the same effect as a multi-line doc comment.

Inside a documentation comment, the Dart compiler ignores all text unless it is enclosed in brackets. Using brackets, you can refer to classes, methods, fields, top-level variables, functions, and parameters. The names in brackets are resolved in the lexical scope of the documented program element.

Here is an example of documentation comments with references to other classes and arguments:

```dart
/// A domesticated South American camelid (Lama glama).
///
/// Andean cultures have used llamas as meat and pack
/// animals since pre-Hispanic times.
class Llama {
  String name;

  /// Feeds your llama [Food].
  ///
  /// The typical llama eats one bale of hay per week.
  void feed(Food food) {
    // ...
  }

  /// Exercises your llama with an [activity] for
  /// [timeLimit] minutes.
  void exercise(Activity activity, int timeLimit) {
    // ...
  }
}
```

In the generated documentation, `[Food]` becomes a link to the API docs for the Food class.

To parse Dart code and generate HTML documentation, you can use the SDK’s [documentation generation tool.](https://github.com/dart-lang/dartdoc#dartdoc) For an example of generated documentation, see the [Dart API documentation.](https://api.dart.dev/stable) For advice on how to structure your comments, see [Guidelines for Dart Doc Comments.](https://dart.dev/guides/language/effective-dart/documentation)



# [A tour of the core libraries](https://dart.dev/guides/language/language-tour)

This page shows you how to use the major features in Dart’s core libraries. It’s just an overview, and by no means comprehensive. Whenever you need more details about a class, consult the [Dart API reference.](https://api.dart.dev/stable)

- [dart:core](https://dart.dev/guides/libraries/library-tour#dartcore---numbers-collections-strings-and-more)

  Built-in types, collections, and other core functionality. This library is automatically imported into every Dart program.

- [dart:async](https://dart.dev/guides/libraries/library-tour#dartasync---asynchronous-programming)

  Support for asynchronous programming, with classes such as Future and Stream.

- [dart:math](https://dart.dev/guides/libraries/library-tour#dartmath---math-and-random)

  Mathematical constants and functions, plus a random number generator.

- [dart:convert](https://dart.dev/guides/libraries/library-tour#dartconvert---decoding-and-encoding-json-utf-8-and-more)

  Encoders and decoders for converting between different data representations, including JSON and UTF-8.

- [dart:html](https://dart.dev/guides/libraries/library-tour#darthtml)

  DOM and other APIs for browser-based apps.

- [dart:io](https://dart.dev/guides/libraries/library-tour#dartio)

  I/O for programs that can use the Dart VM, including Flutter apps, servers, and command-line scripts.

This page is just an overview; it covers only a few dart:* libraries and no third-party libraries.

Other places to find library information are the [pub.dev site](https://pub.dev/) and the [Dart web developer library guide](https://dart.dev/web/libraries). You can find API documentation for all dart:* libraries in the [Dart API reference](https://api.dart.dev/stable) or, if you’re using Flutter, the [Flutter API reference.](https://api.flutter.dev/)

 **DartPad tip:** You can play with the code in this page by copying it into a [DartPad.](https://dartpad.dev/)

> DartPad是一个线上编辑工具。
>

## dart:core - numbers, collections, strings, and more

The dart:core library ([API reference](https://api.dart.dev/stable/dart-core/dart-core-library.html)) provides a small but critical set of built-in functionality. This library is automatically imported into every Dart program.

> 默认自带的内置包

### Printing to the console

The top-level `print()` method takes a single argument (any Object) and displays that object’s string value (as returned by `toString()`) in the console.

```dart
print(anObject);
print('I drink $tea.');
```

For more information on basic strings and `toString()`, see [Strings](https://dart.dev/guides/language/language-tour#strings) in the language tour.

### Numbers

The dart:core library defines the num, int, and double classes, which have some basic utilities for working with numbers.

You can convert a string into an integer or double with the `parse()` methods of int and double, respectively:

```dart
assert(int.parse('42') == 42);
assert(int.parse('0x42') == 66);
assert(double.parse('0.50') == 0.5);
```

Or use the parse() method of num, which creates an integer if possible and otherwise a double:

```dart
assert(num.parse('42') is int);
assert(num.parse('0x42') is int);
assert(num.parse('0.50') is double);
```

To specify the base of an integer, add a `radix` parameter:

```dart
assert(int.parse('42', radix: 16) == 66);
```

Use the `toString()` method to convert an int or double to a string. To specify the number of digits to the right of the decimal, use [toStringAsFixed().](https://api.dart.dev/stable/dart-core/num/toStringAsFixed.html) To specify the number of significant digits in the string, use [toStringAsPrecision():](https://api.dart.dev/stable/dart-core/num/toStringAsPrecision.html)

```dart
// Convert an int to a string.
assert(42.toString() == '42');

// Convert a double to a string.
assert(123.456.toString() == '123.456');

// Specify the number of digits after the decimal.
assert(123.456.toStringAsFixed(2) == '123.46');

// Specify the number of significant figures.
assert(123.456.toStringAsPrecision(2) == '1.2e+2');
assert(double.parse('1.2e+2') == 120.0);
```

For more information, see the API documentation for [int,](https://api.dart.dev/stable/dart-core/int-class.html) [double,](https://api.dart.dev/stable/dart-core/double-class.html) and [num.](https://api.dart.dev/stable/dart-core/num-class.html) Also see the [dart:math section](https://dart.dev/guides/libraries/library-tour#dartmath---math-and-random).

### Strings and regular expressions

A string in Dart is an immutable sequence of UTF-16 code units. The language tour has more information about [strings](https://dart.dev/guides/language/language-tour#strings). You can use regular expressions (RegExp objects) to search within strings and to replace parts of strings.

The String class defines such methods as `split()`, `contains()`, `startsWith()`, `endsWith()`, and more.

#### Searching inside a string

You can find particular locations within a string, as well as check whether a string begins with or ends with a particular pattern. For example:

```dart
// Check whether a string contains another string.
assert('Never odd or even'.contains('odd'));

// Does a string start with another string?
assert('Never odd or even'.startsWith('Never'));

// Does a string end with another string?
assert('Never odd or even'.endsWith('even'));

// Find the location of a string inside a string.
assert('Never odd or even'.indexOf('odd') == 6);
```

#### Extracting data from a string

You can get the individual characters from a string as Strings or ints, respectively. To be precise, you actually get individual UTF-16 code units; high-numbered characters such as the treble clef symbol (‘\u{1D11E}’) are two code units apiece.

You can also extract a substring or split a string into a list of substrings:

```dart
// Grab a substring.
assert('Never odd or even'.substring(6, 9) == 'odd');

// Split a string using a string pattern.
var parts = 'structured web apps'.split(' ');
assert(parts.length == 3);
assert(parts[0] == 'structured');

// Get a UTF-16 code unit (as a string) by index.
assert('Never odd or even'[0] == 'N');

// Use split() with an empty string parameter to get
// a list of all characters (as Strings); good for
// iterating.
for (var char in 'hello'.split('')) {
  print(char);
}

// Get all the UTF-16 code units in the string.
var codeUnitList =
    'Never odd or even'.codeUnits.toList();
assert(codeUnitList[0] == 78);
```

#### Converting to uppercase or lowercase

You can easily convert strings to their uppercase and lowercase variants:

```dart
// Convert to uppercase.
assert('structured web apps'.toUpperCase() ==
    'STRUCTURED WEB APPS');

// Convert to lowercase.
assert('STRUCTURED WEB APPS'.toLowerCase() ==
    'structured web apps');
```

 **Note:** These methods don’t work for every language. For example, the Turkish alphabet’s dotless *I* is converted incorrectly.

#### Trimming and empty strings

Remove all leading and trailing white space with `trim()`. To check whether a string is empty (length is zero), use `isEmpty`.

```dart
// Trim a string.
assert('  hello  '.trim() == 'hello');

// Check whether a string is empty.
assert(''.isEmpty);

// Strings with only white space are not empty.
assert('  '.isNotEmpty);
```

#### Replacing part of a string

Strings are immutable objects, which means you can create them but you can’t change them. If you look closely at the [String API reference,](https://api.dart.dev/stable/dart-core/String-class.html) you’ll notice that none of the methods actually changes the state of a String. For example, the method `replaceAll()` returns a new String without changing the original String:

```dart
var greetingTemplate = 'Hello, NAME!';
var greeting =
    greetingTemplate.replaceAll(RegExp('NAME'), 'Bob');

// greetingTemplate didn't change.
assert(greeting != greetingTemplate);
```

























































































































































































































































# References

- [官方网站](https://dart.dev/guides/language)

