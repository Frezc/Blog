---
title: react-native对md风格中StatusBar的处理方式
tags: [android, react native]
categories: [develop]
date: 1455998940000
---

自从rn支持android以后，出现了不少的material design的库。
用了下一个叫[react-native-material-design][1]的库，先不谈性能方面的缺陷，这个库完全忽视了**StatusBar**的处理，使得其Drawer弹出时会很难看。
至少目前还没有看到哪个库对**StatusBar**进行了特殊处理，官方倒是有一个StatusBar的组件可以用来控制应用中**StatusBar**的表现，不过这个组件在android里是调用5.0加入api来实现的，也就是说只对5.0以上的系统有效。而且这个组件在实现Drawer占满屏幕的效果时，**StatusBar**要设为translucent，此时和在theme中设置**windowTranslucentStatus**没有什么区别，依然要考虑**StatusBar**空出来的地方。所以这个组件还不如设置theme呢，起码后者能兼容到4.4。

下面就谈谈比较合适的方法。

<!--more-->

![bilibili_md.png][2]

拿b站的app来看看要实现的效果。

## RN中的实现 ##
这个效果基本上都是设置translucent后，在Statusbar的位置画一个相同大小的**View**来实现的。rn里虽然没有现成的库，但是实现起来也是非常简单的。

首先在android项目里的控制app theme的style项里添加

    <item name="android:windowTranslucentStatus">true</item>

然后在**Navigator**上添加View
![statusbar_add.png][3]

这里的style为
```javascript
statusbar: {
  backgroundColor: COLOR.googleBlue700.color, // Statusbar的颜色
  height: 24                   // Statusbar的高度，android上为24dp
}

实现的效果
![my_statusbar.png][4]

![my_statusbar_drawer.png][5]

这样做还是有些不足的，比如**Statusbar**在未来的android版本中出现变动的话就得修改代码了，当然为了避免这点我们可以写个原生模块动态获取**Statusbar**的高度。

还有个办法就是在原生的android的项目中自定义View，不过这种方法麻烦而且扩展性不好，就不去实现了。

  [1]: https://github.com/react-native-material-design/react-native-material-design
  [2]: /images/2016/02/1657079296.png
  [3]: /images/2016/02/2531076439.png
  [4]: /images/2016/02/1361499160.png
  [5]: /images/2016/02/925583762.png