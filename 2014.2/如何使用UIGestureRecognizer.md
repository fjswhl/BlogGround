如果你需要在你的应用中检测手势，比如轻击，捏，拖拽或旋转，使用 `swift` 和自带的 `UIGestureRecognizer`的话这将非常简单。

在这篇教程中，你将会学到如何轻易地把手势识别加进你的应用，通过使用`Storyboard`编辑器或者用编程来实现。你将会构建一个简单的应用，在这个应用里你可以在手势识别器的帮助下，通过拖拽，捏和旋转来移动一个猴子和香蕉。

同时你也会体验一下其他的一些很酷的东西，比如：

* 为移动增加一个减速的特效
* 在手势识别器之间建立依赖关系
* 实现一个自定义的`UIGestureRecognizer`来给猴子挠痒

这篇教程假设你已经对`Storyboards`的基本概念很熟悉了。如果你第一次接触它们，你可能想先看看[Storyboard](http://www.raywenderlich.com/?p=5138)的教程

###准备工作
打开 Xcode 6，使用** iOS\Application\Single View Application **模板新建一个项目，在项目名里输入 **MonkeyPinch**，语言选择 **Swift**，设备选择**iPhone**。点击 **Next**，选择一个文件夹来保存你的项目，然后点击**Create**.

先下载项目所需要的[资源](http://cdn5.raywenderlich.com/wp-content/uploads/2014/06/MonkeyPinchResources. zip)。然后把这6个文件拖到你的项目里。选中**Destination: Copy items if needed**，选择**Create groups**，然后点击**Finish**。

下一步，打开**Main.storyboard**。视图控制器现在默认是正方形的，所以你可以对多个设备只用一个 storyboard。通常你会使用约束和**size classes**来布局你的 storyboards。但是这个应用只针对 iphone，所以你可以禁用**size classes**。在**File Inspector**面板下（**View Menu > Utilities > Show File Inspector**）,取消选中**Use Size Classes**。

你的视图现在是一个 iPhone 5 的尺寸
拖一个**Image View**到View Controller，设置 image 属性为**monkey.png**，然后点击**Editor Menu > Size to Fit Content**以调整 Image View 的尺寸与图片本身一样大。再拖一个 image view 进去，设置它为**banana.png**并调整尺寸。随意调整这些 imageview 的位置。现在你的 VC 应该像这个样子：

![]
应用的 UI 大概就是这样了，现在你将新增一个手势识别器以拖拽这些图片视图。

###UIGestureRecognizer概述
开始之前，这里有一个简要的概述，说明了如何使用`UIGestureRecognizers`以及为什么它们如此方便。

之前没有`UIGestureRecognizers`的时候，如果你想检测一个手势比如扫，你需要给`UIView`里的每一个触摸事件都注册通知 - 比如`touchesBegan`,`touchesMoves`,`touchesEnded`。每个程序员写的检测触摸的代码都稍有不同，从而导致一些细微的 Bug 以及应用之间的不一致性。

在iOS 3.0, 苹果用`UIGestureRecognizer`来拯救了这帮程序员。这些类提供了检测常用手势如触摸、捏、旋转、扫、拖动和长按等手势的一个默认实现。通过使用它们，你不仅省写了一大坨代码，还能让你的应用更合适地工作。当然如果你的应用需要的话，你仍然可以使用旧式的触摸通知。

使用`UIGestureRecognizers`相当简单，你只需要做以下几步：

1. **新建一个手势识别器**。当你新建一个手势识别器的时候，你给其指定一个回调函数，以此手势识别器就可以把手势的开始、变动、结束等信息传送给你。
2. **把这个手势识别器加进一个视图**。每个手势识别器都与一个（并且仅此一个）视图关联。当一个触摸在这个视图的范围内发生时，手势识别器会判断这个触摸是否符合它所定义的触摸类型，符合的话就会调用回调函数。

你可以通过代码来做这两步（本教程后面你将会这样做）。但是用 Storyboard 来新增手势识别器更加简单。 现在就向项目里新增第一个手势识别器把。

###UIPanGestureRecognizer
保持**Main.storyboard**打开，在**Object Library**里找到**Pan Gesture Recognizer**，然后把它拖到猴子的图片视图之上。这将会新建一个pan gesture recognizer，并且与猴子图片视图相关联。你可以通过点击猴子图片视图

