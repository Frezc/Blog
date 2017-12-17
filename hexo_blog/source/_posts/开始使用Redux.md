---
title: 开始使用Redux
tags: [react, redux]
categories: [develop]
date: 1456853340000
---

最近开始试着用React来写前端了，虽然感觉在构建Web上React实在是有些大材小用，但是毕竟这个库的可是打着`Learn Once, Write Anywhere`的口号来着，在写不同平台应用时会用React写得开心就行。

然后我发现了Redux这个东西，这是flux的一个实现，那么flux是什么玩意呢？
很明显flux不是什么实际的框架，而是一种框架思想，特点就是单项数据流吧，它是将所有状态更新都放到一个数据流中进行处理。相比MVC，Flux弱化了Controller的功能吧。

下面讲讲具体的[例子][1]。(请确保你对React已经十分熟悉)

<!--more-->

官方的todoApp是十分简单明了的演示了，第一次照着例子打一遍可以有一个大致的理解。

首先看一下应用的一个流程图
![flux-simple-f8-diagram-with-client-action-1300w.png][2]

这是应用内部数据流的演示，实际上Redux已经帮我们把数据流相关的函数封装好了，所以剩下的需要我们写的也就**action creator**和**reducer**了。
我写了一个[starter][3]，可以直接拿来修改开发。

## View ##
我个人习惯还是从View开始开发，View部分和原本的React开发并没有什么不同。只要注意一点，**不要在组件中使用state**，所有需要控制的地方都使用属性，之后你需要从父组件将属性传入。
页面我使用全文本表示了，并没有加多少css。

## Store ##
因为没有在组件里使用state，所以状态怎么保存呢？
Redux里将所有状态都放到了一棵状态树里，而这个状态树保存在Store实例里。那么在View如何获得这个状态树呢。

![create_store.png][4]

这里做了3件事，绑定中间件、创建store、通过Provider组件绑定View和store。这么做以后store里的状态树更新时都会传递给View。
然后在你需要获得状态树的组件里（官方建议只在顶层组件里获取）
![view_connect.png][5]

通过connect绑定该View后，每次状态树更新时都会调用*select*函数，参数就是状态树，该函数的返回对象会传递给该View的props对象
![state_props.png][6]

这样之前根据之前写的通过属性控制的View就会自动更新了。

## Action & Action Creator ##
Action指的是更新状态的请求，其格式一般（不是一定）是这样的

    {type: DOWHAT, params: optional}

type是提醒Redux要做什么，Action中也能跟其他参数。当然你可以自己定义格式，只要在后面Reducer里处理时对应就好。

Action Creator就是返回Action对象的纯函数，其存在的意义主要是少打代码、减少错误。
![action_creator.png][7]

有了Action后只要调用*dispatch*方法（见上上图）就能通知Redux要干什么了，接下来Action会传递给Reducer处理，以更新状态树。

PS: 如果需要请求API的话只要不写在Reducer里就可以了，dispatch action纯粹只是用来更新状态的，和之前setState功能相同。所以只要请求完后异步dispatch一下就可以了。不一定要使用redux-thunk之类的异步库。

## Reducer ##
Reducer有点类似于MVC中Controller的功能，其作用就是通过用户传来的Action更新状态树。
Reducer都是纯函数，所以这里需要注意下函数式编程（fundamental pattern）的思想。
怎么写见[官方文档][8]。

写Reducer做好3点就可以了

 1. 按照状态树的结构拆分，根Reducer最好调用*combineReducers*
 2. 所有Reducer函数里的state**必须**要有初始值，在es6中很简单，直接在参数中赋值就行了，像其他编程语言一样。
 3. 为了符合fp的思想，**不要**在reducer中修改传入的state。如果要修改则应该返回一个全新的state。

总的来说reducer怎么写取决于状态树的设计，所以建议在写reducer前把状态树设计好，再对应状态树写函数。

## 总结 ##
虽然一开始搭建一个Redux的结构比普通项目要麻烦很多。但是之后再进行修改时就会发现项目结构十分的清晰，比起MVC中将管理状态、组件更新、网络请求等全部塞到Controller里，Redux把这些功能都分散到了Reducer、Store、Action Creator里，就显的很整洁了。

说实话理解Redux还是花了不少时间的，尤其是要解决*“这比起MVC有什么优势吗”*这个疑问。
我这里还是推荐[官方文档][9]([中文版][10])。


  [1]: https://github.com/Frezc/AnimeList-in-React-Redux
  [2]: /images/2016/03/653251524.png
  [3]: https://github.com/Frezc/react-redux-starter
  [4]: /images/2016/03/1929471663.png
  [5]: /images/2016/03/4278813248.png
  [6]: /images/2016/03/755933590.png
  [7]: /images/2016/03/3965136547.png
  [8]: http://redux.js.org/docs/basics/Reducers.html
  [9]: http://redux.js.org
  [10]: http://cn.redux.js.org/