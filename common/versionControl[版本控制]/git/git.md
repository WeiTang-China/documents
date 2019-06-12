| 版本 | 修订人 |   日期   | 描述                        |
| :--: | :----: | :------: | :-------------------------- |
|  --  |  唐炜  | 2019-6-5 | 增加章节2.1、2.2、2.3       |
|  --  |  唐炜  | 2019-6-3 | 增加对git各个分区理解的文档 |



# 1、工作区、暂存区、版本库、远程仓库

## 1.1、各分区的关系

Git本地有四个工作区域：工作目录（Working Directory）、暂存区(Stage/Index)、资源库(Repository或Git Directory)、git仓库(Remote Directory)。

文件在这四个区域之间的转换关系如下：

![](files\git_areas.png)

- **Workspace**： 工作区，就是你平时存放项目代码的地方

- **Index / Stage**： 暂存区，用于临时存放你的改动，事实上它只是一个文件，保存即将提交到文件列表信息

- **Repository**： 仓库区（或版本库），就是安全存放数据的位置，这里面有你提交到所有版本的数据。其中HEAD指向最新放入仓库的版本

- **Remote**： 远程仓库，托管代码的服务器，可以简单的认为是你项目组中的一台电脑用于远程数据交换



git的工作流程一般是这样的：

１、在工作目录中添加、修改文件；

２、将需要进行版本管理的文件放入暂存区域；

３、将暂存区域的文件提交到git仓库。



## 1.2、文件的状态

版本控制就是对文件的版本控制，要对文件进行修改、提交等操作，首先要知道文件当前在什么状态，不然可能会提交了现在还不想提交的文件，或者要提交的文件没提交上。

GIT不关心文件两个版本之间的具体差别，而是关心文件的整体是否有改变，若文件被改变，在添加提交时就生成文件新版本的快照，而判断文件整体是否改变的方法就是用SHA-1算法计算文件的校验和。

![](files\git_file_states.png)

- **Untracked:**   未跟踪, 此文件在文件夹中, 但并没有加入到git库, 不参与版本控制. 通过git add 状态变为Staged。

- **Unmodify:**   文件已经入库, 未修改, 即版本库中的文件快照内容与文件夹中完全一致. 这种类型的文件有两种去处, 如果它被修改, 而变为Modified.
  如果使用git rm移出版本库, 则成为Untracked文件。

- **Modified:** 文件已修改, 仅仅是修改, 并没有进行其他的操作. 这个文件也有两个去处, 通过git add可进入暂存staged状态, 使用git checkout 则丢弃修改过, 返回到unmodify状态, 这个git checkout即从库中取出文件, 覆盖当前修改。

- **Staged:** 暂存状态. 执行git commit则将修改同步到库中, 这时库中的文件和本地文件又变为一致, 文件为Unmodify状态. 执行git reset HEAD filename取消暂存, 文件状态为Modified。

 下面的图很好的解释了这四种状态的转变：

![](files\git_file_state_transfer.png)



# 2、使用技巧

## 2.1、切换difftool

global的配置存在~/.gitconfig中 

mergetool的配置在.gitconfig中修改，如下所示（注意缩进）： 

```properties
[merge]
    tool = bc3

[mergetool "bc3"]
    path = /d/installed/Beyond Compare 3/BCompare.exe
    keepBackup = false
    trustExitCode = false
```

或者使用git config --global --add merge.tool="bc3"来添加



## 2.2、快捷sync & push脚本(免输入当前的branch)

把files目录中的gitpush.sh和gitsync.sh拷贝到git对应的上下文目录中，例如：
windows
    `D:\installed\Git\usr\bin`
linux
    `/home/mine/bin/`



## 2.3、使用alias增强git log输出

shell终端下不能gitk，完全需要用log来查看，新增一个或几个alias快捷命令：
`git config --global alias.slog 'log --color --oneline --decorate'`

- --decorate[=short|full|auto|no]
  Print out the ref names of any commits that are shown. If short is specified, the ref name prefixes refs/heads/, refs/tags/ and refs/remotes/ will not be printed. If full is specified, the full ref name (including prefix) will be printed. If auto is specified, then if the output is going to a terminal, the ref names are shown as if short were given, otherwise no ref names are shown. The default option is short.

- --oneline
  This is a shorthand for "--pretty=oneline --abbrev-commit" used together.

- 查询相关提交人的，模糊匹配
  --author=

- 查询commitlog相关，模糊匹配
  --grep=''



## 2.4、解决gitk中文乱码问题

```shell
git config --global --add gui.encoding utf-8
```





















# References

- [官方网站](https://git-scm.com/)