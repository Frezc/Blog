---
title: React的服务端渲染
tags: [react, server render]
categories: [develop]
date: 1460827140000
---

最近在使用React来做一个收藏夹类似的网站，同时也是为了学习一下前端技术，于是就尽可能的使用了流行的框架。

[项目链接][1]
这个项目中使用了React + Redux + React-router + babel + webpack + scss，来构建了一个同构应用。虽然同构应用并不是十分必要的，不过为了尝试下新技术还是尽可能地去用了。

后端由于一开始就考虑用Laravel了（那时候还不知道有同构应用这东西），而且直接丢给同学做了，所以并没有做到完全地同构，仅仅只是在渲染页面上同用一套代码。（由于不是用NodeJs，也就没使用GraphQL+Relay了）。

<!--more-->

## 在什么地方使用 ##
服务端渲染能带的好处就是对搜索引擎友好，所以对于一般的SPA是不必要的。
所以在资源页面（用户信息页面、资源列表页面、资源详情页面等）上做好服务端渲染就行了。在一些编辑页面上就没什么必要了。

## Redux ##
如果要使用React来做服务端渲染，我觉得像Redux这样的库是有必要的。
Redux使用单一的状态树，传回初始状态时会十分方便，将下面的标签放到你的脚本标签前就行了。

```html
<script>
  window.__INITIAL_STATE__ = ${JSON.stringify(initialState)}
</script>
```

当然这里不要忘了过滤标签，我这里使用的方法是

**[Server]**

```javascript
let initState = JSON.stringify(store.getState());
// 使用encodeURIComponent过滤掉特殊字符
let page = renderFullPage(initView, encodeURIComponent(initState));
```

```html
// 别忘了引号
<script>window.__INITIAL_STATE__ = "${initState}"</script>
```


**[Client]**

```javascript
const initState = window.__INITIAL_STATE__;
const store = configureStore(JSON.parse(decodeURIComponent(initState)));
```


## 服务端渲染时的生命周期 ##
忘了在哪看到服务端渲染时不会执行React组件的生命周期方法了，实际上`componentWillMount`这个方法还是会执行的，所以在这个方法内还要注意下执行环境。

## 配合React-Router和共用Action Creator ##
可以使用React-Router提供的match来匹配路由表，然后通过回调函数得到路由信息，在路由信息中我们是可以得到对应的组件的，所以我们可以把调用的对应Action Creator（用过API获取数据）放到这个组件的一个静态方法里直接调用，这样我们就可以对所有路由一视同仁了。

相信大多数人会把网络请求放到Action Creator中来写，那么我们就可能懒得再去对服务器端写API请求了，而是直接dispatch这个Action Creator。作为同构代码这个Action Creator就需要注意下运行环境了，首先当然是使用`isomorphic-fetch`这个库，当然你可以自己判断当前环境来使用浏览器或node上的`fetch`。

## 服务器端的同步请求 ##
我这里的**同步**指的是服务端等待API请求结束后再返回页面。
在客户端只要在请求结束后进行异步地更新状态就好了，在服务端得等待这次请求（可能会有多个请求）完全结束才行。很多人会想到回调函数，不过给Action Creator加个回调函数的参数显得不太美观，而且似乎不能处理多个请求的情况。这里既然已经使用了`fetch`，那么干脆就使用es6中的`Promise`来处理。

1、首先在需要预渲染数据的页面里实现一个相同名称的静态方法来调用Action Creator。
```javascript
// server fetch
static fetchData = (params) => {
  // 注意要返回
  return fetchUserNetwork(params.id)
};
```

2、然后在这个Action Creator中调用Api，同样要注意返回`fetch`返回的`Promise`
```javascript
export function fetchUserNetwork(id) {
  return (dispatch) => {
    // 这里调用的相当于 fetch(url)
    return Api.userInfo(id)
      .then(response => {
        if (response.ok) {
          // 结果中有其他耗时处理的Promise同样要返回
          return response.json().then(json => {
            dispatch(fetchUserSuccess(json));

            // 让服务端能判断是否请求成功
            return response.status;
          });
        } else {
          return response.status;
        }

      })
      .catch(error => {
        return 'error';
      });
  }
}
```

3、在服务端我们将所有的`Promise`使用`Promise.all`方法放到一个`Promise`中
```javascript
function fetchComponentsData(dispatch, components, params) {
  let fetchData = components.reduce((pre, cur) => {
    return Object.keys(cur).reduce((acc, key) => {
      return cur[key].hasOwnProperty('fetchData') ? acc.concat(cur[key].fetchData) : acc;
    }, pre)
  }, []);
  const promises = fetchData.map(fetch => dispatch(fetch(params)));
  return Promise.all(promises);
}
```

4、最后我们在这个`Promise`的`then`和`catch`中将组件渲染啊成string再返回就可以了。

## 返回不同的状态码 ##
如果需要在返回页面时返回相应的状态码的话，只要像上面在`fetch().then`里`return response.status`。
然后就能通过`Promise.all`创建的`Promise`的`then`中得到一个状态码的数组了。
```javascript
fetchComponentsData(store.dispatch, renderProps.components, renderProps.params)
      .then(status => {
        console.log('statu', status[0])
      }
```

## 其他 ##
判断当前环境的函数
```javascript
export const isBrowser = new Function("try { return this === window; } catch(e) { return false; }");
export const isNode = new Function("try { return this === global; } catch(e) { return false; }");
```

  [1]: https://github.com/Frezc/Share-Favors-App