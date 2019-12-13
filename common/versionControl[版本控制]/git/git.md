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

- **windows**
      `D:\installed\Git\usr\bin`
- **linux**
      `/home/mine/bin/`

属性`push.type`被用来指示是否不采用gerrit中转提交

- 不配置或者direct

  `git push origin dev`

- gerrit

  `git push origin HEAD:refs/for/dev`

- tfs，可跟参数--force

  `git push --force origin dev:${self_defined_branch}`

尽可能的配置user.name，比如`wei.tang@teddy.dell`，或者`wei.tang@self.iMac#BaoAnHome`



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

个人常用

`git config --global alias.glog "log --color --oneline --decorate --graph --pretty=format:'%C(red)%h%Creset -%C(yellow)%d%Creset %Cgreen(%cd) %C(bold blue)%an%Creset %s' --date=short"`





## 2.4、解决gitk中文乱码问题

```shell
git config --global --add gui.encoding utf-8
```



## 2.5、全局.gitignore配置`core.excludesfile`

正如 [忽略文件](https://git-scm.com/book/zh/v2/ch00/r_ignoring) 所述，你可以在你的项目的 `.gitignore` 文件里面规定无需纳入 Git 管理的文件的模板，这样它们既不会出现在未跟踪列表，也不会在你运行 `git add` 后被暂存。

不过有些时候，你想要在你所有的版本库中忽略掉某一类文件。 如果你的操作系统是 OS X，很可能就是指 `.DS_Store`。 如果你把 Emacs 或 Vim 作为首选的编辑器，你肯定知道以 `~` 结尾的临时文件。

这个配置允许你设置类似于全局生效的 `.gitignore` 文件。 如果你按照下面的内容创建一个 `~/.gitignore_global` 文件：

```
*~
.DS_Store
```

……然后运行 `git config --global core.excludesfile ~/.gitignore_global`，Git 将把那些文件永远地拒之门外。



## 2.6、[Microsoft Word 进行版本控制](https://www.cnblogs.com/yezuhui/p/6853271.html)

1. Install pandoc.   去http://pandoc.org/installing.html 找到合适的pandoc下载文件，然后下载安装。

2. 编辑 ~/.gitconfig 文件，添加

   ```properties
   [diff "pandoc"]
     textconv=pandoc --to=markdown
     prompt=false
   [alias]
     wdiff = diff --word-diff=color
   ```

   或者使用如下命令：

   ```shell
   git config --global diff.pandoc.textconv="pandoc --to=markdown"
   git config --global diff.pandoc.prompt="false"
   git config --global alias.wdiff="diff --word-diff=color"
   ```

3. 然后在你的工程目录下新建一个 .gitattributes，写入：

   ```properties
   *.docx diff=pandoc
   ```

   如果是doc文件，把docx换成doc应该也是一样的。

## 2.7、创建本地分支后，让远程分支与它关联

```shell
git branch --set-upstream-to=origin/remote_branch  your_branch
```

使用git在本地新建一个分支后，需要做远程分支关联。如果没有关联，git会在下面的操作中提示你显示的添加关联。

关联目的是在执行git pull, git push操作时就不需要指定对应的远程分支，你只要没有显示指定，git pull的时候，就会提示你。



# 3、图解git

## 3.1、基本用法

![img](files/git/basic-usage.svg)

上面的四条命令在工作目录、暂存目录(也叫做索引)和仓库之间复制文件。

- `git add files` 把当前文件放入暂存区域。
- `git commit` 给暂存区域生成快照并提交。
- `git reset -- files` 用来撤销最后一次`git add files`，你也可以用`git reset` 撤销所有暂存区域文件。
- `git checkout -- files` 把文件从暂存区域复制到工作目录，用来丢弃本地修改。

你可以用 `git reset -p`, `git checkout -p`, or `git add -p`进入交互模式。



也可以跳过暂存区域直接从仓库取出文件或者直接提交代码。如下图所示：

![img](files/git/basic-usage-2.svg)

- `git commit -a `相当于运行 `git add` 把所有当前目录下的文件加入暂存区域再运行。`git commit`.
- `git commit files` 进行一次包含最后一次提交加上工作目录中文件快照的提交。并且文件被添加到暂存区域。
- `git checkout HEAD -- files` 回滚到复制最后一次提交。

## 3.2、约定

后文中以下面的形式使用图片：

![img](files/git/conventions.svg)

绿色的5位字符表示提交的ID，分别指向父节点。

分支用橘色显示，分别指向特定的提交。

当前分支由附在其上的*HEAD*标识。 

这张图片里显示最后5次提交，*ed489*是最新提交。 *master*分支指向此次提交，另一个*maint*分支指向祖父提交节点。

## 3.3、命令详解

### 3.3.1、Diff

有许多种方法查看两次提交之间的变动。下面是一些示例：

![img](files/git/diff.svg)

### 3.3.2、Commit

提交时，git用暂存区域的文件创建一个新的提交，并把此时的节点设为父节点。然后把当前分支指向新的提交节点。

下图中，当前分支是*master*。 在运行命令之前，*master*指向*ed489*，提交后，*master*指向新的节点*f0cec*并以*ed489*作为父节点。

![img](files/git/commit-master.svg)

即便当前分支是某次提交的祖父节点，git会同样操作。下图中，在*master*分支的祖父节点*maint*分支进行一次提交，生成了*1800b*。 这样，*maint*分支就不再是*master*分支的祖父节点。此时，[merge](http://marklodato.github.io/visual-git-guide/index-zh-cn.html#merge) (或者 [rebase](http://marklodato.github.io/visual-git-guide/index-zh-cn.html#rebase)) 是必须的。

![img](files/git/commit-maint.svg)

如果想更改一次提交，使用 `git commit --amend`。git会使用与当前提交相同的父节点进行一次新提交，旧的提交会被取消。

![img](files/git/commit-amend.svg)

### 3.3.3、Checkout

checkout命令用于从历史提交（或者暂存区域）中拷贝文件到工作目录，也可用于切换分支。

如果不指定branch或某一个提交，则从暂存区域拷贝到工作目录，如[3.1、基本用法](#3.1、基本用法)中有介绍。

以下指令均指定了branch或某一个提交

当给定某个文件名（或者打开-p选项，或者文件名和-p选项同时打开）时，git会从指定的提交中拷贝文件到暂存区域和工作目录。比如，`git checkout HEAD~ foo.c`会将提交节点*HEAD~*(即当前提交节点的父节点)中的`foo.c`复制到工作目录并且加到暂存区域中。（如果命令中没有指定提交节点，则会从暂存区域中拷贝内容。）注意当前分支不会发生变化。

![img](files/git/checkout-files.svg)

当不指定文件名，而是给出一个（本地）分支时，那么*HEAD*标识会移动到那个分支（也就是说，我们“切换”到那个分支了），然后暂存区域和工作目录中的内容会和*HEAD*对应的提交节点一致。新提交节点（下图中的a47c3）中的所有文件都会被复制（到暂存区域和工作目录中）；只存在于老的提交节点（ed489）中的文件会被删除；不属于上述两者的文件会被忽略，不受影响。

![img](files/git/checkout-branch.svg)

如果既没有指定文件名，也没有指定分支名，而是一个标签、远程分支、SHA-1值或者是像*master~3*类似的东西，就得到一个匿名分支，称作*detached HEAD*（被分离的*HEAD*标识）。这样可以很方便地在历史版本之间互相切换。比如说你想要编译1.6.6.1版本的git，你可以运行`git checkout v1.6.6.1`（这是一个标签，而非分支名），编译，安装，然后切换回另一个分支，比如说`git checkout master`。然而，当提交操作涉及到“分离的HEAD”时，其行为会略有不同。

![img](files/git/checkout-detached.svg)

#### HEAD标识处于分离状态时的提交操作

当*HEAD*处于分离状态（不依附于任一分支）时，提交操作可以正常进行，但是不会更新任何已命名的分支。(你可以认为这是在更新一个匿名分支。)

![img](files/git/commit-detached.svg)

一旦此后你切换到别的分支，比如说*master*，那么这个提交节点（可能）再也不会被引用到，然后就会被丢弃掉了。注意这个命令之后就不会有东西引用*2eecb*。

![img](files/git/checkout-after-detached.svg)

但是，如果你想保存这个状态，可以用命令`git checkout -b name`来创建一个新的分支。

![img](files/git/checkout-b-detached.svg)

### 3.3.4、Reset

reset命令把当前分支指向另一个位置，并且有选择的变动工作目录和索引。也用来在从历史仓库中复制文件到索引，而不动工作目录。

如果不给选项，那么当前分支指向到那个提交。如果用`--hard`选项，那么工作目录也更新，如果用`--soft`选项，那么都不变。

![img](files/git/reset-commit.svg)

如果没有给出提交点的版本号，那么默认用*HEAD*。这样，分支指向不变，但是索引会回滚到最后一次提交，如果用`--hard`选项，工作目录也同样。

![img](files/git/reset.svg)

如果给了文件名(或者 `-p`选项), 那么工作效果和带文件名的[checkout](http://marklodato.github.io/visual-git-guide/index-zh-cn.html#checkout)差不多，除了索引被更新。

![img](files/git/reset-files.svg)

### 3.3.5、Merge

merge 命令把不同分支合并起来。合并前，索引必须和当前提交相同。如果另一个分支是当前提交的祖父节点，那么合并命令将什么也不做。 另一种情况是如果当前提交是另一个分支的祖父节点，就导致*fast-forward*合并。指向只是简单的移动，并生成一个新的提交。

![img](files/git/merge-ff.svg)

否则就是一次真正的合并。默认把当前提交(*ed489* 如下所示)和另一个提交(*33104*)以及他们的共同祖父节点(*b325c*)进行一次[三方合并](http://en.wikipedia.org/wiki/Three-way_merge)。结果是先保存当前目录和索引，然后和父节点*33104*一起做一次新提交。

![img](files/git/merge.svg)

### 3.3.6、Cherry Pick

cherry-pick命令"复制"一个提交节点并在当前分支做一次完全一样的新提交。

![img](files/git/cherry-pick.svg)

### 3.3.7、Rebase

rebase是merge命令的另一种选择。merge把两个父分支合并进行一次提交，提交历史不是线性的。rebase在当前分支上重演另一个分支的历史，提交历史是线性的。 本质上，这是线性化的自动的 [cherry-pick](#3.3.6、Cherry Pick)。

![img](files/git/rebase.svg)

上面的命令都在*topic*分支中进行，而不是*master*分支，在*master*分支上重演，并且把分支指向新的节点。注意旧提交没有被引用，将被回收。

要限制回滚范围，使用`--onto`选项。下面的命令在*master*分支上重演当前分支从*169a6*以来的最近几个提交，即*2c33a*。

![img](files/git/rebase-onto.svg)

同样有`git rebase --interactive`或者`git rebase -i`让你更方便的完成一些复杂操作，比如丢弃、重排、修改、合并提交。没有图片体现这些，细节看这里:[git-rebase(1)](http://www.kernel.org/pub/software/scm/git/docs/git-rebase.html#_interactive_mode)





















# References

- [官方网站](https://git-scm.com/)
- [图解git](http://marklodato.github.io/visual-git-guide/index-zh-cn.html)