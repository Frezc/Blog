title: Gradle的preDexDebug错误的解决办法(大概)
date: 2015-05-16 01:47:14
categories: develop
tags: 
- intellij idea
- gradle
- android
---

今天把项目pull下来然后用intellij执行时出现了以下的错误提示
```
Error:Gradle: Execution failed for task ':app:preDexDebug'.
> com.android.ide.common.process.ProcessException: org.gradle.process.internal.ExecException: Process 'command 'C:\Program Files\Java\jdk1.8.0_40\bin\java.exe'' finished with non-zero exit value 1
```
因为没有错误提示，只好去网上找解决方法。这时还是不得不感叹stackoverflow这网站的强大啊。

两个小时内试了n多方法都没成效，其中也试过把项目回滚，发现即使回滚也会有这个错误，很明显这不是项目本身的问题，大概是gradle哪里出现了问题。
___
总之，两个小时后在一次电脑当机重启后就莫名其妙地好了，我这里就讲讲我改过什么吧，也许可以当作参考。
- 升级sdk的build-tools和support library到最新(反正全部保持最新)
- 项目里引用了一个库，是以project形式引用的，将这个库的build.gradle里的compileSdkVersion之类的改成和项目app相同。
- 将项目和这个库的dependencies引用的库全部改成最新的，v4、v7这些intellij会出现提示，而CardView这些不会，需要手动改。
- 点击Build-Clean Project。(这个没关机前我就试过几遍，还是有错误)
- 终极大法，重启电脑。(我是电脑当掉了才重启，不然可能还要折腾很久)