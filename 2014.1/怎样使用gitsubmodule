译自[Jon Cairns的播客](http://blog.joncairns.com/2011/10/how-to-use-git-submodules/)  
**Git submodules是在一个仓库里链接另一个仓库的方式.** 比如, 如果你的项目需要使用到别人挂在 Github 上的项目, 那么你就可以把它作为一个submodule,而不是把它所有的代码复制进自己的项目. 这样便有另外的好处:可以跟踪 submodule 仓库的变化并且可以一键更新而不是手动更新代码.  

*这篇教程将会告诉你:*

* 如何向你的项目新增一个 submodule
* 如何 clone 带有 submodules 的仓库
* 如何更新 submodules
* 如何管理 submodules 里的 submodules(递归的 submodules)
* 如何移除 submodules(或者当出错时,应该做些什么)

我知道最后一点有点麻烦, 但我们还是要讲一下.

###准备工作
对于这篇教程,首先你需要一个 Github 帐号.你可能已经有了,不然你也不会看到这里的. 你可以新建一个仓库,或者直接 fork 我的[示例项目](https://github.com/joonty/example). 如果你已经熟悉 fork 和 clone 操作的话. 你可以跳过本节剩余部分

点击屏幕右上脚"Fork"按钮, 这将会在你的帐号下新建一份示例仓库的副本. 然后, clone 这个仓库, 把(username)替换成你自己的用户名
```
jcairns$ git clone git@github.com:(username)/example.git submodule-example
```
这行命令会把你自己的项目拷贝到目录'submodule-example'. 进入到这个目录里.现在可以开始愉快得玩耍 submodule 了.

###新增一个 submodule
我的示例项目是一个很屌的 web 应用. 它包含以下特性:

1. 打印出"Hello,World"标题  

嗯, 似乎它所做的就这么多- -. 不管怎样, 这个很屌的 web 应用需要有一个 ORM *(译者注:即对象关系映射)* 来帮助它更有效率地工作, 所以我们就用 PHP Doctrine. [Doctrine2](https://github.com/doctrine/doctrine2)已经挂在 Github 上了. 新增一个 submodule,在终端下敲入这个命令`git submodule add`:
```
jcairns$ git submodule add (repository) (directory)
```
这将会把repository注册成指定目录directory下的一个 submodule. 在本文这个栗子中, 我们想把 Doctrine 仓库作为一个 submodule 放进目录'doctrine'里, 用`git submodule add`:
```
jcairns$ git submodule add git://github.com/doctrine/doctrine2.git doctrine
```
这将会把 doctrine 注册成你的项目的一个 submodule, 并且把数据都拷贝进目录'doctrine'. 命令`git submodule status`会告诉你这个 submodule 已经被注册了并且指向了哪一个commit
```
jcairns$ git submodule status
-15877e14430a316a7576918bc7c996e52d91105d doctrine
``` 
另外, 用`git status`来查看在父仓库中有哪些变化被注册.
```
jcairns$ git status
# On branch master
# Changes to be committed:
#   (use "git reset HEAD ..." to unstage)
#
#   new file:   .gitmodules
#   new file:   doctrine
#
```
这告诉我们有2个文件被修改过了: '.gitmodules'存有submodule 的信息; 'doctrine'是 submodule 它自己. 当你在父仓库的时候,Git 不会跟踪submodule 里的文件, Git 只把它当成一个单一的文件.我们稍后再来折腾它. 首先, 我们想保存更改并推送到远程仓库:
#####Commit Changes
```
jcairns$ git commit -m 'Added Doctrine submodule'
[master 37f40bb] Added Doctrine submodule
 2 files changed, 4 insertions(+), 0 deletions(-)
 create mode 100644 .gitmodules
 create mode 160000 doctrine
```
#####Push to Remote
```
jcairns$ git push
Counting objects: 4, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 433 bytes, done.
Total 3 (delta 0), reused 0 (delta 0)
To git@github.com:joonty/example.git
   223e6ba..37f40bb  master -> master
```
现在去看一下你 Github 上的仓库你能看见在父仓库里有一个指向 Doctrine 的链接:!(submodule link in Github)[]
恭喜! 你已经增加了一个 submodule. 现在来看看如何 clone 一个带有 submodules 的仓库.
###Clone 一个带有 submodules 的仓库
先试试把刚才用的示例仓库拷贝到另一个目录. 移动到另一个目录, 运行:
```
jcairns$ git clone git@github.com:(username)/example.git submodule-clone-example
```
同样地, 确保把(username)替换成你的用户名. 这将会把示例仓库 clone 到目录'submodule-clone-example' - cd 进这个目录. 看一下 'doctrine'目录, 本应该是包含我们的 submodule 的, 但发现里面却是空的. 发生什么了? Git 抽风了?  

不是的. 默认下, **git clone**操作不会下载父仓库里的 submodule. 为了把 submodule 下载下来, 你需要运行`git submodule init` 接着 `git submodule update`:

######Submodule Init
```
jcairns$ git submodule init
Submodule 'doctrine' (git://github.com/doctrine/doctrine2.git) registered for path 'doctrine'
```
这会把 submodule 注册到正确的路径, 'doctrine',  但不会clone 代码
######Submodule Update
```
jcairns$ git submodule update
Submodule 'doctrine' (git://github.com/doctrine/doctrine2.git) registered for path 'doctrine'
Jonathan-Cairns-iMac:submodule-example jcairns$ git submodule update
Cloning into doctrine...
remote: Counting objects: 63339, done.
remote: Compressing objects: 100% (16009/16009), done.
remote: Total 63339 (delta 44444), reused 62836 (delta 43982)
Receiving objects: 100% (63339/63339), 16.16 MiB | 712 KiB/s, done.
Resolving deltas: 100% (44444/44444), done.
Submodule path 'doctrine': checked out '15877e14430a316a7576918bc7c996e52d91105d'
```
这条命令会把 submodules 的代码拉下来. 现在你得到了你的示例仓库的一个副本了, submodules 完好无损.
###更新一个 submodule
正如我刚才说的那样, submodules 就是一个 Git 仓库里的 Git 仓库: 没什么神奇的. 因此, 只要你在 submodule 目录下, 所有的常规 Git 操作比如`push`,`pull`,`reset`,`log`,`status`等等, 都可以正常工作. 如果你想确保你的 submodule 和远程仓库保持同步, 在 submodule 目录里运行`git pull`(不要用`submodule`):
```
jcairns$ cd doctrine
jcairns$ git pull
Already up-to-date.
```
如果你得到一个错误信息, 说你不在任何分支之上, 只要运行`git checkout master`就可修复.

如果你在`pull`后 submodule 有一些更新, 父仓库会告诉你有一些变动需要 commit 了. submodule自身指向一个指定的 commit, 并且如果这个 commit 改变了, 父仓库会得知这个改变. 如果你的 submodule 需要在一个指定 commit 上工作, 可用`git reset`来设置:
```
jcairns$ git reset --hard (commit hash)
```
比如, 如果我们想把 Doctrine 的版本改变到最近的一个标签(目前是2.1.2), 只需要:
```
jcairns$ cd doctrine
jcairns$ git reset --hard 144d0de
HEAD is now at 144d0de Release 2.1.2
```
再回到父目录, commit 之:
```
jcairns$ cd ..
jcairns$ git commit -am 'Set doctrine version to 2.1.2'
```
当推送至远程仓库时,submodule 也会和指定的 commit 关联起来. 有件事情值得说一下, 如果你和别人一起工作在同一个项目, 别人也可以在 submodule 下 pull 并且 commit , 因此改变了 submodule 的 commit 指向. 这个问题很容易解决, 只需要再做一次`git reset`

还有一件事值得说一下, 如果你的 submodule 你有`push`的权限, 你可以编辑,commit并推送 submodule 的内容, 这些操作与你的父仓库完全独立. 当然这时 submodule 指向了另一个 commit, 父仓库会得知变动, 这点前面也说过了.

### submodules 里的 submodules
submodules 的一个很牛的特性就是它们自身能再包含 submodules. 比如, Doctrine 仓库就有很多的 submodules, 包括[doctrine-common](https://github.com/doctrine/common)和[dbal](https://github.com/doctrine/dbal).

让我们回到示例仓库. 现在, Doctrine 已经被注册成一个 submodule, 但是它自己所有的submodules 并没有被下载下来. 在*doctrine*目录下, 执行`git submodule status`:
```
jcairns$ git submodule status
-3762cec59aaecf1e55ed92b2b0b3e7f2d602d09a lib/vendor/Symfony/Component/Console
-c3e1d03effe339de6940f69a4d0278ea34665702 lib/vendor/Symfony/Component/Yaml
-ef431a14852d7e8f2d0ea789487509ab266e5ce2 lib/vendor/doctrine-common
-f91395b6f469b5076f52fefd64574c443b076485 lib/vendor/doctrine-dbal
```
这说明 doctrine 有4个 submodules. 每行的首部"-"符号说明这些 submodules 还没有被下载. 我们可以运行`git submodule init`然后`git submodule update`, 就可以把所有的仓库拷贝下来并放到正确的位置上. 但如果我想把示例仓库拷贝到别的机器上呢? 每次都对每个 submodules 手动运行`init`和`push`非常无聊和费时

还好, 我们在 clone 的时候就可以解决这个问题. 只要在运行`git clone`时加上`--recursive`选项就行了:
```
jcairns$ git clone --recursive (repository)
```
这会递归地初始化并下载所有的 submodules, 如此简单!

###移除submodules
有时你决定不再需要某个 submodule了. 或者你发现某个 submodule 似乎有点问题无法正常工作, 最好的办法就是移除它再重新安装.

不幸的是, 这没那么简单, `git rm -rf [submodule directory]`是不行的. 如果你运行这个命令, Git 会抱怨说它找不到任何相应的文件. 为了移除一个 submodule, 你需要编辑 *.gitmodules* 文件, 这个文件在你项目的根目录下(不是 submodule 的目录).

用你最喜欢的编辑器打开这个文件, 可以看到如下:
```
[submodule "doctrine"]
    path = doctrine
    url = git://github.com/doctrine/doctrine2.git
```
如果你有很多 submodules 你可以看到很多条目, 每个条目占3行. 比如, doctrine 项目就有`.gitmodules file`, 看起来是这样:
```
[submodule "lib/vendor/doctrine-common"]
    path = lib/vendor/doctrine-common
    url = git://github.com/doctrine/common.git
[submodule "lib/vendor/doctrine-dbal"]
    path = lib/vendor/doctrine-dbal
    url = git://github.com/doctrine/dbal.git
[submodule "lib/vendor/Symfony/Component/Console"]
    path = lib/vendor/Symfony/Component/Console
    url = git://github.com/symfony/Console.git
[submodule "lib/vendor/Symfony/Component/Yaml"]
    path = lib/vendor/Symfony/Component/Yaml
    url = git://github.com/symfony/Yaml.git
```
为了移除一个 submodule, 删掉相应的3行. 在我们这个例子中, 因为只有一个 submodule, 你可以删掉文件里的全部内容或者直接删掉这个文件. 当下一次 commit 时, 你会被问到是否到 commit 这些变动到`.gitconfig`. 是的话将会移除远程仓库里的 submodule, 之后所有 clone 这个仓库的人将看不到这个 submodule.

然而, 这个 submodule 仍然在你本地仓库里阴魂不散. 你可以运行`git submodule status`, 得到一个警告:
```
jcairns$ git submodule status
No submodule mapping found in .gitmodules for path 'doctrine'
```
我靠, 似乎它黏上了我们的项目. 是的确实如此, 但是我们当然可以修复它. 问题在于`.gitmodules`文件并不是存放 submodule 引用的唯一地方, submodules 还记录在文件`.git/config`里, 这个文件打开是这样:
```
[core]
    repositoryformatversion = 0
    filemode = true
   bare = false
   logallrefupdates = true
[remote "origin"]
    fetch = +refs/heads/*:refs/remotes/origin/*
    url = git@github.com:joonty/example.git
[branch "master"]
    remote = origin
    merge = refs/heads/master
[submodule "doctrine"]
    url = git://github.com/doctrine/doctrine2.git
```
对 submodule 的引用在文件底部. 删除这两行代码即可从你的本地仓库中移除 submodule(你需要用 sudo 来修改)

完成对 submodule 的移除了吗? 基本上移除了. 你现在还需要移除 git 对 submodule 的缓存, 用`git rm --cached <path/to/submodule>`. 对于我们这个例子就是:
```
jcairns$ git rm --cached doctrine
```
**submodule 目录名后没有'/'**. 现在, submodule 终于被彻底移除了. 记得要commit 并且推送这些更改到远程仓库下.


