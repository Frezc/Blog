---
title: React的渲染性能优化
tags: [react, performance]
categories: [develop]
date: 1461518400000
---

都说网页的性能瓶颈在DOM操作，所以目前的主流前端框架（React、 Vue、AngularJs等）都在极力地减少DOM操作。

就React而言，使用Virtual DOM和一个diff算法（实际就是使用一个uid来判断）来尽可能的重用现有的DOM，以此来减少DOM操作（毕竟添加比更新要耗时）。

但是在一些需要高帧数刷新的组件里，即使是Virtual DOM的re-render也会显得十分耗时，那么我们看看怎么进行优化。

<!--more-->

## 渲染速度问题 ##

比如需要实现这么一个列表
```
<div>
  <Indicator
    percent={this.state.percent}
  />
  {
    this.state.items.map(item => 
      <Item
        item={item}
      />
    )
  }
</div>
```

这个组件我们需要监听`scroll`事件，在处理函数里更新state中的percent属性。
默认React不会进行任何优化处理，就这么写的话会发现在滚动页面时会有卡顿感，我用自己项目的一个列表项测试了一下（[RepoAbList.js][1]），打印了scroll开始、结束和render开始的时间，如下。
![scroll-update-all.png][2]

下面是滚动时不进行render的情况
![scroll-no-update.png][3]

可以发现正常情况scroll回调的间隔是16、17ms，如果render的时间超过这个值就会影响到scroll的刷新率。虽然react更新dom是异步进行的，但是对Virtual DOM的渲染时同步的。所以这里scroll也得等render结束才能继续。

那么就必须去优化一下Virtual DOM的渲染速度了。这里我们可以打印一下列表项中的每个`Item`的render时间，就能发现虽然每项都只用了1、2毫秒来渲染，但是加起来就不少了。

## shouldComponentUpdate ##
React也有给出[解决方案][4]，`shouldComponentUpdate`在默认情况下是返回`true`的，也就是说只要`props`或`state`改变，这个组件就会更新，同样子组件由于`props`的改变也会更新，具体情况可以参考[这里][5]。

由于列表的Virtual DOM在每次render时都是重新生成的，所以就不要指望`vDOMEq`相同了，最简单的方法就是实现每个`Item`的`shouldComponentUpdate`方法（通过比较当前和传入的`props`来判断是否需要更新，由于属性为`object`需要判断内部的变化，或许我们需要[immutable-js][6]）。

## PureRenderMixin ##
React提供的`PureRenderMixin`其实已经帮我们做好了上面需要做的事，按[文档][7]中的做法就行了。不过这个插件会比较所有的属性，在某些情况下可能会和预期相违。比如传入一个函数的情况，可以看看我提的一个[Issue][8]。

官方要保持这个插件的单一性，所以要忽略函数的话需要我们自己实现一下。
我们可以使用[Shallow Compare][9]这个插件来十分简便地完成，只要筛选掉原来props对象中的类型为`'function'`属性，再调用`Shallow Compare`就可以了。


  [1]: https://github.com/Frezc/Share-Favors-App/blob/master/src/components/RepoAbList.js
  [2]: /images/2016/04/4058937871.png
  [3]: /images/2016/04/1059717184.png
  [4]: https://facebook.github.io/react/docs/component-specs.html#updating-shouldcomponentupdate
  [5]: https://facebook.github.io/react/docs/advanced-performance.html#shouldcomponentupdate-in-action
  [6]: https://facebook.github.io/immutable-js/
  [7]: https://facebook.github.io/react/docs/pure-render-mixin.html
  [8]: https://github.com/facebook/react/issues/6601
  [9]: https://facebook.github.io/react/docs/shallow-compare.html