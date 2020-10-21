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

   

