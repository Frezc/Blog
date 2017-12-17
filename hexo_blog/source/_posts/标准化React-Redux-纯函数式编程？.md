---
title: 标准化React + Redux = 纯函数式编程？
tags: [react, redux, fp]
categories: [develop]
date: 1457202900000
---

最近看到github上一个Airbnb公司的js风格[指导手册][1]，感觉里面讲的都挺有道理的，里面的风格都是趋向使用es6来取代之前的各个api。
其中有关React有一条提到了*在没有state和ref时，推荐使用单纯的绘制函数代替类*，看到后翻了下官方文档，发现`propTypes`和`defaultProps`还是能用的。

想起之前用的Redux框架，其核心不就是将所有组件无状态化吗，配合它岂不是就能做到完全的函数式编程？
于是马上去改写了下之前写的[小例子][2]。

<!--more-->

改写需要做的也就是把类中的所有函数拿出来，将`render`名字改为类名，传入参数`props`，删掉`this`，将其他函数的参数进行相应的修改，最后别忘了`export default XXX;`。
[AnimeDayList.js][3] --改写前 [AnimeDayList.js][4] --改写后

由于基于flux思想进行的设计，所有组件都可以改为纯函数。由于在根组件**App**里定义了`componentWillMount`生命周期方法，所以就没改了，当然根组件作为有状态组件在flux思想里也是完全合理的。

整个例子的6个组件只定义了一个类，其他全部都是纯函数，使得整个项目清爽了很多啊。


  [1]: https://github.com/airbnb/javascript
  [2]: https://github.com/Frezc/AnimeList-in-React-Redux
  [3]: https://github.com/Frezc/AnimeList-in-React-Redux/blob/3078681dc70e6a5b55fa2739314ac9c2d07eecc3/src/components/AnimeDayList.js
  [4]: https://github.com/Frezc/AnimeList-in-React-Redux/blob/master/src/components/AnimeDayList.js