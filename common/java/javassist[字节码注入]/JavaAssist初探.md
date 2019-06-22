# JavaAssist初探

[TOC]

## 1. Reading and writing bytecode

Javassist is a class library for dealing with Java bytecode.

The class `Javassist.CtClass` is an abstract representation of a class file.

The following program is a very simple example:

```java
ClassPool pool = ClassPool.getDefault();
CtClass cc = pool.get("test.Rectangle");
cc.setSuperclass(pool.get("test.Point"));
cc.writeFile();
```

In the case of the program shown above, the `CtClass` object representing a class `test.Rectangle` is obtained from the `ClassPool` object and it is assigned to a variable `cc`. The `ClassPool` object returned by `getDefault()` searches the default system search path. `writeFile()` translates the `CtClass` object into a class file and writes it on a local disk.

Javassist also provides a method for directly obtaining the modified bytecode. To obtain the bytecode, call `toBytecode()`:

```java
byte[] b = cc.toBytecode();
```

You can directly load the `CtClass` as well:

```java
Class clazz = cc.toClass();
```

`toClass()` requests the context class loader for the current thread to load the class file represented by the `CtClass`. It returns a `java.lang.Class` object representing the loaded class.

### Defining a new class

To define a new class from scratch, `makeClass()` must be called on a `ClassPool`.

```java
ClassPool pool = ClassPool.getDefault();
CtClass cc = pool.makeClass("Point");
```

This program defines a class `Point` including no members. Member methods of `Point` can be created with factory methods declared in `CtNewMethod` and appended to `Point` with `addMethod()` in `CtClass`.

`makeClass()` cannot create a new interface; `makeInterface()` in `ClassPool` can do. Member methods in an interface can be created with `abstractMethod()` in `CtNewMethod`. Note that an interface method is an abstract method.

### Frozen classes

If a `CtClass` object is converted into a class file by `writeFile()`, `toClass()`, or `toBytecode()`, Javassist freezes that `CtClass` object. Further modifications of that `CtClass` object are not permitted. 

A frozen `CtClass` can be defrost so that modifications of the class definition will be permitted. For example,

```java
CtClasss cc = ...;
    :
cc.writeFile();
cc.defrost();
cc.setSuperclass(...);    // OK since the class is not frozen.
```

After `defrost()` is called, the `CtClass` object can be modified again.

### Class search path

The default `ClassPool` returned by a static method `ClassPool.getDefault()` searches the same path that the underlying JVM (Java virtual machine) has.

You can register a directory name as the class search path. For example, the following code adds a directory `/usr/local/javalib` to the search path:

```java
ClassPool pool = ClassPool.getDefault();
pool.insertClassPath("/usr/local/javalib");
```

Furthermore, you can directly give a byte array to a `ClassPool` object and construct a `CtClass` object from that array. To do this, use `ByteArrayClassPath`. For example,

```java
ClassPool cp = ClassPool.getDefault();
byte[] b = a byte array;
String name = class name;
cp.insertClassPath(new ByteArrayClassPath(name, b));
CtClass cc = cp.get(name);
```

If you do not know the fully-qualified name of the class, then you can use `makeClass()` in `ClassPool`:

```java
ClassPool cp = ClassPool.getDefault();
InputStream ins = an input stream for reading a class file;
CtClass cc = cp.makeClass(ins);
```

## 2. ClassPool

A `ClassPool` object is a container of `CtClass` objects. Once a `CtClass` object is created, it is recorded in a `ClassPool` for ever. This is because a compiler may need to access the `CtClass` object later when it compiles source code that refers to the class represented by that `CtClass`.

### Avoid out of memory

This specification of `ClassPool` may cause huge memory consumption if the number of `CtClass` objects becomes amazingly large.

To avoid this problem, you can explicitly remove an unnecessary `CtClass` object from the `ClassPool`. If you call `detach()` on a `CtClass` object, then that `CtClass` object is removed from the `ClassPool`. For example,

```java
CtClass cc = ... ;
cc.writeFile();
cc.detach();
```

You must not call any method on that `CtClass` object after `detach()` is called.

Another idea is to occasionally replace a `ClassPool` with a new one and discard the old one. If an old `ClassPool` is garbage collected, the `CtClass` objects included in that `ClassPool` are also garbage collected. To create a new instance of `ClassPool`, execute the following code snippet:

```java
ClassPool cp = new ClassPool(true);
// if needed, append an extra search path by appendClassPath()
```

Note that `new ClassPool(true)` is a convenient constructor, which constructs a `ClassPool` object and appends the system search path to it. Calling that constructor is equivalent to the following code:

```java
ClassPool cp = new ClassPool();
cp.appendSystemPath();  // or append another path by appendClassPath()
```

### Cascaded ClassPools

Multiple `ClassPool` objects can be cascaded like `java.lang.ClassLoader`. For example,

```java
ClassPool parent = ClassPool.getDefault();
ClassPool child = new ClassPool(parent);
child.insertClassPath("./classes");
```

If `child.get()` is called, the child `ClassPool` first delegates to the parent `ClassPool`. If the parent `ClassPool` fails to find a class file, then the child `ClassPool` attempts to find a class file under the `./classes` directory.

## 3. Class loader

f what classes must be modified is known in advance, the easiest way for modifying the classes is as follows:

1. Get a `CtClass` object by calling `ClassPool.get()`,
2. Modify it, and
3. Call `writeFile()` or `toBytecode()` on that `CtClass` object to obtain a modified class file.

## 4. Introspection and customization

`CtClass` provides methods for introspection. The introspective ability of Javassist is compatible with that of the Java reflection API. `CtClass` provides `getName()`, `getSuperclass()`, `getMethods()`, and so on. `CtClass` also provides methods for modifying a class definition. It allows to add a new field, constructor, and method. Instrumenting a method body is also possible.

Methods are represented by `CtMethod` objects. `CtMethod` provides several methods for modifying the definition of the method. Note that if a method is inherited from a super class, then the same `CtMethod`object that represents the inherited method represents the method declared in that super class. A `CtMethod`object corresponds to every method declaration.

For example, if class `Point` declares method `move()` and a subclass `ColorPoint` of `Point` does not override `move()`, the two `move()` methods declared in `Point` and inherited in `ColorPoint` are represented by the identical `CtMethod`object. If the method definition represented by this `CtMethod` object is modified, the modification is reflected on both the methods. If you want to modify only the `move()` method in `ColorPoint`, you first have to add to `ColorPoint` a copy of the `CtMethod` object representing `move()` in `Point`. A copy of the the `CtMethod` object can be obtained by `CtNewMethod.copy()`.

------

Javassist does not allow to remove a method or field, but it allows to change the name. So if a method is not necessary any more, it should be renamed and changed to be a private method by calling `setName()` and `setModifiers()` declared in `CtMethod`.

Javassist does not allow to add an extra parameter to an existing method, either. Instead of doing that, a new method receiving the extra parameter as well as the other parameters should be added to the same class. For example, if you want to add an extra `int` parameter `newZ` to a method:

```java
void move(int newX, int newY) { x = newX; y = newY; }
```

in a `Point` class, then you should add the following method to the `Point` class:

```java
void move(int newX, int newY, int newZ) {
    // do what you want with newZ.
    move(newX, newY);
}
```

------

Javassist also provides low-level API for directly editing a raw class file. For example, `getClassFile()` in`CtClass` returns a `ClassFile` object representing a raw class file. `getMethodInfo()` in `CtMethod` returns a `MethodInfo`object representing a `method_info` structure included in a class file. The low-level API uses the vocabulary from the Java Virtual machine specification. The users must have the knowledge about class files and bytecode. For more details, the users should see the [`javassist.bytecode` package](http://www.javassist.org/tutorial/tutorial3.html#intro).

The class files modified by Javassist requires the `javassist.runtime` package for runtime support only if some special identifiers starting with `$` are used. Those special identifiers are described below. The class files modified without those special identifiers do not need the `javassist.runtime` package or any other Javassist packages at runtime. For more details, see the API documentation of the `javassist.runtime` package.

### 4.1 Inserting source text at the beginning/end of a method body

`CtMethod` and `CtConstructor` provide methods `insertBefore()`, `insertAfter()`, and `addCatch()`. 

The `String` object passed to the methods `insertBefore()`, `insertAfter()`, `addCatch()`, and `insertAt()` are compiled by the compiler included in Javassist. Since the compiler supports language extensions, several identifiers starting with `$` have special meaning:

-  $0, $1, $2, ...		`this` and actual parameters
-  $args				     An array of parameters. The type of `$args` is `Object[]`.
-  $$					      All actual parameters. For example, `m($$)` is equivalent to `m($1,$2,`...`)` 
-  $cflow(...)			 `cflow` variable
-  $r					      The result type. It is used in a cast expression.
-  $w					     The wrapper type. It is used in a cast expression.
-  $_					      The resulting value
-  $sig_					 An array of `java.lang.Class` objects representing the formal parameter types.
-  $type					A `java.lang.Class` object representing the formal result type.
-  $class				   A `java.lang.Class` object representing the class currently edited.

####   $0, $1, $2, ...

The parameters passed to the target method are accessible with `$1`, `$2`, ... instead of the original parameter names. `$1` represents the first parameter, `$2` represents the second parameter, and so on. The types of those variables are identical to the parameter types. `$0` is equivalent to `this`. If the method is static, `$0` is not available.

These variables are used as following. Suppose that a class `Point`:

```java
class Point {
    int x, y;
    void move(int dx, int dy) { x += dx; y += dy; }
}
```

To print the values of `dx` and `dy` whenever the method `move()` is called, execute this program:

```java
ClassPool pool = ClassPool.getDefault();
CtClass cc = pool.get("Point");
CtMethod m = cc.getDeclaredMethod("move");
m.insertBefore("{ System.out.println($1); System.out.println($2); }");
cc.writeFile();
```

Note that the source text passed to `insertBefore()` is surrounded with braces `{}`. `insertBefore()` accepts only a single statement or a block surrounded with braces.

The definition of the class `Point` after the modification is like this:

```java
class Point {
    int x, y;
    void move(int dx, int dy) {
        { System.out.println(dx); System.out.println(dy); }
        x += dx; y += dy;
    }
}
```

`$1` and `$2` are replaced with `dx` and `dy`, respectively.

`$1`, `$2`, `$3` ... are updatable. If a new value is assigend to one of those variables, then the value of the parameter represented by that variable is also updated.

#### $args

The variable `$args` represents an array of all the parameters. The type of that variable is an array of class`Object`. If a parameter type is a primitive type such as `int`, then the parameter value is converted into a wrapper object such as `java.lang.Integer` to store in `$args`. Thus, `$args[0]` is equivalent to `$1` unless the type of the first parameter is a primitive type. Note that `$args[0]` is not equivalent to `$0`; `$0` represents `this`.

If an array of `Object` is assigned to `$args`, then each element of that array is assigned to each parameter. If a parameter type is a primitive type, the type of the corresponding element must be a wrapper type. The value is converted from the wrapper type to the primitive type before it is assigned to the parameter.

#### $

The variable `$$` is abbreviation of a list of all the parameters separated by commas. For example, if the number of the parameters to method `move()` is three, then

```java
move($$)
```

is equivalent to this:

```java
move($1, $2, $3)
```

If `move()` does not take any parameters, then `move($$)` is equivalent to `move()`.

`$$` can be used with another method. If you write an expression:

```java
exMove($$, context)
```

then this expression is equivalent to:

```java
exMove($1, $2, $3, context)
```

Note that `$$` enables generic notation of method call with respect to the number of parameters. It is typically used with `$proceed` shown later.

#### $cflow

`$cflow` means "control flow". This read-only variable returns the depth of the recursive calls to a specific method.

Suppose that the method shown below is represented by a `CtMethod` object `cm`:

```java
int fact(int n) {
    if (n <= 1)
        return n;
    else
        return n * fact(n - 1);
}
```

To use `$cflow`, first declare that `$cflow` is used for monitoring calls to the method `fact()`:

```java
CtMethod cm = ...;
cm.useCflow("fact");
```

The parameter to `useCflow()` is the identifier of the declared `$cflow` variable. Any valid Java name can be used as the identifier. Since the identifier can also include `.` (dot), for example, `"my.Test.fact"` is a valid identifier.

Then, `$cflow(fact)` represents the depth of the recursive calls to the method specified by `cm`. The value of `$cflow(fact)` is 0 (zero) when the method is first called whereas it is 1 when the method is recursively called within the method. For example,

```java
cm.insertBefore("if ($cflow(fact) == 0)"
              + "    System.out.println(\"fact \" + $1);");
```

translates the method `fact()` so that it shows the parameter. Since the value of `$cflow(fact)` is checked, the method `fact()` does not show the parameter if it is recursively called within `fact()`.

The value of `$cflow` is the number of stack frames associated with the specified method `cm` under the current topmost stack frame for the current thread. `$cflow` is also accessible within a method different from the specified method `cm`.

#### $r

`$r` represents the result type (return type) of the method. It must be used as the cast type in a cast expression. For example, this is a typical use:

```java
Object result = ... ;
$_ = ($r)result;
```

If the result type is a primitive type, then `($r)` follows special semantics. First, if the operand type of the cast expression is a primitive type, `($r)` works as a normal cast operator to the result type. On the other hand, if the operand type is a wrapper type, `($r)` converts from the wrapper type to the result type. For example, if the result type is `int`, then `($r)` converts from `java.lang.Integer` to `int`.

If the result type is `void`, then `($r)` does not convert a type; it does nothing. However, if the operand is a call to a `void` method, then `($r)` results in `null`. For example, if the result type is `void` and `foo()` is a `void`method, then

```java
$_ = ($r)foo();
```

is a valid statement.

The cast operator `($r)` is also useful in a `return` statement. Even if the result type is `void`, the following `return`statement is valid:

```java
return ($r)result;
```

Here, `result` is some local variable. Since `($r)` is specified, the resulting value is discarded. This `return`statement is regarded as the equivalent of the `return` statement without a resulting value:

```java
return;
```

#### $w

`$w` represents a wrapper type. It must be used as the cast type in a cast expression. `($w)` converts from a primitive type to the corresponding wrapper type. The following code is an example:

```java
Integer i = ($w)5;
```

The selected wrapper type depends on the type of the expression following `($w)`. If the type of the expression is `double`, then the wrapper type is `java.lang.Double`.

If the type of the expression following `($w)` is not a primitive type, then `($w)` does nothing.

#### $_

`insertAfter()` in `CtMethod` and `CtConstructor` inserts the compiled code at the end of the method. In the statement given to `insertAfter()`, not only the variables shown above such as `$0`, `$1`, ... but also `$_` is available.

The variable `$_` represents the resulting value of the method. The type of that variable is the type of the result type (the return type) of the method. If the result type is `void`, then the type of `$_` is `Object` and the value of `$_` is `null`.

Although the compiled code inserted by `insertAfter()` is executed just before the control normally returns from the method, it can be also executed when an exception is thrown from the method. To execute it when an exception is thrown, the second parameter `asFinally` to `insertAfter()` must be `true`.

If an exception is thrown, the compiled code inserted by `insertAfter()` is executed as a `finally` clause. The value of `$_` is `0` or `null` in the compiled code. After the execution of the compiled code terminates, the exception originally thrown is re-thrown to the caller. Note that the value of `$_` is never thrown to the caller; it is rather discarded.

#### $sig

The value of `$sig` is an array of `java.lang.Class` objects that represent the formal parameter types in declaration order.

#### $type

The value of `$type` is an `java.lang.Class` object representing the formal type of the result value. This variable refers to `Void.class` if this is a constructor.

#### $class

The value of `$class` is an `java.lang.Class` object representing the class in which the edited method is declared. This represents the type of `$0`.

#### addCatch()

`addCatch()` inserts a code fragment into a method body so that the code fragment is executed when the method body throws an exception and the control returns to the caller. In the source text representing the inserted code fragment, the exception value is referred to with the special variable `$e`.

For example, this program:

```java
CtMethod m = ...;
CtClass etype = ClassPool.getDefault().get("java.io.IOException");
m.addCatch("{ System.out.println($e); throw $e; }", etype);
```

translates the method body represented by `m` into something like this:

```java
try {
    the original method body
}
catch (java.io.IOException e) {
    System.out.println(e);
    throw e;
}
```

Note that the inserted code fragment must end with a `throw` or `return` statement.

### 4.2 Altering a method body

`CtMethod` and `CtConstructor` provide `setBody()` for substituting a whole method body. They compile the given source text into Java bytecode and substitutes it for the original method body. If the given source text is `null`, the substituted body includes only a `return` statement, which returns zero or null unless the result type is `void`.

In the source text given to `setBody()`, the identifiers starting with `$` have special meaning

-  0, $1, $2, ...            `this` and actual parameters
-  args                         An array of parameters. The type of `$args` is `Object[]`.
-  $$                            All actual parameters.
-  cflow(...)                  `cflow` variable
-  $r                             The result type. It is used in a cast expression.
-  $w                            The wrapper type. It is used in a cast expression.
-  $sig                          An array of `java.lang.Class` objects representing the formal parameter types.
-  $type                       A `java.lang.Class` object representing the formal result type.
-  $class                      A `java.lang.Class` object representing the class that declares the method currently edited (the type of $0).

Note that `$_` is not available.

#### Substituting source text for an existing expression

Javassist allows modifying only an expression included in a method body. `javassist.expr.ExprEditor` is a class for replacing an expression in a method body. The users can define a subclass of `ExprEditor` to specify how an expression is modified.

To run an `ExprEditor` object, the users must call `instrument()` in `CtMethod` or `CtClass`. For example,

 ```java
CtMethod cm = ... ;
cm.instrument(
    new ExprEditor() {
        public void edit(MethodCall m)
                      throws CannotCompileException
        {
            if (m.getClassName().equals("Point")
                          && m.getMethodName().equals("move"))
                m.replace("{ $1 = 0; $_ = $proceed($$); }");
        }
    });
 ```

searches the method body represented by `cm` and replaces all calls to `move()` in class `Point` with a block:

 ```java
{ $1 = 0; $_ = $proceed($$); }
 ```

so that the first parameter to `move()` is always 0. Note that the substituted code is not an expression but a statement or a block. It cannot be or contain a try-catch statement.

The method `instrument()` searches a method body. If it finds an expression such as a method call, field access, and object creation, then it calls `edit()` on the given `ExprEditor` object. The parameter to `edit()` is an object representing the found expression. The `edit()` method can inspect and replace the expression through that object.

Calling `replace()` on the parameter to `edit()` substitutes the given statement or block for the expression. If the given block is an empty block, that is, if `replace("{}")` is executed, then the expression is removed from the method body. If you want to insert a statement (or a block) before/after the expression, a block like the following should be passed to `replace()`:

```java
{ before-statements;
  $_ = $proceed($$);
  after-statements; }
```

whichever the expression is either a method call, field access, object creation, or others. The second statement could be:

```java
$_ = $proceed();
```

if the expression is read access, or

```java
$proceed($$);
```

if the expression is write access.

Local variables available in the target expression is also available in the source text passed to `replace()` if the method searched by `instrument()` was compiled with the -g option (the class file includes a local variable attribute).

#### javassist.expr.MethodCall

A `MethodCall` object represents a method call. The method `replace()` in `MethodCall` substitutes a statement or a block for the method call. It receives source text representing the substitued statement or block, in which the identifiers starting with `$` have special meaning as in the source text passed to `insertBefore()`.

-  $0               The target object of the method call. This is not equivalent to `this`, which represents the caller-side `this` object. `$0` is `null` if the method is static.  
-  $1, $2, ...    The parameters of the method call.
-  $_                The resulting value of the method call.
-  $r                The result type of the method call.
-  $class         A `java.lang.Class` object representing the class declaring the method.
-  $sig            An array of `java.lang.Class` objects representing the formal parameter types.
-  $type         A `java.lang.Class` object representing the formal result type.
-  $proceed  The name of the method originally called in the expression.

Here the method call means the one represented by the `MethodCall` object.

The other identifiers such as `$w`, `$args` and `$$` are also available.

Unless the result type of the method call is `void`, a value must be assigned to `$_` in the source text and the type of `$_` is the result type. If the result type is `void`, the type of `$_` is `Object` and the value assigned to `$_` is ignored.

`$proceed` is not a `String` value but special syntax. It must be followed by an argument list surrounded by parentheses `( )`.

#### javassist.expr.ConstructorCall

A `ConstructorCall` object represents a constructor call such as `this()` and `super` included in a constructor body. The method `replace()` in `ConstructorCall` substitutes a statement or a block for the constructor call. It receives source text representing the substituted statement or block, in which the identifiers starting with `$` have special meaning as in the source text passed to `insertBefore()`.

-  $0               The target object of the constructor call. This is equivalent to `this`.
-  $1, $2, ...    The parameters of the constructor call.
-  $class         A `java.lang.Class` object representing the class declaring the constructor.
-  $sig             An array of `java.lang.Class` objects representing the formal parameter types.
-  $proceed    The name of the constructor originally called in the expression.

Here the constructor call means the one represented by the `ConstructorCall` object.

The other identifiers such as `$w`, `$args` and `$$` are also available.

Since any constructor must call either a constructor of the super class or another constructor of the same class, the substituted statement must include a constructor call, normally a call to `$proceed()`.

`$proceed` is not a `String` value but special syntax. It must be followed by an argument list surrounded by parentheses `( )`.

#### javassist.expr.FieldAccess

A `FieldAccess` object represents field access. The method `edit()` in `ExprEditor` receives this object if field access is found. The method `replace()` in `FieldAccess` receives source text representing the substitued statement or block for the field access.

In the source text, the identifiers starting with `$` have special meaning:

-  $0              The object containing the field accessed by the expression. This is not equivalent to `this`. `this` represents the object that the method including the expression is invoked on. `$0` is `null` if the field is static.
-  $1              The value that would be stored in the field if the expression is write access. Otherwise, `$1` is not available. 
-  $_               The resulting value of the field access if the expression is read access. Otherwise, the value stored in `$_` is discarded. 
-  $r                The type of the field if the expression is read access. Otherwise, `$r` is `void`. 
-  $class          A `java.lang.Class` object representing the class declaring the field.
-  $type           A `java.lang.Class` object representing the field type.
-  $proceed    The name of a virtual method executing the original field access. .

The other identifiers such as `$w`, `$args` and `$$` are also available.

If the expression is read access, a value must be assigned to `$_` in the source text. The type of `$_` is the type of the field.

#### javassist.expr.NewExpr

A `NewExpr` object represents object creation with the `new` operator (not including array creation). The method `edit()` in `ExprEditor` receives this object if object creation is found. The method `replace()` in `NewExpr`receives source text representing the substitued statement or block for the object creation.

In the source text, the identifiers starting with `$` have special meaning:

-  $0             `null`.
-  $1, $2, ...     The parameters to the constructor.
-  $_               The resulting value of the object creation. A newly created object must be stored in this variable. 
-  $r               The type of the created object.
-  $sig            An array of `java.lang.Class` objects representing the formal parameter types.
-  $type          A `java.lang.Class` object representing the class of the created object.
-  $proceed    The name of a virtual method executing the original object creation.

The other identifiers such as `$w`, `$args` and `$$` are also available.

#### javassist.expr.NewArray

A `NewArray` object represents array creation with the `new` operator. The method `edit()` in `ExprEditor` receives this object if array creation is found. The method `replace()` in `NewArray` receives source text representing the substitued statement or block for the array creation.

In the source text, the identifiers starting with `$` have special meaning:

- $0               `null`.
- $1, $2, ...    The size of each dimension.
- $_                The resulting value of the array creation. A newly created array must be stored in this variable. 
- $r                The type of the created array.
- $type          A `java.lang.Class` object representing the class of the created array.
- $proceed    The name of a virtual method executing the original array creation.

The other identifiers such as `$w`, `$args` and `$$` are also available.

For example, if the array creation is the following expression,

```java
String[][] s = new String[3][4];
```

then the value of $1 and $2 are 3 and 4, respectively. $3 is not available.

If the array creation is the following expression,

```java
String[][] s = new String[3][];
```

then the value of $1 is 3 but $2 is not available.

#### javassist.expr.Instanceof

A `Instanceof` object represents an `instanceof` expression. The method `edit()` in `ExprEditor` receives this object if an instanceof expression is found. The method `replace()` in `Instanceof` receives source text representing the substitued statement or block for the expression.

In the source text, the identifiers starting with `$` have special meaning:

| `$0`       | `null`.                                                      |
| ---------- | ------------------------------------------------------------ |
| `$1`       | The value on the left hand side of the original `instanceof` operator. |
| `$_`       | The resulting value of the expression. The type of `$_` is `boolean`. |
| `$r`       | The type on the right hand side of the `instanceof` operator. |
| `$type`    | A `java.lang.Class` object representing the type on the right hand side of the `instanceof`operator. |
| `$proceed` | The name of a virtual method executing the original `instanceof` expression.  It takes one parameter (the type is `java.lang.Object`) and returns true  if the parameter value is an instance of the type on the right hand side of  the original `instanceof` operator. Otherwise, it returns false. |

The other identifiers such as `$w`, `$args` and `$$` are also available.

#### javassist.expr.Cast

A `Cast` object represents an expression for explicit type casting. The method `edit()` in `ExprEditor` receives this object if explicit type casting is found. The method `replace()` in `Cast` receives source text representing the substitued statement or block for the expression.

In the source text, the identifiers starting with `$` have special meaning:

| `$0`       | `null`.                                                      |
| ---------- | ------------------------------------------------------------ |
| `$1`       | The value the type of which is explicitly cast.              |
| `$_`       | The resulting value of the expression. The type of `$_` is the same as the type  after the explicit casting, that is, the type surrounded by `( )`. |
|            |                                                              |
| `$r`       | the type after the explicit casting, or the type surrounded by `( )`. |
| `$type`    | A `java.lang.Class` object representing the same type as `$r`. |
| `$proceed` | The name of a virtual method executing the original type casting.  It takes one parameter of the type `java.lang.Object` and returns it after  the explicit type casting specified by the original expression. |

The other identifiers such as `$w`, `$args` and `$$` are also available.

#### javassist.expr.Handler

A `Handler` object represents a `catch` clause of `try-catch` statement. The method `edit()` in `ExprEditor` receives this object if a `catch` is found. The method `insertBefore()` in `Handler` compiles the received source text and inserts it at the beginning of the `catch` clause.

In the source text, the identifiers starting with `$` have meaning:

| `$1`    | The exception object caught by the `catch` clause.           |
| ------- | ------------------------------------------------------------ |
| `$r`    | the type of the exception caught by the `catch` clause. It is used in a cast expression. |
| `$w`    | The wrapper type. It is used in a cast expression.           |
| `$type` | A `java.lang.Class` object representing  the type of the exception caught by the `catch` clause. |

If a new exception object is assigned to `$1`, it is passed to the original `catch` clause as the caught exception.

### 4.3 Adding a new method or field

#### Adding a method

Javassist allows the users to create a new method and constructor from scratch. `CtNewMethod` and `CtNewConstructor` provide several factory methods, which are static methods for creating `CtMethod` or`CtConstructor` objects. Especially, `make()` creates a `CtMethod` or `CtConstructor` object from the given source text.

For example, this program:

```java
CtClass point = ClassPool.getDefault().get("Point");
CtMethod m = CtNewMethod.make(
                 "public int xmove(int dx) { x += dx; }",
                 point);
point.addMethod(m);
```

adds a public method `xmove()` to class `Point`. In this example, `x` is a `int` field in the class `Point`.

The source text passed to `make()` can include the identifiers starting with `$` except `$_` as in `setBody()`. It can also include `$proceed` if the target object and the target method name are also given to `make()`. For example,

```java
CtClass point = ClassPool.getDefault().get("Point");
CtMethod m = CtNewMethod.make(
                 "public int ymove(int dy) { $proceed(0, dy); }",
                 point, "this", "move");
```

this program creates a method `ymove()` defined below:

```java
public int ymove(int dy) { this.move(0, dy); }
```

Note that `$proceed` has been replaced with `this.move`.

Javassist provides another way to add a new method. You can first create an abstract method and later give it a method body:

```java
CtClass cc = ... ;
CtMethod m = new CtMethod(CtClass.intType, "move",
                          new CtClass[] { CtClass.intType }, cc);
cc.addMethod(m);
m.setBody("{ x += $1; }");
cc.setModifiers(cc.getModifiers() & ~Modifier.ABSTRACT);
```

Since Javassist makes a class abstract if an abstract method is added to the class, you have to explicitly change the class back to a non-abstract one after calling `setBody()`.  

#### Mutual recursive methods

Javassist cannot compile a method if it calls another method that has not been added to a class. (Javassist can compile a method that calls itself recursively.) To add mutual recursive methods to a class, you need a trick shown below. Suppose that you want to add methods `m()` and `n()` to a class represented by `cc`:

```java
CtClass cc = ... ;
CtMethod m = CtNewMethod.make("public abstract int m(int i);", cc);
CtMethod n = CtNewMethod.make("public abstract int n(int i);", cc);
cc.addMethod(m);
cc.addMethod(n);
m.setBody("{ return ($1 <= 0) ? 1 : (n($1 - 1) * $1); }");
n.setBody("{ return m($1); }");
cc.setModifiers(cc.getModifiers() & ~Modifier.ABSTRACT);
```

You must first make two abstract methods and add them to the class. Then you can give the method bodies to these methods even if the method bodies include method calls to each other. Finally you must change the class to a not-abstract class since `addMethod()` automatically changes a class into an abstract one if an abstract method is added.

#### Adding a field

Javassist also allows the users to create a new field.

```java
CtClass point = ClassPool.getDefault().get("Point");
CtField f = new CtField(CtClass.intType, "z", point);
point.addField(f);
```

This program adds a field named `z` to class `Point`.

If the initial value of the added field must be specified, the program shown above must be modified into:

```java
CtClass point = ClassPool.getDefault().get("Point");
CtField f = new CtField(CtClass.intType, "z", point);
point.addField(f, "0");    // initial value is 0.
```

Now, the method `addField()` receives the second parameter, which is the source text representing an expression computing the initial value. This source text can be any Java expression if the result type of the expression matches the type of the field. Note that an expression does not end with a semi colon (`;`).

Furthermore, the above code can be rewritten into the following simple code:

```java
CtClass point = ClassPool.getDefault().get("Point");
CtField f = CtField.make("public int z = 0;", point);
point.addField(f);
```

#### Removing a member

To remove a field or a method, call `removeField()` or `removeMethod()` in `CtClass`. A `CtConstructor` can be removed by `removeConstructor()` in `CtClass`.

### 4.4 Annotations

`CtClass`, `CtMethod`, `CtField` and `CtConstructor` provides a convenient method `getAnnotations()` for reading annotations. It returns an annotation-type object.

For example, suppose the following annotation:

```java
public @interface Author {
    String name();
    int year();
}
```

This annotation is used as the following:

```java
@Author(name="Chiba", year=2005)
public class Point {
    int x, y;
}
```

Then, the value of the annotation can be obtained by `getAnnotations()`. It returns an array containing annotation-type objects.

```java
CtClass cc = ClassPool.getDefault().get("Point");
Object[] all = cc.getAnnotations();
Author a = (Author)all[0];
String name = a.name();
int year = a.year();
System.out.println("name: " + name + ", year: " + year);
```

This code snippet should print:

```bash
name: Chiba, year: 2005
```

Since the annoation of `Point` is only `@Author`, the length of the array `all` is one and `all[0]` is an `Author` object. The member values of the annotation can be obtained by calling `name()` and `year()` on the `Author` object.

To use `getAnnotations()`, annotation types such as `Author` must be included in the current class path. *They must be also accessible from a ClassPool object.* If the class file of an annotation type is not found, Javassist cannot obtain the default values of the members of that annotation type.  

### 4.5 Runtime support classes

In most cases, a class modified by Javassist does not require Javassist to run. However, some kinds of bytecode generated by the Javassist compiler need runtime support classes, which are in the`javassist.runtime` package (for details, please read the API reference of that package). Note that the`javassist.runtime` package is the only package that classes modified by Javassist may need for running. The other Javassist classes are never used at runtime of the modified classes.

### 4.6 Import

All the class names in source code must be fully qualified (they must include package names). However, the `java.lang` package is an exception; for example, the Javassist compiler can resolve `Object` as well as `java.lang.Object`.

To tell the compiler to search other packages when resolving a class name, call `importPackage()` in `ClassPool`. For example,

```java
ClassPool pool = ClassPool.getDefault();
pool.importPackage("java.awt");
CtClass cc = pool.makeClass("Test");
CtField f = CtField.make("public Point p;", cc);
cc.addField(f);
```

The seconde line instructs the compiler to import the `java.awt` package. Thus, the third line will not throw an exception. The compiler can recognize `Point` as `java.awt.Point`.

Note that `importPackage()` *does not* affect the `get()` method in `ClassPool`. Only the compiler considers the imported packages. The parameter to `get()` must be always a fully qualified name.  

### 4.7 Limitations

In the current implementation, the Java compiler included in Javassist has several limitations with respect to the language that the compiler can accept. Those limitations are:

-  The new syntax introduced by J2SE 5.0 (including enums and generics) has not been supported. Annotations are supported by the low level API of Javassist. See the `javassist.bytecode.annotation` package (and also `getAnnotations()` in `CtClass` and `CtBehavior`). Generics are also only partly supported. See [the latter section](http://www.javassist.org/tutorial/tutorial3.html#generics) for more details.

-  Array initializers, a comma-separated list of expressions enclosed by braces `{` and `}`, are not available unless the array dimension is one.

-  Inner classes or anonymous classes are not supported. Note that this is a limitation of the compiler only. It cannot compile source code including an anonymous-class declaration. Javassist can read and modify a class file of inner/anonymous class.

-  Labeled `continue` and `break` statements are not supported.

-  The compiler does not correctly implement the Java method dispatch algorithm. The compiler may confuse if methods defined in a class have the same name but take different parameter lists.

  For example,

  ```java
  class A {} 
  class B extends A {} 
  class C extends B {} 
  
  class X { 
      void foo(A a) { .. } 
      void foo(B b) { .. } 
  }
  ```

If the compiled expression is `x.foo(new C())`, where `x` is an instance of X, the compiler may produce a call to `foo(A)` although the compiler can correctly compile `foo((B)new C())`.

-  The users are recommended to use `#` as the separator between a class name and a static method or field name. For example, in regular Java,

  ```java
   javassist.CtClass.intType.getName()
  ```

  calls a method `getName()` on the object indicated by the static field `intType` in `javassist.CtClass`. In Javassist, the users can write the expression shown above but they are recommended to write:

  ```java
   javassist.CtClass#intType.getName()
  ```

  so that the compiler can quickly parse the expression.  

## 5. Bytecode level API

Javassist also provides lower-level API for directly editing a class file. To use this level of API, you need detailed knowledge of the Java bytecode and the class file format while this level of API allows you any kind of modification of class files.

If you want to just produce a simple class file, `javassist.bytecode.ClassFileWriter` might provide the best API for you. It is much faster than `javassist.bytecode.ClassFile` although its API is minimum. 

### 5.1 Obtaining a `ClassFile` object

A `javassist.bytecode.ClassFile` object represents a class file. To obtian this object, `getClassFile()` in `CtClass`should be called.

Otherwise, you can construct a `javassist.bytecode.ClassFile` directly from a class file. For example,

```java
BufferedInputStream fin
    = new BufferedInputStream(new FileInputStream("Point.class"));
ClassFile cf = new ClassFile(new DataInputStream(fin));
```

This code snippet creats a `ClassFile` object from `Point.class`.

A `ClassFile` object can be written back to a class file. `write()` in `ClassFile` writes the contents of the class file to a given `DataOutputStream`.

You can create a new class file from scratch. For example,

```java
ClassFile cf = new ClassFile(false, "test.Foo", null);
cf.setInterfaces(new String[] { "java.lang.Cloneable" });
 
FieldInfo f = new FieldInfo(cf.getConstPool(), "width", "I");
f.setAccessFlags(AccessFlag.PUBLIC);
cf.addField(f);

cf.write(new DataOutputStream(new FileOutputStream("Foo.class")));
```

this code generates a class file `Foo.class` that contains the implementation of the following class:

```java
package test;
class Foo implements Cloneable {
    public int width;
}
```

### 5.2 Adding and removing a member

`ClassFile` provides `addField()` and `addMethod()` for adding a field or a method (note that a constructor is regarded as a method at the bytecode level). It also provides `addAttribute()` for adding an attribute to the class file.

Note that `FieldInfo`, `MethodInfo`, and `AttributeInfo` objects include a link to a `ConstPool` (constant pool table) object. The `ConstPool` object must be common to the `ClassFile` object and a `FieldInfo` (or `MethodInfo` etc.) object that is added to that `ClassFile` object. In other words, a `FieldInfo` (or `MethodInfo` etc.) object must not be shared among different `ClassFile` objects.

To remove a field or a method from a `ClassFile` object, you must first obtain a `java.util.List` object containing all the fields of the class. `getFields()` and `getMethods()` return the lists. A field or a method can be removed by calling `remove()` on the `List` object. An attribute can be removed in a similar way. Call `getAttributes()` in `FieldInfo` or `MethodInfo` to obtain the list of attributes, and remove one from the list. 

### 5.3 Traversing a method body

To examine every bytecode instruction in a method body, `CodeIterator` is useful. To otbain this object, do as follows:

```java
ClassFile cf = ... ;
MethodInfo minfo = cf.getMethod("move");    // we assume move is not overloaded.
CodeAttribute ca = minfo.getCodeAttribute();
CodeIterator i = ca.iterator();
```

A `CodeIterator` object allows you to visit every bytecode instruction one by one from the beginning to the end. The following methods are part of the methods declared in `CodeIterator`:

- `void begin()`
  Move to the first instruction.
- `void move(int index)`
  Move to the instruction specified by the given index.
- `boolean hasNext()`
  Returns true if there is more instructions.
- `int next()`
  Returns the index of the next instruction.
  *Note that it does not return the opcode of the next instruction.*
- `int byteAt(int index)`
  Returns the unsigned 8bit value at the index.
- `int u16bitAt(int index)`
  Returns the unsigned 16bit value at the index.
- `int write(byte[] code, int index)`
  Writes a byte array at the index.
- `void insert(int index, byte[] code)`
  Inserts a byte array at the index. Branch offsets etc. are automatically adjusted.

The following code snippet displays all the instructions included in a method body:

```java
CodeIterator ci = ... ;
while (ci.hasNext()) {
    int index = ci.next();
    int op = ci.byteAt(index);
    System.out.println(Mnemonic.OPCODE[op]);
}
```

### 5.4 Producing a bytecode sequence

A `Bytecode` object represents a sequence of bytecode instructions. It is a growable array of bytecode. Here is a sample code snippet:

```java
ConstPool cp = ...;    // constant pool table
Bytecode b = new Bytecode(cp, 1, 0);
b.addIconst(3);
b.addReturn(CtClass.intType);
CodeAttribute ca = b.toCodeAttribute();
```

This produces the code attribute representing the following sequence:

```java
iconst_3
ireturn
```

You can also obtain a byte array containing this sequence by calling `get()` in `Bytecode`. The obtained array can be inserted in another code attribute.

While `Bytecode` provides a number of methods for adding a specific instruction to the sequence, it provides`addOpcode()` for adding an 8bit opcode and `addIndex()` for adding an index. The 8bit value of each opcode is defined in the `Opcode` interface.

`addOpcode()` and other methods for adding a specific instruction are automatically maintain the maximum stack depth unless the control flow does not include a branch. This value can be obtained by calling `getMaxStack()` on the `Bytecode` object. It is also reflected on the `CodeAttribute` object constructed from the `Bytecode` object. To recompute the maximum stack depth of a method body, call `computeMaxStack()` in `CodeAttribute`.

`Bytecode` can be used to construct a method. For example,

```java
ClassFile cf = ...
Bytecode code = new Bytecode(cf.getConstPool());
code.addAload(0);
code.addInvokespecial("java/lang/Object", MethodInfo.nameInit, "()V");
code.addReturn(null);
code.setMaxLocals(1);

MethodInfo minfo = new MethodInfo(cf.getConstPool(), MethodInfo.nameInit, "()V");
minfo.setCodeAttribute(code.toCodeAttribute());
cf.addMethod(minfo);
```

this code makes the default constructor and adds it to the class specified by `cf`. The `Bytecode` object is first converted into a `CodeAttribute` object and then added to the method specified by `minfo`. The method is finally added to a class file `cf`.

### 5.5 Annotations (Meta tags)

Annotations are stored in a class file as runtime invisible (or visible) annotations attribute. These attributes can be obtained from `ClassFile`, `MethodInfo`, or `FieldInfo` objects. Call `getAttribute(AnnotationsAttribute.invisibleTag)` on those objects. For more details, see the javadoc manual of `javassist.bytecode.AnnotationsAttribute` class and the `javassist.bytecode.annotation` package.

Javassist also let you access annotations by the higher-level API. If you want to access annotations through `CtClass`, call `getAnnotations()` in `CtClass` or `CtBehavior`.

## 6. Generics

The lower-level API of Javassist fully supports generics introduced by Java 5. On the other hand, the higher-level API such as `CtClass` does not directly support generics. However, this is not a serious problem for bytecode transformation.

The generics of Java is implemented by the erasure technique. After compilation, all type parameters are dropped off. For example, suppose that your source code declares a parameterized type `Vector<String>`:

```java
Vector<String> v = new Vector<String>();
  :
String s = v.get(0);
```

The compiled bytecode is equivalent to the following code:

```java
Vector v = new Vector();
  :
String s = (String)v.get(0);
```

So when you write a bytecode transformer, you can just drop off all type parameters. Because the compiler embedded in Javassist does not support generics, you must insert an explicit type cast at the caller site if the source code is compiled by Javassist, for example, through `CtMethod.make()`. No type cast is necessary if the source code is compiled by a normal Java compiler such as `javac`.

For example, if you have a class:

```java
public class Wrapper<T> {
  T value;
  public Wrapper(T t) { value = t; }
}
```

and want to add an interface `Getter<T>` to the class `Wrapper<T>`:

```java
public interface Getter<T> {
  T get();
}
```

then the interface you really have to add is `Getter` (the type parameters `<T>` drops off) and the method you also have to add to the `Wrapper` class is this simple one:

```java
public Object get() { return value; }
```

Note that no type parameters are necessary. Since `get` returns an `Object`, an explicit type cast is needed at the caller site if the source code is compiled by Javassist. For example, if the type parameter `T` is `String`, then `(String)` must be inserted as follows:

```java
Wrapper w = ...
String s = (String)w.get();
```

The type cast is not needed if the source code is compiled by a normal Java compiler because it will automatically insert a type cast.

If you need to make type parameters accessible through reflection during runtime, you have to add generic signatures to the class file. For more details, see the API documentation (javadoc) of the`setGenericSignature` method in the `CtClass`.

## 7. Varargs

Currently, Javassist does not directly support varargs. So to make a method with varargs, you must explicitly set a method modifier. But this is easy. Suppose that now you want to make the following method:

```java
public int length(int... args) { return args.length; }
```

The following code using Javassist will make the method shown above:

```java
CtClass cc = /* target class */; 
CtMethod m = CtMethod.make("public int length(int[] args) { return args.length; }", cc); m.setModifiers(m.getModifiers() | Modifier.VARARGS); 
cc.addMethod(m); 
```

The parameter type `int...` is changed into `int[]` and `Modifier.VARARGS` is added to the method modifiers.

To call this method in the source code compiled by the compiler embedded in Javassist, you must write:

```java
length(new int[] { 1, 2, 3 });
```

instead of this method call using the varargs mechanism:

```java
length(1, 2, 3);
```

## 8. J2ME

If you modify a class file for the J2ME execution environment, you must perform preverification. Preverifying is basically producing stack maps, which is similar to stack map tables introduced into J2SE at JDK 1.6. Javassist maintains the stack maps for J2ME only if `javassist.bytecode.MethodInfo.doPreverify` is true.

You can also manually produce a stack map for a modified method. For a given method represented by a `CtMethod` object `m`, you can produce a stack map by calling the following methods:

```java
m.getMethodInfo().rebuildStackMapForME(cpool);
```

Here, `cpool` is a `ClassPool` object, which is available by calling `getClassPool()` on a `CtClass` object. A `ClassPool`object is responsible for finding class files from given class pathes. To obtain all the `CtMethod` objects, call the `getDeclaredMethods` method on a `CtClass` object.

## 9. Boxing/Unboxing

Boxing and unboxing in Java are syntactic sugar. There is no bytecode for boxing or unboxing. So the compiler of Javassist does not support them. For example, the following statement is valid in Java:

```java
Integer i = 3;
```

since boxing is implicitly performed. For Javassist, however, you must explicitly convert a value type from `int` to `Integer`:

```java
Integer i = new Integer(3);
```

## 10. Debug

Set `CtClass.debugDump` to a directory name. Then all class files modified and generated by Javassist are saved in that directory. To stop this, set `CtClass.debugDump` to null. The default value is null.

For example,

```java
CtClass.debugDump = "./dump";
```

All modified class files are saved in `./dump`.

## 11. 如何集成到Android工程

### 11.1 创建buildSrc同级目录

在app同级目录下新建文件夹，文件夹名字必须为 **buildSrc**,新建 src->main->groovy->com.xxx.xxx 以及一个 build.gradle 文件

最终目录如图

![](D:\documents\JavaAssist\files\buildSrc_file_structure.webp.jpg)

图中所示的文件，除了src以及build.gradle之外的，都是系统后期自动编译生成

编辑build.gradle，填入如下内容：

```groovy
apply plugin: 'groovy'

repositories {
    jcenter()
}

dependencies {
    compile gradleApi()
    compile localGroovy()
    compile "org.javassist:javassist:3.24.0-GA"
    compile "com.android.tools.build:gradle:2.1.3"
}
```

### 11.2 增加Injection.groovy封装类

```groovy
class Injection implements Serializable {
    String injectClassName
    String injectMethodName
    Type injectType
    String expressionClassName
    String expressionFieldName
    String expressionMethodName
    List<String> injectSourceCode
    FindClassPolicy findClassPolicy = FindClassPolicy.WARN

    enum Type {
        BEFORE,
        AFTER,
        FIELD_ACCESS,
        METHOD_CALL
    }

    enum FindClassPolicy {
        ERROR,
        WARN,
        SKIP
    }
}
```

### 11.3 增加InjectionTask.groovy处理传入的Injection动作

```groovy
import javassist.CannotCompileException
import javassist.ClassPool
import javassist.CtClass
import javassist.CtMethod
import javassist.expr.ExprEditor
import javassist.expr.FieldAccess
import javassist.expr.MethodCall
import javassist.NotFoundException
import org.gradle.api.DefaultTask
import org.gradle.api.tasks.TaskAction

class InjectionTask extends DefaultTask {

    File inputDirectory
    File outputDirectory
    List<Injection> injectionList

    @TaskAction
    void process() {
        ClassPool classPool = new ClassPool(true)
        classPool.appendClassPath(inputDirectory.absolutePath)
        //project.android.bootClasspath 加入android.jar，不然找不到android相关的所有类
        classPool.appendClassPath(project.android.bootClasspath[0].toString())

        for (Injection injection : injectionList) {
            String className = injection.injectClassName
            String methodName = injection.injectMethodName
            String sourceCode = ""
            for (String line : injection.injectSourceCode) {
                sourceCode += line
                sourceCode += "\n"
            }
            if (sourceCode.length() > 0) {
                sourceCode = sourceCode.substring(0, sourceCode.length() - "\n".length())
            }
            Injection.Type injectType = injection.injectType

            println "---------- Injection ----------"
            println "Inject $className.$methodName()"
            println "Source code :"
            println sourceCode

            CtClass ctClass
            try {
                ctClass = classPool.get(className)
            }
            catch(NotFoundException e) {
                switch (injection.findFailPolicy) {
                    case Injection.FindFailPolicy.WARN:
                        println "[WARN] can't find $className! skip it..."
                        /** fall through **/
                    case Injection.FindFailPolicy.SKIP:
                        break
                    case Injection.FindFailPolicy.ERROR:
                        throw e
                }
                continue
            }
            if (ctClass.isFrozen()) {
                ctClass.defrost()
            }
            CtMethod ctMethod
            try {
                ctMethod = ctClass.getDeclaredMethod(methodName)
            }
            catch(NotFoundException e) {
                switch (injection.findFailPolicy) {
                    case Injection.FindFailPolicy.WARN:
                        println "[WARN] can't find $className.$methodName! skip it..."
                        /** fall through **/
                    case Injection.FindFailPolicy.SKIP:
                        break
                    case Injection.FindFailPolicy.ERROR:
                        throw e
                }
                continue
            }

            switch (injectType) {
                case Injection.Type.BEFORE :
                    ctMethod.insertBefore(sourceCode)
                    break

                case Injection.Type.AFTER :
                    try {
                        ctMethod.insertAfter(sourceCode, true)
                    }
                    catch(NotFoundException e) {
                    }
                    break

                case Injection.Type.METHOD_CALL :
                    String expressionClassName = injection.expressionClassName
                    String expressionMethodName = injection.expressionMethodName
                    boolean found = false
                    ctMethod.instrument(
                            new ExprEditor() {
                                @Override
                                void edit(MethodCall m) throws CannotCompileException {
                                    if (m.className == expressionClassName && m.methodName == expressionMethodName) {
                                        found = true
                                        m.replace(sourceCode)
                                    }
                                }
                            }
                    )
                    if (!found) {
                        switch (injection.findFailPolicy) {
                            case Injection.FindFailPolicy.WARN:
                                String msg = String.format("[WARN] can't find %s.%s in %s.%s! " +
                                        "skip it...", expressionClassName, expressionMethodName,
                                        className, methodName)
                                println msg
                                /** fall through **/
                            case Injection.FindFailPolicy.SKIP:
                                break
                            case Injection.FindFailPolicy.ERROR:
                                throw new IllegalStateException(String.format(
                                        "Cannot find method call expression : %s.%s()",
                                        expressionClassName,
                                        expressionClassName
                                ))
                        }
                    }
                    break

                case Injection.Type.FIELD_ACCESS :
                    String expressionClassName = injection.expressionClassName
                    String expressionFieldName = injection.expressionFieldName
                    boolean found = false
                    ctMethod.instrument(
                            new ExprEditor() {
                                @Override
                                void edit(FieldAccess f) throws CannotCompileException {
                                    if (f.className == expressionClassName && f.fieldName == expressionFieldName) {
                                        found = true
                                        f.replace(sourceCode)
                                    }
                                }
                            }
                    )
                    if (!found) {
                        switch (injection.findFailPolicy) {
                            case Injection.FindFailPolicy.WARN:
                                String msg = String.format("[WARN] can't find field access " +
                                        "expression(%s.%s) in %s.%s! skip it...", expressionClassName, expressionFieldName,
                                        className, methodName)
                                println msg
                                /** fall through **/
                            case Injection.FindFailPolicy.SKIP:
                                break
                            case Injection.FindFailPolicy.ERROR:
                                throw new IllegalStateException(String.format(
                                        "Cannot find method call expression : %s.%s()",
                                        expressionClassName,
                                        expressionClassName
                                ))
                        }
                        throw new IllegalStateException(String.format(
                                "Cannot find field access expression: %s.%s",
                                expressionClassName,
                                expressionFieldName
                        ))
                    }
                    break

                default :
                    throw new IllegalStateException("Invalid InjectType : " + injectType)
            }
            ctClass.writeFile(outputDirectory.absolutePath)
        }
    }
}

```

### 11.4 增加InjectionTransform.groovy编译过程钩子

Gradle提供了一个Transform api，可以用来处理编译之后的class文件，大概原理如下图：

![](D:\documents\JavaAssist\files\transform_android.webp.jpg)

每个类文件都会通过一个又一个Transform。[Transform API 介绍](http://tools.android.com/tech-docs/new-build-system/transform-api)

```groovy
import com.android.build.api.transform.*
import com.android.build.gradle.internal.pipeline.TransformManager
import org.gradle.api.Action
import org.gradle.api.Project

class InjectionTransform extends Transform {

    Project project
    List<Injection> injectionList

    InjectionTransform(Project project, List<Injection> injectionList) {
        this.project = project
        this.injectionList = injectionList
    }

    @Override
    String getName() {
        return "InjectionTransform"
    }

    @Override
    Set<QualifiedContent.ContentType> getInputTypes() {
        return TransformManager.CONTENT_CLASS
    }

    @Override
    Set<QualifiedContent.Scope> getScopes() {
        return TransformManager.SCOPE_FULL_PROJECT
    }

    @Override
    boolean isIncremental() {
        return false
    }

    @Override
    void transform(Context context, Collection<TransformInput> inputs, Collection<TransformInput> referencedInputs, TransformOutputProvider outputProvider, boolean isIncremental) throws IOException, TransformException, InterruptedException {
        println "---------- InjectionTransform ----------"

        File outputFolder
        for (TransformInput input : inputs) {
            if (input.directoryInputs.size() > 0) {
                assert input.directoryInputs.size() == 1
                DirectoryInput directoryInput = input.directoryInputs.first()
                outputFolder = outputProvider.getContentLocation(
                        directoryInput.name,
                        directoryInput.contentTypes,
                        directoryInput.scopes,
                        Format.DIRECTORY
                )
                break
            }
        }
        assert outputFolder != null

        println "OutputFolder = $outputFolder.path"

        inputs.each { TransformInput input ->
            input.jarInputs.each { JarInput jarInput ->
                println "Copy classes in jar $jarInput.file.path"
                project.copy {
                    from project.zipTree(jarInput.file)
                    into outputFolder
                }
            }
            input.directoryInputs.each { DirectoryInput directoryInput ->
                println "Copy classes in directory $directoryInput.file.path"
                project.copy {
                    from directoryInput.file
                    into outputFolder
                }
            }
        }

        println "Start InjectionTask"
        project.tasks.create(
                "injectionForPath$outputFolder",
                InjectionTask.class,
                new Action<InjectionTask>() {
                    @Override
                    void execute(InjectionTask injectionTask) {
                        injectionTask.setInputDirectory(outputFolder)
                        injectionTask.setOutputDirectory(outputFolder)
                        injectionTask.setInjectionList(injectionList)
                    }
                }
        ).execute()

        println "---------- End of InjectionTransform ----------"
    }
}
```

如上述代码所示，钩子需要传入List\<Injection>，在执行的过程中，会调用InjectionTask来执行具体的注入功能。

### 11.5 增加inject.gradle并定制需要注入的功能

```groovy
import %自定义包名%.Injection
import %自定义包名%.InjectionTransform

/*
 * injectClassName  : 需要修改的类名
 * injectMethodName : 需要修改的方法名
 * injectType : 修改方式
 *     - BEFORE : 在方法执行前添加代码
 *     - AFTER : 在方法执行完返回前添加代码
 *     - FIELD_ACCESS : 修改方法体内部逻辑，在获取某个变量的值时修改代码
 *     - METHOD_CALL : 修改方法体内部逻辑，在执行某个方法时修改代码
 * expressionClassName : FIELD_ACCESS或者METHOD_CALL语句的类名
 * expressionFieldName : FIELD_ACCESS语句的变量名
 * expressionMethodName : METHOD_CALL语句的方法名
 * injectSourceCode : 所有需要添加的代码，javassist语法
 *
 * Reference :
 * http://www.javassist.org/tutorial/tutorial2.html#intro
 */
def injectionList = [
        new Injection(
                injectClassName: "com.ted.android.contacts.common.HeaderParam",
                injectMethodName: "toJson",
                injectType: Injection.Type.AFTER,
                injectSourceCode: [
                        "\$_.remove(\"pa0\");",
                ]
        ),
]

// 挂钩子
android.registerTransform(new InjectionTransform(project, injectionList))
```

### 11.6 在需要注入的gradle脚本中增加依赖inject.gradle

```groovy
apply from: "inject.gradle"
```







































# References

- [javassist官方网站](http://www.javassist.org/)
- [javassist官方教程](http://www.javassist.org/tutorial/tutorial.html)
- [gradle集成javadoc官方文档](https://docs.gradle.org/current/javadoc/index.html)
- [gradle集成dsl官方文档](https://docs.gradle.org/current/dsl/)
- [android Transform官方文档](http://tools.android.com/tech-docs/new-build-system/transform-api)