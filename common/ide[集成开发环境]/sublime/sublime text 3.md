# sublime text 3

## 1、安装及破解

下载地址：http://www.onlinedown.net/soft/68602.htm

本地缓存：[安装包压缩文件](files/Sublime_Text_Build_3114_Setup.zip)

切记不要升级！！！

**破解码1**：

```
Michael Barnes
Single User License
EA7E-821385
8A353C41 872A0D5C DF9B2950 AFF6F667
C458EA6D 8EA3C286 98D1D650 131A97AB
AA919AEC EF20E143 B361B1E7 4C8B7F04
B085E65E 2F5F5360 8489D422 FB8FC1AA
93F6323C FD7F7544 3F39C318 D95E6480
FCCC7561 8A4A1741 68FA4223 ADCEDE07
200C25BE DBBC4855 C4CFB774 C5EC138C
0FEC1CEF D9DCECEC D3A5DAD1 01316C36
```

**安装Package Control**：

使用Ctrl+`快捷键或者通过View->Show Console菜单打开命令行，粘贴如下代码：

```
import urllib.request,os; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); open(os.path.join(ipp, pf), 'wb').write(urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ','%20')).read())
```



## 2、常用快捷键

| 组       | 按键&菜单        | 功能                                                         |
| -------- | ---------------- | ------------------------------------------------------------ |
| **选择** | Ctrl + L         | 选择整行(继续按加选择下行)                                   |
| **选择** | Ctrl + D         | 选择字符串 (继续按选择下个相同的字符串)                      |
| **选择** | Ctrl + M         | 光标移动至括号内开始或结束的位置                             |
|          |                  |                                                              |
| **搜索** | Ctrl + F         | 打开底部搜索框，查找关键字                                   |
| **搜索** | Ctrl + SHIFT + F | 在文件夹内查找                                               |
| **搜索** | Ctrl + P         | 打开搜索框<br/>1、输入当前项目中的文件名，快速搜索文件<br/>2、输入@和关键字，查找文件中函数名<br/>3、输入：和数字，跳转到文件中该行代码<br/>4、输入#和关键字，查找变量名 |
| **搜索** | Ctrl + G         | 打开搜索框，自动带：，输入数字跳转到该行代码                 |
| **搜索** | Ctrl + R         | 打开搜索框，自动带@，输入关键字，查找文件中的函数名          |
| **搜索** | Ctrl + :         | 打开搜索框，自动带#，输入关键字，查找文件中的变量名、属性名等 |
|          |                  |                                                              |
| **文件** | Ctrl + P         | 搜索项目中的文件                                             |
|          |                  |                                                              |
|          |                  |                                                              |
|          |                  |                                                              |
|          |                  |                                                              |
|          |                  |                                                              |
|          |                  |                                                              |
|          |                  |                                                              |



