---
title: webpack和webpack-dev-server的配置备忘
tags: [webpack, webpack-dev-server]
categories: [develop]
date: 1470493020000
---

自从上次用webpack写web应用感觉已经过了一段时间了，这次重新拾起又花了不少时间。

为了下次能更快地使用webpack开发，决定写篇文章把配置的问题记录下来。

<!--more-->

### webpack基本配置

 - devtool: 在开发中可以使用`'eval'`(打包速度快)、`'inline-source-map'`(打包速度慢，但在浏览器里能直接查看编译前的代码)等值；生成环境中不要设置或设为`false`

 - entry: 结构可以是
    ~~~javascript
    entry: {
        app: APP_DIR + '/app.js',
        vendor: APP_DIR + '/scripts/vendor.js',
        login: [
            APP_DIR + '/login.js'
        ]
    }
    ~~~


 - output: 注意下`publicPath`，要设置为打包后资源的url路径

 - module: 注意下scss的loaders的写法
    ```javascript
    // 开发中
    loaders: ['style', 'css', 'postcss', 'sass']
    
    // 生成环境 导出到一个css文件
    loader: ExtractTextPlugin.extract('style', ['css', 'postcss', 'sass'])
    ```


 - resolve: 可以用`extensions`来指定`import`时可以省略的后缀名；可以用`alias`指定从非npm引入的库，如`jquery: path.resolve(__dirname, './bower_components/jquery/dist/jquery.js')`，这样在`import`时可以替换引用路径

 - externals: 指定从全局引入的库，如`jquery: "jQuery"`，这样在`require('jquery')`时会引入`jQuery`对象

### 常用插件

 - ProvidePlugin: 定义一些在import时能自动引入的变量，如定义了`$: 'jquery'`后，可以在文件中直接使用$，webpack可以自动帮你加上`var $ = require('jquery')`

 - CommonsChunkPlugin: 将多个entry里的公共模块提取出来放到一个文件里，这个插件可以用来将库和自己代码分离

 - DllPlugin: 将一些模块预编译，类似windows里的dll，可以在项目中直接使用，无需再构建。注意要在output中指定`library`，并在DllPlugin中指定与其一致的`name`，在有多个入口时可以使用`[name]`和`[hash]`来区分，因为这个参数是要赋值到global上的，所以这里使用`[hash]`不容易出现变量名冲突的情况

 - DllReferencePlugin: 引用之前打包好的dll文件，注意下context参数，这个应该根据manifest.json文件中的引用情况来赋值，如果引用的都是npm安装的库，这里就填项目根目录就好了

 - NoErrorsPlugin: 在打包时不会因为错误而中断

 - DefinePlugin: 可以定义编译时的全局变量，有很多库（React, Vue等）会根据`NODE_ENV`这个变量来判断当前环境。为了尽可能减少包大小，在生产环境中要定义其为`JSON.stringify("production")`

 - optimize.UglifyJsPlugin: 配置压缩代码，如
    ```javascript
    compress: {
        unused: true,
        dead_code: true,
        warnings: false
    }
    ```


 - optimize.OccurrenceOrderPlugin: 可以减少文件大小

 - optimize.DedupePlugin: 可以减少重复文件数

 - ExtractTextPlugin: 可以将所有css文件打包到一个css文件中，配置见loader

### webpack-dev-server和react-hot-loader的相关配置

如果只进行客户端开发，不适用nodejs渲染的话，推荐安装webpack-dev-server CLI，可以省去很多配置。

首先看看cli里常用的几项配置：

 - --port=8080：这项指定了服务器端口，相当于在entry中加上`webpack-dev-server/client?http://0.0.0.0:8080`，前者是后者的简便用法，注意这两个不要重复。

 - --hot：开启热替换功能。如果要使用react-hot-loader，这项是必须要开启的；如果只是想在更新代码后自动刷新页面，则不需要。这项等同于在`plugins`中添加`new webpack.HotModuleReplacementPlugin()`，同样注意不要重复。

 - --inline：这个的功能是为了能在你自己的测试服务器上获取的html页面中获取webpack-dev-server动态生成的js文件，基本上如果要用webpack-dev-server这个是必要的。详情说明见[文档][1]。这个参数会在entry里加上`webpack/hot/dev-server`，注意不要重复了。
    虽然加了这项就能变更后自动刷新页面了，但是要用hmr还有几点要注意：
     1. output.publicPath一定要使用完整的url，如`"http://localhost:8080/dist/"`，端口要和wds相同，不然会出现跨域的错误提醒。
     2. 在html页面中当然也要以完整的url来引入。

如果要写同构应用的话，使用[webpack-hot-middleware][2]并按照文档的写法就可以了。


  [1]: http://webpack.github.io/docs/webpack-dev-server.html#combining-with-an-existing-server
  [2]: https://github.com/glenjamin/webpack-hot-middleware