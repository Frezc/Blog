---
title: 自己在Android开发中碰到的问题和解决办法
tags: [android]
categories: [develop]
date: 1447087860000
---

说起来android我已经半年多没碰过了，这次为了让小组成员会写网络请求和用design库，我还是自己动手写了网络请求的封装类和一个design库的demo。当然，还是不免遇到了一些问题。
ps: 因为是前几天的事，也没截图，就随便记录一下啦。

<!--more-->

## 项目升级 ##
看idea总提示我项目所用的支持库需要升级，于是第一件事当然是把`build.gradle`里引用库的版本号都改到最新了，还添加了design库的引用，然后就报错了。

一共有两个错误

 1. 资源重定义：搜了下发现是库里的命名冲突了，我这个项目中是`com.zzt.inbox`这个库和`appcompat-v7`间的冲突，前者并不会使用了，于是就直接移除了。
 2. 资源未找到：这个还是因为我只将支持库升级到了`23.1.0`，而sdk版本还停留在22的原因，将其改为23就ok了。

## Intellij Idea 15 ##
看到idea升级到15了就马上去装了15，打开后直接是一个错误：jre未找到。我顺着错误中给出的路径：`\jre\bin\java.exe`浏览了一下，发现这个路径就是错误的，实际上是`\jre\jre\bin\java.exe`。不知道我是不是个例。

当然解决方法很简单，在系统中安装一个自己的java就ok了，我由于没有安装32位的java所以idea自动使用了自带的java。最后我直接使用64位的idea就完全没问题了。

idea15的新特性我了解的不多，不过最直观的感受就是打开时稍微快了一点吧。

## Context的空指针问题 ##
我在一个`Activity`中在某个变量初始化时调用了`this.getApplicationContext()`结果出现了空指针问题，当时我把这个函数放在`onCreate()`里后就好了。

后来我看到一篇关于`Context`的[博客](http://blog.csdn.net/guolin_blog/article/details/47028975)，才明白是怎么回事。

![context.png][1]

从上面这张图可以看出`Activity`只是一个装饰者，通过源码可以知道`getApplicationContext()`调用的还是其内部的一个`ContextImpl`对象。而这个对象是通过`attachBaseContext(Context)`这个函数传递给`Activity`的，所以在这个函数调用之前去调用`getApplicationContext()`自然会出现空指针异常了。

  [1]: /images/2015/11/74545713.png