---
title: 在Android的原生模块中得到RN组件的引用
tags: [android, react native]
categories: [develop]
date: 1455895380000
---

最近学习了下使用react-native(以下简称rn)来做App，这是目前唯一一个编写**跨平台**的**本地应用**的**开源**库，所以人气也是非常高啊。
因为是新东西，所以相关的讨论、开源库之类的都很少，目前有很多东西还是得依赖原生模块来处理。好在的是rn提供了一些挺简单的交互方法，所以不至于会有无法解决的严重后果。

不过在调用原生模块时，一开始我不太清楚怎么去获得rn里组件的实例引用，在网上也没找到相关问题，后来在看源代码后发现该怎么做了。

<!--more-->

## 分析 ##
一开始我是想看看**DrawerLayoutAndroid**组件是如何实现调用*openDrawer*和*closeDrawer*方法的，发现它是通过**UIManager**这个模块来分发命令，然后去看了下这个模块的源代码，发现了创建、删除、查找View等方法的装饰方法，具体是用**UIImplementation**这个类实现的。
于是找到**UIImplementation**中的*createView*方法

![uiimplementation_createview][1]

可见这个方法并没有创建真正的本地组件，之后通过**NativeViewHierarchyOptimizer**（优化UI层次）和**UIViewOperationQueue**（渲染的缓冲队列）两个类的处理后调用了**NativeViewHierarchyManager**的*createView*方法。

![nativeviewhierarchymanager_createview.png][2]

上图是这个方法中创建本地组件的关键语句。这里有三行注释，主要讲的就是把react的tag存到组件的id中，这样更容易复用组件。调用*setId*将tag保存到组件的属性当中。
这里我们就发现了原生组件的id其实就是对于rn组件的tag。那么最后一个问题就是怎么获得tag呢？

![drawerlayoutandroid_gettag.png][3]

在**DrawerLayoutAndroid.android.js**文件中我们找到*closeDrawer*方法，它调用了**UIManager**的*dispatchViewManagerCommand*方法，这个方法是讲指令传递给目标组件管理器调用的（下篇博客会讲），在源码中就能知道第一个传入参数其实就是rn组件的tag。那么如何获取就和*\_getDrawerLayoutHandle*方法写的一样了。

## 实现 ##
自己实现原生模块时需要找到rn组件实例的话只要相应的传入tag，然后调用*findViewById*即可。

![toastmodule_settext.png][4]

这里我偷了个懒，直接把MainActivity的实例暴露了出来，最好的方法还是利用消息传递给Activity处理。（**更正**：最好的方法应该是注册**Package**时传入activity实例，然后在*createNativeModules*方法中将activity传给module对象。）
这里要注意的是，模块的方法是异步执行的，如果你要更新ui的话，要切到主线程执行。

上面的代码还是存在挺严重的bug的，第二次调用*setText*就会时程序fc，目前还不清楚原因。
目前来说并不推荐利用这样的方法来更新rn的组件。


  [1]: /images/2016/02/2765341748.png
  [2]: /images/2016/02/2125075922.png
  [3]: /images/2016/02/422551472.png
  [4]: /images/2016/02/1683079715.png