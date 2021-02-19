# LinuxSkills

## 1、常用用户命令

### 1.1、mount

**语法：**

```sh
mount [-hV]
mount -a [-fFnrsvw] [-t vfstype]
mount [-fnrsvw] [-o options [,...]] device | dir
mount [-fnrsvw] [-t vfstype] [-o options] device dir
```

**参数说明：**

| 参数                               | 说明                                                         |
| ---------------------------------- | ------------------------------------------------------------ |
| -V                                 | 显示程序版本                                                 |
| -h                                 | 显示辅助讯息                                                 |
| -v                                 | 显示详细讯息，通常和 -f 一起用来除错                         |
| -f                                 | 通常用在除错的用途。它会使 mount 并不执行实际挂上的动作，而是模拟整个挂上的过程。通常会和 -v 一起使用 |
| -a                                 | 将 /etc/fstab 中定义的所有档案系统挂上                       |
| -F                                 | 这个命令通常和 -a 一起使用，它会为每一个 mount 的动作产生一个行程负责执行。在系统需要挂上大量 NFS 档案系统时可以加快挂上的动作 |
| -n                                 | 一般而言，mount 在挂上后会在 /etc/mtab 中写入一笔资料。但在系统中没有可写入档案系统存在的情况下可以用这个选项取消这个动作 |
| -r                                 | 等于-o ro                                                    |
| -w                                 | 等于-o rw                                                    |
| -L  label                          | 将含有特定标签的硬盘分割挂上                                 |
| -U uuid                            | 将指定uuid的分区挂上<br/>-L 和 -U 必须在/proc/partition 这种档案存在时才有意义 |
| -t                                 | 指定档案系统的类型，通常不必指定。mount 会自动选择正确的类型 |
| -o async                           | 打开非同步模式，所有的档案读写动作都会用非同步模式执行       |
| -o sync                            | 在同步模式下执行                                             |
| -o atime、-o noatime               | 当 atime 打开时，系统会在每次读取档案时更新档案的『上一次调用时间』。当我们使用 flash 档案系统时可能会选项把这个选项关闭以减少写入的次数。 |
| -o auto、-o noauto                 | 打开/关闭自动挂上模式。                                      |
| -o defaults                        | 使用预设的选项 rw, suid, dev, exec, auto, nouser, and async  |
| -o dev、-o nodev-o exec、-o noexec | 允许执行档被执行                                             |
| -o suid、-o nosuid                 | 允许执行档在 root 权限下执行                                 |
| -o user、-o nouser                 | 使用者可以执行 mount/umount 的动作                           |
| -o remount                         | 将一个已经挂下的档案系统重新用不同的方式挂上。例如原先是唯读的系统，现在用可读写的模式重新挂上 |
| -o loop                            | 使用 loop 模式用来将一个档案当成硬盘分割挂上系统             |

**小技巧：**

- losetup -a可以查看当前所有挂在的loop类型分区

**实例：**

将 /dev/hda1 挂在 /mnt 之下。

```
#mount /dev/hda1 /mnt
```

将 /dev/hda1 用唯读模式挂在 /mnt 之下。

```
#mount -o ro /dev/hda1 /mnt
```

将 /tmp/image.iso 这个光碟的 image 档使用 loop 模式挂在 /mnt/cdrom之下。用这种方法可以将一般网络上可以找到的 Linux 光 碟 ISO 档在不烧录成光碟的情况下检视其内容。

```
#mount -o loop /tmp/image.iso /mnt/cdrom
```



### 1.2、man

Linux下最通用的领域及其名称及说明如下：

| 领域 | 名称              | 说明                       |
| ---- | ----------------- | -------------------------- |
| 1    | 用户命令          | 可由任何人启动             |
| 2    | 系统调用          | 由内核提供的函数           |
| 3    | 例程              | 即库函数                   |
| 4    | 设备              | /dev目录下的特殊文件       |
| 5    | 文件格式描述      | 例如/etc/passwd            |
| 6    | 游戏              | 例如宏命令包、惯例等       |
| 7    | 杂项              | 例如宏命令包、惯例等       |
| 8    | 系统管理员工具    | 只能由root启动             |
| 9    | 其他(Linux特定的) | 用来存放内核例行程序的文档 |
| n    | 新文档            | 可能要移到更适合的领域     |
| o    | 老文档            | 可能会在一段期限内保留     |
| l    | 本地文档          | 与本特定系统有关的         |

man -a cmd

打开所有领域内的同名帮助，例如 man fam ，你首先会进入一个fam(1M)的命令版fam帮助，你再按q键

就会进入FAM(3X)，库函数版的帮助

man -aw cmd

显示所有cmd的所有手册文件的路径，如 man -aw fam 就是

/usr/share/man/man1/fam.1m.gz

/usr/share/man/man3/fam.3x.gz

man 领域代号 cmd

直接指定特定领域内搜索手册页，如 man 3 fam 直接进入库函数版的帮助

man -M PATH cmd

指定手册文件的搜索路径，如 man -M /home/mysql/man mysql 显示的就是你安装的mysql的帮助，

而不是系统自带的旧版mysql的帮助



### 1.3、awk

语法：

```
awk [选项参数] 'script' var=value file(s)
或
awk [选项参数] -f scriptfile var=value file(s)
```

常用用法1：打印某一列的内容

```
awk '{print $2}' file_name
```

常用用法2：加过滤条件

例如，查询第1列等于某个值

```
awk '$1 == "*" {print $3}' file_name
```

从例子可以看出，这里的*不需要转义，并且如果加了转义还会报警告

例如，查询匹配某个值，则用~//，不匹配用~! //

```
awk '$1 ~ /love/ {print}' //
```

常用用法3：BEGIN...END

```
awk 'BEGIN{FS=","} {print $1,$2}'     log.txt
或者
ls -l *.txt | awk '{sum+=$5} END {print sum}'
```

常用用法4：传入自定义参数

```
git branch -vv |awk -v AWK_BRANCH="$INPUT_BRANCH" '$1 == AWK_BRANCH {print $3}'
```

注意：awk命令中不需要$访问变量，直接写变量名即可

常用用法5：执行系统命令

```shell
# 打印所有进程的fd占用情况
ls /proc |grep -E "^[0-9]+$" |awk '{cmd="ls -l /proc/"$0"/fd"; print("----- "$0" -----"); system(cmd)}'
```





### 1.4、数组操作

字符串解析成数组：

```shell
local local_OLD_IFS=$IFS
IFS="+" #你可以换成需要切分的字符，比如","
YOUR_DEFINED_ARRAY=($YOUR_INPUT_STRING)
IFS=$local_OLD_IFS
```

数组合并成字符串：

```shell
local local_OLD_IFS=$IFS
IFS="+" #你可以换成需要切分的字符，比如","
YOUR_INPUT_STRING=${YOUR_DEFINED_ARRAY[*]}
IFS=$local_OLD_IFS
```

获取数组长度：

```shell
${#array[@]}
```

遍历数组方法一：

```shell
for(( i=0;i<${#array[@]};i++ )) do
	echo ${array[i]}
done
```

遍历数组方法二：

```shell
for element in ${array[@]}
# 也可以写成for element in ${array[*]}
do
	echo $element
done
```



### 1.5、字符串操作

trim()去掉头尾空格：

```shell
# 方法一
sed 's/ *$//g'
# 方法二
sed -e 's/^[[:space:]]*//'
```

比较字符串大小

```
[[ "2020-01-23" > "2020-01-22" ]] && echo YES
```



### 1.6、tr

tr 指令从标准输入设备读取数据，经过字符串转译后，将结果输出到标准输出设备。

！！！针对字符处理的，没有字符串的概念

删除所有空格

```
$ echo "  www.  sina.com.cn " |tr -d ' '
www.sina.com.cn
```

转换小写为大写

```
$ echo "www.sina.com.cn" |tr a-z A-Z
WWW.SINA.COM.CN

$ echo "www.sina.com.cn" |tr sina SINA
www.SINA.com.cN
从这个例子可以看出，并不能匹配字符串的概念，只会针对每个字符处理
```











## 2、vim

### 2.1、vim快捷键

![img](files/linuxSkills/vim-key.png)

|  组  |  按键  | 说明                                                         |
| :--: | :----: | ------------------------------------------------------------ |
| 删除 |   x    | 删除光标所在字符，相当于del按键                              |
| 删除 |   nx   | n表示数字，表示向后删除每个字符<br/>例如：10x表示删除包括光标在内的后面10个字符 |
| 删除 |   X    | 删除光标前一个字符，相当于backspace按键                      |
| 删除 |   nX   | n表示数字，表示向前删除每个字符<br/>例如：10X表示删除光标前的10个字符，**不包括光标**所在字符 |
| 删除 |   dd   | 剪切删除光标所在的行                                         |
| 删除 |  ndd   | n表示数字，删除光标所在的向下n行（包括当前行）               |
| 删除 |  d1G   | 删除光标所在行到第一行的字符                                 |
| 删除 |   dG   | 删除光标所在行到最后一行的字符                               |
| 删除 |   d0   | 删除光标所在位置到行首的字符                                 |
| 删除 |   d$   | 删除光标所在位置到行尾的字符                                 |
|      |        |                                                              |
| 复制 |   yy   | 复制光标所在的行                                             |
| 复制 |  nyy   | n表示数字，复制光标所在的向下n行（包括当前行）               |
| 复制 |  y1G   | 复制光标所在行到第一行的字符                                 |
| 复制 |   yG   | 复制光标所在行到最后一行的字符                               |
| 复制 |   y0   | 复制光标所在位置到行首的字符                                 |
| 复制 |   y$   | 复制光标所在位置到行尾的字符                                 |
|      |        |                                                              |
| 粘贴 |   p    | 将已复制的数据粘贴到光标的下一行（dd、yy都是复制）           |
| 粘贴 |   P    | 将已复制的数据粘贴到光标的上一行（dd、yy都是复制）           |
| 合并 |   J    | 将光标所在的行与下一行的数据合并为一行                       |
|      |        |                                                              |
|  宏  |   u    | 撤销上一步操作                                               |
|  宏  | Ctrl+r | 与u相反，表示重做前一步操作                                  |
|  宏  |   .    | 重复前一个操作<br/>例如，想一直删除行，按完dd之后，一直按.就好了 |











































## References