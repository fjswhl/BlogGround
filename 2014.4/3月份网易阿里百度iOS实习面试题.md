今年开学陆续投了阿里、百度、网易的 iOS 实习生，下面就分享一下我在面试过程中所碰到的题目 (+2表示被问过2次)，并根据我自己认为的难易程度分了个类。**这些问题如果和网上的面试题目重复，纯属巧合**

#####基础

* `DFS`和`BFS`的区别及其使用场景
* 通知中心和代理的区别
* `weak`和`strong`的区别 +3
* 什么时候使用到`weak`?
* 引用循环(`retain cycle`)是怎样产生的？
* Cocoa 有哪些消息传递机制？
* 简述`ViewController`的生命周期
* 什么是`RestFul API`

---
#####中等
* 谈谈`Swift`和`Objective-C`的优缺点 **+2**
* n 的阶乘末尾有几个0？
* iOS 环境下一共有几种多线程编程技术？
* 现在有一张大图，想让用户下载到一半能取消下载，你应该用哪种多线程方法来实现？
* `weak`和`__unsafe_unretained`的区别，`__unsafe_unretained`的使用场景
* Block里引用到`self`的话一定要用`weak self`吗？
* 简述`Runloop`的原理
* `NSTimer`只能在主线程上运行吗？
* `UIView`在什么时候会调用`drawRect:`，当我调用`setNeedsDisplay`后，视图会立刻刷新吗？不会的话是在什么时候刷新？
* `loadView`和`viewDidLoad`的区别
* 简述`Autolayout`布局系统的原理
* `id`和`NSObject`的区别
* 用 CocoaPods 的时候，如果一个库依赖`AFNetwork 1.1`，另一个库依赖`AFNetwork 2.0`，能够安装吗？冲突是如何解决的？

---
#####难
* 如何用`GCD`来实现`NSOperation`的取消？

---
#####开放性问题
* 用过什么开源框架，读过它们的源码吗？
* 这个项目你遇到过什么难题，是如何解决的？ **+3**
