# 基础语法

## #define

1. 无参数

   ```c++
   #define  标识符  字符串
   //定义标识符等同于字符串内容
   ```

2. 有参数

   ```c++
   #define  宏名(形参表)  字符串
   
   #define add(x, y) (x + y)
   // 代码中可以直接使用add宏
   add(1, 1.5)
   ```

   lib库中，一般会使用do...while(false)来增强宏的健壮性：

   ```c++
   #define SAFE_DELETE(p) do{ delete p; p = NULL} while(0)
   // 假设这里去掉do...while(0),
   #define SAFE_DELETE(p) delete p; p = NULL;
   // 那么以下代码，就会存在问题
   if(NULL != p)
       SAFE_DELETE(p)
   else
       ...do sth...
   ```

3. 宏定义中的特殊操作符

   1) #

   假如希望在字符串中包含宏参数，ANSI C允许这样作，在类函数宏的替换部分，#符号用作一个预处理运算符，它可以把语言符号转化程字符串。例如，如果x是一个宏参量，那么#x可以把参数名转化成相应的字符串。该过程称为字符串化。

   例如：

   ```c++
   #incldue <stdio.h>
   #define PSQR(x) printf("the square of" #x "is %d.\n",(x)*(x))
   int main(void)
   {
       int y =4;
       PSQR(y);
       //输出：the square of y is 16.
       PSQR(2+4);
       //输出：the square of 2+4 is 36.
       return 0;
   }
   ```

   2) ##

   \##运算符可以用于类函数宏的替换部分。另外，##还可以用于类对象宏的替换部分。这个运算符把两个语言符号组合成单个语言符号。
   例如：

   ```c++
   #include <stdio.h>
   #define XNAME(n) x##n
   #define PXN(n) printf("x"#n" = %d\n",x##n)
   int main(void)
   {
       int XNAME(1)=12;//int x1=12;
       PXN(1);//printf("x1 = %d\n", x1);
       //输出：x1=12
       return 0;
   }
   ```

   3) 可变参数宏`__VA_ARGS__`和一些常用的系统宏

   可变参数宏实现思想就是宏定义中参数列表的最后一个参数为省略号（也就是三个点）。这样预定义宏__VA_ARGS__就可以被用在替换部分中，替换省略号所代表的字符串。

   例如：

   ```c++
   #define PR(...) printf(__VA_ARGS__)
   int main()
   {
       int wt=1,sp=2;
       PR("hello\n");
       //输出：hello
       PR("weight = %d, shipping = %d",wt,sp);
       //输出：weight = 1, shipping = 2
       return 0;
   }
   ```

   省略号只能代替最后面的宏参数。
   \#define W(x,…,y)   错误！
   但是支持#define W(x, …)，此时传入的参数个数至少需要1个

   还有一些常用的系统宏：

   `__FILE__`宏在预编译时会替换成当前的源文件名
   `__LINE__`宏在预编译时会替换成当前的行号
   `__FUNCTION__`宏在预编译时会替换成当前的函数名称

   

## cast<>

### static_cast

用隐式转换、或者用户定义转换的组合在类型间的转换，可以使用`static_cast`，该运算符语法格式如下:

```cpp
static_cast<type-name>(expression);
```

仅当`type_name`可以被隐式转换为`expression`所属的类型时或者`expression`可以被隐式转换为`type_name`所属的类型时，可以使用`static_cast`.
它在以下场景时的类型转换时可用:

- 1.内置数据类型;
- 2.具有继承关系的类的指针和引用;
- 3.用户定义的可转换的类;

在继承类的指针或引用之间进行转换时，会把一个基类的指针转化成了一个派生类的指针，但实际上这个指针指向的还是原来的基类对象，因此在对`virtual`函数调用时需要注意其多态的特性。

如下示例中是对`static_cast`的使用：

```cpp
#include <iostream>
using namespace std;

class Animal{
public:
        virtual void show() {
                cout << "Animal show...." << endl;
        }
};
class Person : public Animal{
private:
        std::string name;
public:
        Person(){}
        //转换构造函数
        explicit Person(std::string& name):name(name){}
        virtual void show() {
                cout << "Person show...." << endl;
        }
        virtual void getName() { cout << "Person's name:" << name << endl;}
};

class Flower{};

int main()
{
        //1.隐式转换内置类型

        cout << "====内置数据类型转换====" << endl;
        double d1 = 3.14;
        int i1 = 4;
        int i2 = static_cast<int>(d1);
        double d2 = static_cast<double>(i1);
        cout << "i:"<< i2 << ",d:" << d2 << endl;
            
        Animal ani;
        Person per;

        cout << "====对象地址====" << endl;
        cout << "ani address:" << &ani << ",per address: " << &per << endl;

        //2.具有继承关系的类的指针
        cout << "====指针转换====" << endl;
        Animal* pani = static_cast<Animal*>(&per);
        Person* pper = static_cast<Person*>(&ani);

        cout << "Animal* pani->show():   ";
        pani->show();
        cout << "Person* pper->show():   ";
        pper->show();
        cout << "pani:" << pani << ", pper: " << pper << endl;
        //pper类型为Person*,但实际指向Animal对象，因此，调用将出现Segmentation fault
        //若取掉该方法的virtual关键字，则不该方法多态特性消失，可以调用
        //pper->getName();
            
        //3.具有继承关系的类的引用
        Animal& rani = static_cast<Animal&>(per);
        Person& rper = static_cast<Person&>(ani);
        cout << "====引用转换====" << endl;
        cout << "rani address: " << &rani << ", rper address: " << &rper << endl;
        rani.show();
        rper.show();
        //rper类型为Person&，但引用的是Animal对象，因此调用将出现Segmentation fault，
        //若取掉该方法的virtual，则不该方法多态特性消失，可以调用
        //rper.getName();

        //4.用户组合的可以进行隐式转换类之间的转换
        cout << "====string转换为Person:====" << endl;
        string str("person1");
        Person p = static_cast<Person>(str);
        p.getName();

        //不相关类不能使用      
        //Flower* pflo = static_cast<Flower*>(&ani);
        return 0;
}
/*
编译并运行:
@ubuntu:~$ g++ staticcast.cpp -o staticcast
@ubuntu:~$ ./staticcast 
====内置数据类型转换====
i:3,d:4
====对象地址====
ani address:0x7ffe798cd2b0,per address: 0x7ffe798cd310
====指针转换====
Animal* pani->show():   Person show....
Person* pper->show():   Animal show....
pani:0x7ffe798cd310, pper: 0x7ffe798cd2b0
====引用转换====
rani address: 0x7ffe798cd310, rper address: 0x7ffe798cd2b0
Person show....
Animal show....
====string转换为Person:====
Person's name:person1
*/
```

### const_cast

`const_cast`运算符则用于在有不同cv限定符之间的转换，也就是说在`const`和`volatile`之间进行转换，且只能用于指针、引用或指向成员类型的指针，如果使用对象，编译器将提示错误:

```bash
error: invalid use of const_cast with type ‘int’, which is not a pointer, reference, nor a pointer-to-data-member type
```

使用`const_cast`示例如下:

```cpp
#include <iostream>

using namespace std;

int main()
{
        const int i = 20; 
        int* k = const_cast<int*>(&i);
    
        cout << "before modify,k:" << *k << ",i:" << i << endl;
        *k = 40;
        cout << "after modify,k:" << *k << ",i:" << i << endl;
        return 0;
}
/*
编译并运行:
@ubuntu:~$ g++ constcast.cpp -o constcast
@ubuntu:~$ ./constcast 
before modify,k:20,i:20
after modify,k:40,i:20
*/
```

通过以上示例还可以发现，虽然将i的`const`取消了，但是依然无法修改i的值，所以说`const_cast`虽然可以取消指针的const性，但无法修改`const`值。

> !!!重要!!!
>
> 这里的i无法修改，可能是编译时代码优化造成的，类似于Java里面的编译时常量替换。
>
> 即使可以修改，但也不推荐来修改const变量。
>
> const_cast常用于参数对接，比如拿到了一个const int，但某个api却只接受int（形参被拷贝传值，不会修改；或者，传入的指针经研究代码确实不会被修改）

### dynamic_cast

`dynamic_cast`运算符只能用于具有继承关系的类型之间的向上转换，且只能是指针或者引用。其语法格式如下:

```cpp
dynamic_cast <type-name>(expression)
```

若转型成功，则返回type-name的值，若转型失败且type-name是指针类型，则返回该类型的空指针，若转型失败且type-name是引用类型，则它将抛出`bad_cast`异常。

此外，`dynamic_cast`会进行运行时类型识别，而所需信息是存储在虚函数表中的，因此需要有virtual方法，以生成虚函数表，否则将出现如下异常:

```cpp
error: cannot dynamic_cast ‘& ani’ (of type ‘class Animal*’) to type ‘class Person*’ (source type is not polymorphic)
```

使用示例如下:

```cpp
#include <iostream>
#include <typeinfo>

using namespace std;

class Animal{
public:
        virtual void show() {
                cout << "Animal show...." << endl;
        }
};
class Person : public Animal{
private:
        string name;
public:
        Person(){ this->name = "None";}
        Person(string & name):name(name){}
        virtual void show() {
                cout << "Person show...." << endl;
        }
        virtual void getName() { cout << "Person's name:" << name << endl;}
};

class Dog : public Animal
{
public:
        virtual void show() {
                cout << "Dog show...." << endl;
        }
};

int main()
{
        //不能使用对象转换，只能是指针或引用
        //Animal a = dynamic_cast<Animal>(per);
    
        Animal ani;
        Person per;
    
        // 1.指针转换
        Animal* pani = dynamic_cast<Animal*>(&per);
        Person* pper = dynamic_cast<Person*>(&ani);
        cout << "====指针转换=====" << endl;
        pani->show();
        if (pper != NULL)
                pper->show();
        else 
                cout << "pper is null pointer" << endl;

        // 2.引用转换
        cout << "====引用转换=====" << endl;
        Animal& rani = dynamic_cast<Animal&>(per);
        rani.show();
        try{
                Person& rper = dynamic_cast<Person&>(ani);
        } catch (bad_cast& ex) {
                cerr << ex.what() << endl;
        }
    
        // 3.不相关的类不能使用
        //Dog dog;
        //Person& rper2 = dynamic_cast<Person&>(dog);
        return 0;
}

/*
@ubuntu:~$ g++ dynamiccast.cpp -o dynamiccast
@ubuntu:~$ ./dynamiccast 
====指针转换=====
Person show....
pper is null pointer
====引用转换=====
Person show....
std::bad_cast
*/
```

> `dynamic_cast`和`static_cast`都可以对具有继承关系的指针和引用进行向上转换，优先使用dynamic_cast。

### reinterpret_cast

`reinterpret_cast`可以用于处理任意无关类型的指针或引用的转换，以及指针类型转换为足以存储指针表示的整型。但他有如下限制:

- 1.不能删除`const`;
- 2.不能将指针转换为更小的整型或者浮点型;
- 3.不能将数据指针转换为函数指针.

使用示例如下:

```cpp
#include <iostream>
#include <typeinfo>

using namespace std;

class Dog{};

class Flower {
public:
        void show() {
                cout << "Flower show..." << endl;
        }   
};


typedef int (*PFunc)(int);

int sum(int i); 

int main()
{
        Flower oflo;
        // 可以用于任意类型的指针/引用的转换    
        Dog* od = reinterpret_cast<Dog*>(&oflo);
        Flower* flower = reinterpret_cast<Flower*>(od);
        flower->show();

        // 可以用于指针转换为足以存储指针表示的整型
        int i = 20; 
        int* pi = &i; 
        long l = reinterpret_cast<long>(pi);
        cout << "l value:" << l << endl;

        // 不能将指针转换为更小的整型或者浮点型
        //short s = reinterpret_cast<short>(pi);

        // 不能将数据指针转换为函数指针
        PFunc p;
        //p = reinterpret_cast<PFunc*>(&i);
        // 可以将函数指针转换为数据指针
        Dog* pi2 = reinterpret_cast<Dog*>(sum); 
        return 0;
}

int sum(int i) {
        return 2 * i;
}
```

总的来说，使用`reinterpret_cast`是比较危险的。

























































