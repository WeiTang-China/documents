# 1、查找

## 1.1、如何查看某个端口被谁占用

查看被占用端口对应的PID，输入命令：netstat -aon|findstr "49157"，回车，记下最后一位数字，即PID,这里是2720

![](files\port_usage_findPid.png)

继续输入tasklist|findstr "2720"，回车，查看是哪个进程或者程序占用了2720端口，结果是：svchost.exe

![](files\port_usage_findProgramName.png)

或者是我们打开任务管理器，切换到进程选项卡，在PID一列查看2720对应的进程是谁，如果看不到PID这一列,如下图：

![](files\port_usage_taskMgrFindProgramName.png)

结束该进程：在任务管理器中选中该进程点击”结束进程“按钮，或者是在cmd的命令窗口中输入：taskkill /f /t /im Tencentdl.exe。

![](files\port_usage_killProgram.jpg)



## 1.2、如何查看文件被谁占用

1、右击任务栏，启动任务管理器；

2、选择“性能“选项卡，点击“资源监视器”；

3、点击“CPU”选项卡，在“关联的句柄”右侧的“搜索句柄”输入框输入文件名或文件夹名并点击搜索

![](files\file_usage.png)



# 2、Bat & Console

## 2.1、常用命令

- **call**

  `call` 调用另一个批处理文件（如果不用`call`而直接调用别的批处理文件，那么执行完那个批处理文件后将无法返回当前文件并执行当前文件的后续命令）

- **echo**

  `echo` 表示显示此命令后的字符

  `echo off` 表示在此语句后所有运行的命令都不显示命令行本身

  `@`加在每个命令行的最前面，表示运行时不显示这一行的命令行（只能影响当前行）

  因此我们常见的命令大多是`@echo off`

- **pause**

  `pause` 运行此句会暂停批处理的执行并在屏幕上显示Press any key to continue...的提示，等待用户按任意键后继续

- **rem**

  `rem` 表示此命令后的字符为解释行（注释），不执行，只是给自己今后参考用的（相当于程序中的注释）

- **errorlevel**

  当使用 `if errorlevel 值 cmmand` 句式时，它的含义是：如果返回的错误码值大于或等于值 的时候，将执行cmmand操作；

  当使用 `if %errorlevel%==值 cmmand` 句式时，它含义是：如果返回的错误码值等于值 的时候，将执行cmmand操作。

  一般上一条命令的执行结果返回的值只有两个，"成功"用0 表示、"失败"用 1 表示，实际上，errorlevel 返回值可以在0~255 之间。

- **goto**

  `goto labelA`表示跳转到已存在的`:labelA`位置继续执行

- **pushd**

  保存当前目录以供 POPD 命令使用，然后改到指定的目录；不输入path参数，则显示当前已经压栈的目录。

  PUSHD [path | ..]

- **popd**

  更改到 PUSHD 命令存储的目录的栈顶，如果栈内有多个，则再输入popd后依次切换目录。

- **shift**

  更改批处理文件中可替换参数的位置。

  SHIFT [/n]

  如果命令扩展被启用，SHIFT 命令支持/n 命令行开关；该命令行开关告诉
  命令从第 n 个参数开始移位；n 介于0和8之间。例如:

  ```powershell
  SHIFT /2
  ```

  会将 %3 移位到 %2，将 %4 移位到 %3，等等；并且不影响 %0 和 %1。

- **%变量名:~start:end%**，字符串裁剪

  ```powershell
  echo 截取前5个字符：
  echo %ifo:~0,5%
  echo 截取最后5个字符：
  echo %ifo:~-5%
  echo 截取第一个到倒数第6个字符：
  echo %ifo:~0,-5%
  echo 从第4个字符开始，截取5个字符：
  echo %ifo:~3,5%
  echo 从倒数第14个字符开始，截取5个字符：
  echo %ifo:~-14,5%
  ```

- 



## 2.2、流程控制语法

### 2.2.1、IF...ELSE...

执行批处理程序中的条件处理。

```shell
IF [NOT] ERRORLEVEL number command
IF [NOT] string1==string2 command
IF [NOT] EXIST filename command
```

| 语句              |                                                              |
| ----------------- | ------------------------------------------------------------ |
| NOT               | 指定只有条件为 false 的情况下，Windows 才应该执行该命令。    |
| ERRORLEVEL number | 如果最后运行的程序返回一个等于或大于指定数字的退出代码，指定条件为 true。 |
| string1==string2  | 如果指定的文字字符串匹配，指定条件为 true。                  |
| EXIST filename    | 如果指定的文件名存在，指定条件为 true。                      |
| command           | 如果符合条件，指定要执行的命令。如果指定的条件为 FALSE，命令后可跟 ELSE 命令，该命令将在 ELSE 关键字之后执行该命令。 |

ELSE 子句必须出现在同一行上的 IF 之后。例如:

```powershell
IF EXIST filename. (
	del filename.
) ELSE (
	echo filename. missing.
)
```

由于 del 命令需要用新的一行终止，因此以下子句不会有效:

```powershell
IF EXIST filename. del filename. ELSE echo filename. missing
```

由于 ELSE 命令必须与 IF 命令的尾端在同一行上，以下子句也不会有效:

```powershell
IF EXIST filename. del filename.
ELSE echo filename. missing
```

如果都放在同一行上，以下子句有效:

```powershell
IF EXIST filename. (del filename.) ELSE echo filename. missing
```

如果命令扩展被启用，IF 会如下改变:

```powershell
IF [/I] string1 compare-op string2 command
IF CMDEXTVERSION number command
IF DEFINED variable command
```

其中， compare-op 可以是:

- EQU - 等于
- NEQ - 不等于
- LSS - 小于
- LEQ - 小于或等于
- GTR - 大于
- GEQ - 大于或等于

而 /I 开关(如果指定)说明要进行的字符串比较不分大小写。/I 开关可以用于 IF 的 string1==string2 的形式上。这些比较都是通用的；原因是，如果 string1 和 string2 都是由数字组成的，字符串会被转换成数字，进行数字比较。

CMDEXTVERSION 条件的作用跟 ERRORLEVEL 的一样，除了它是在跟与命令扩展有关联的内部版本号比较。第一个版本是 1。每次对命令扩展有相当大的增强时，版本号会增加一个。命令扩展被停用时，CMDEXTVERSION 条件不是真的。如果已定义环境变量，DEFINED 条件的作用跟 EXIST 的一样，除了它取得一个环境变量，返回的结果是 true。

如果没有名为 ERRORLEVEL 的环境变量，%ERRORLEVEL%会扩充为 ERROLEVEL 当前数值的字符串表达式；否则，你会得到其数值。运行程序后，以下语句说明 ERRORLEVEL 的用法:

```powershell
goto answer%ERRORLEVEL%
:answer0
echo Program had return code 0
:answer1
echo Program had return code 1
```

你也可以使用以上的数字比较:

```powershell
IF %ERRORLEVEL% LEQ 1 goto okay
```

如果没有名为 CMDCMDLINE 的环境变量，%CMDCMDLINE%将在 CMD.EXE 进行任何处理前扩充为传递给 CMD.EXE 的原始命令行；否则，你会得到其数值。

如果没有名为 CMDEXTVERSION 的环境变量，%CMDEXTVERSION% 会扩充为 CMDEXTVERSION 当前数值的字串符表达式；否则，你会得到其数值。



## 2.3、内置变量和参数

批处理参数扩展变量（%0 到 %9）。当在批处理文件中使用批处理参数时，%0 将由批处理文件名替换，而 %1 到 %9 将由在命令行键入的相应参数替换。

可以在批处理参数中使用编辑符。编辑符使用当前的驱动器和目录信息将批处理参数扩展为部分或完整的文件或目录名。要使用编辑符，请键入百分号 (%) 字符，后面是波形符号 (~) 字符，然后键入合适的编辑符（即 %~modifier）。

下表列出了可在扩展中使用的编辑符。

| 编辑符   | 说明                                                         |
| -------- | ------------------------------------------------------------ |
| %~       | %~1 扩展 %1 并删除任何引号 (")                               |
| %~f      | %~f1 将 %1 扩展到完全合格的路径名                            |
| %~d      | %~d1 将 %1 扩展到驱动器盘符                                  |
| %~p      | %~p1 将 %1 扩展到路径                                        |
| %~n      | %~n1 将 %1 扩展到文件名                                      |
| %~x      | %~x1 将 %1 扩展到文件扩展名                                  |
| %~s      | %~s1 扩展的路径仅包含短名称                                  |
| %~a      | %~a1 将 %1 扩展到文件属性                                    |
| %~t      | %~t1 将 %1 扩展到文件日期/时间                               |
| %~z      | %~z1 将 %1 扩展到文件大小                                    |
| %~$PATH: | %~$PATH:1 搜索 PATH 环境变量中列出的目录，并将 %1 扩展到第一个找到的目录的完全合格名称。如果没有定义环境变量名称，或没有找到文件，则此编辑符扩展成空字符串 |

下表列出了可用于获取复杂结果的编辑符和限定符的可能组合情况：

| 编辑符      | 说明                                                         |
| ----------- | ------------------------------------------------------------ |
| %~dp0       | 将 %0 扩展到驱动器盘符+路径+文件名+扩展名                    |
| %~nx1       | 将 %1 扩展到文件名和扩展名                                   |
| %~dp$PATH:1 | 在 PATH 环境变量列出的目录中搜索 %1，并扩展到第一个找到的目录的驱动器盘符和路径 |
| %~dpn0      | 将%0扩展到驱动器盘符+路径+文件名                             |
| %~ftza1     | 将 %1 扩展到类似 dir 的输出行                                |

注意：在上面的例子中，可以使用其它批处理参数替换 %1 和 PATH。
%* 编辑符是唯一可代表在批处理文件中传递的所有参数的编辑符。不能将该编辑符与 %~ 编辑符组合使用。%~ 语法必须通过有效的参数值来终止。

不能以与使用环境变量相同的方式使用批处理参数。不能搜索或替换值，或检查子字符串。然而，可以将参数分配给环境变量，然后使用该环境变量。

## 2.4、获取当前目录名

```powershell
pushd %~p0 & for %%i in (.) do set curDirName=%%~ni
echo %curDirName%
```

## 2.5、判断输入参数是否目录

```powershell
SET a1=%~a1
if "%a1:~0,1%"=="d" (
	echo it's a dir!
) else (
	echo it's a file!
)
```











