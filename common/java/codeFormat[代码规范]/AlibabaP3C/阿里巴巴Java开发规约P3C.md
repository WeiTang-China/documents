[TOC]

# 阿里巴巴Java开发规约P3C

## 插件介绍

网址：GitHub：<https://github.com/alibaba/p3c>

中文版: *[阿里巴巴Java开发手册](https://github.com/alibaba/p3c/blob/master/%E9%98%BF%E9%87%8C%E5%B7%B4%E5%B7%B4Java%E5%BC%80%E5%8F%91%E6%89%8B%E5%86%8C%EF%BC%88%E8%AF%A6%E5%B0%BD%E7%89%88%EF%BC%89.pdf)*

《阿里巴巴Java开发手册》自从第一个版本起，倍受业界关注，相信很多人对其中的规则也有了一定的了解，很多人甚至希望能尽快在自己的团队推行起来，这样大家有了一套共同的开发准则。但是，如何更好的去遵守规则并且按照手册去开发我们的系统确变得不那么容易，为了让开发者更加方便、快速的将规范推动并实行起来，阿里巴巴基于手册内容，研发了一套自动化的IDE检测插件（IDEA、Eclipse）， 该插件在扫描代码后，将不符合《手册》的代码按Blocker/Critical/Major三个等级显示在下方，甚至在IDEA上，还基于Inspection机制提供了实时检测功能，编写代码的同时也能快速发现问题所在。对于历史代码，部分规则实现了批量一键修复的功能，提升代码质量，提高团队研发效能。

## IDEA / AndroidStudio使用

打开IDEA，选择**Preferences - Plugins - Browse repositories**后，在输入框中输入"alibaba"，可以看到返回结果中有"Alibaba Java Coding Guidelines"。

![](pics\p3c-idea-search.png)

![](pics\p3c-idea-search-result.png)

点击插件详情中的"install"按钮，按照其提示即可完成安装，安装完成后需重启IDEA。

有三种方式可以扫描代码:

1. **在项目目录上右键点击也会出现这两个功能按钮，点击绿色的按钮即可开始扫描代码,或者在工程目录上右键也会出现检测的功能按钮。**
![](pics\p3c-idea-scan1.png)

2. **如果不想全部扫描，只扫描当前编辑的文件的话，在当前文件面板中点击右键也会出现此功能按钮。**
![](pics\p3c-idea-scan2.png)

3. **前面说的两种方式是手动检测，插件也提供了实时监测的功能，此功能默认开启，一旦开启则会在你编写代码时就会实时监测，一旦有不符合规范的语句就会出现错误提示。**
![](pics\p3c-idea-scan3.png)

由于大括号不规范的问题，`if`下方有错误红线的提示。
![](pics\p3c-idea-scan4.png)

扫描代码后，不符合规约的代码会按Blocker/Critical/Major三个等级显示在下方面板中，如图:
![](pics\p3c-idea-scan5.png)
左边是扫描出的不符合规范的代码，依次点进去可以看到是代码的多少行出现了规约问题以及哪一个规约问题，右边则是规约的详细描述及实例代码。
![](pics\p3c-idea-scan6.png)
不仅如此，右侧还有quick fix的按钮，点击后直接可以改正代码，但是并不是所有的问题都有此按钮，有些问题还是需要手动修改。



## Eclipse使用

通过Help >> Install New Software插件安装菜单，在安装插件的地址栏中输入：https://p3c.alibaba.com/plugin/eclipse/update
![](pics\p3c-eclipse-search.png)

确定后，直接勾选下面的Smartfox Eclipse Plugnin，然后一直下一步安装（中间需要点“I Accept”）
![](pics\p3c-eclipse-install.png)

安装完成后需重启eclipse，重启完成后，我们可以看到eclipse任务栏中多了两个小图标
![](pics\p3c-eclipse-icons.png)

当我们安装完成后，右键菜单中会出现“阿里编码规约扫描”，我们在指定要分析的类、包或者工程上右键
![](pics\p3c-eclipse-scan.png)

然后点击“阿里编码规约扫描”，即可分析出代码规范情况
![](pics\p3c-eclipse-scan-result.png)






## References

1. [官方GitHub](https://github.com/alibaba/p3c)
2. [IDEA / AndroidStudio使用博客](https://www.cnblogs.com/han-1034683568/p/7682594.html)
3. [Eclipse使用博客](https://blog.csdn.net/xiongpei00/article/details/80898749)
4. [阿里巴巴Java开发手册](https://github.com/alibaba/p3c/blob/master/%E9%98%BF%E9%87%8C%E5%B7%B4%E5%B7%B4Java%E5%BC%80%E5%8F%91%E6%89%8B%E5%86%8C%EF%BC%88%E8%AF%A6%E5%B0%BD%E7%89%88%EF%BC%89.pdf)

