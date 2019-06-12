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



