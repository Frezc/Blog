---
title: 给RN的app添加widgets
tags: [react native, android, widgets]
categories: [develop]
date: 1466878320000
---

widgets应该是android平台上最有用的特性之一了吧，将应用的数据利用一个小视图嵌入其他应用（如桌面），可以快速地获得app的状态而不用启动app。

最近用react-native写了一个[todo app][1]，感觉将计划利用widgets直接在桌面上展现出来会十分的方便，于是就给这个app加了widgets。
当然rn没有给我们提供这方面的支持，毕竟是android端的东西，只能直接写原生了。虽然很久没写过原生android了，但是看看文档还是没有问题的。

<!--more-->

### appwidgets基础
首先可以看看[官方文档][2]吧，虽然它里面讲的东西在Android studio上点击New->Widget->App widget就能帮你生成好，不过看看文档了解下配置参数和AppWidgetProvider的原理还是不错的。

由于我这里要用到ListView，还是要按照文档的内容进行一下修改，主要就下面的5个文件（还要在AndroidManifest.xml注册接收者和服务）：

 - TodoWidget: AppWidgetProvider的子类，用来生成和更新根view。
 - TodoWidgetService: 用来生成ListView中每项视图的服务
 - todo_widget.xml: 每项视图的layout文件
 - todos_widget.xml: 根视图的layout文件
 - todo_widget_info.xml: 配置文件

这些按照文档里的写就可以了，不过有点需要注意的是如果你选了最小宽度为4格，minWidth会给你填上250dp，实际在android上运行的时候这个widget的最小宽度是3格。我去github上看到一个开源app里appwidiget的[配置文件][3]里看到4格写的是294dp，试了下这个数值没什么问题就直接用了。

### appwidgets里得到app的数据
appwidgets里使用的数据最好是持久化的，如果你想让widgets自动更新的话（widgets默认会有一个更新周期）。RN里提供了持久化api-AsyncStorage，那么原生app中怎么从中得到数据呢？

看看AsyncStorage的源码里的这条语句
```javascript
// Use RocksDB if available, then SQLite, then file storage.
var RCTAsyncStorage = RCTAsyncRocksDBStorage || RCTAsyncSQLiteStorage || RCTAsyncFileStorage;
```

可见一般情况下在android平台上是通过SQLite进行存取的。
另外在源码的`/ReactAndroid/src/main/java/com/facebook/react/modules/storage/ReactDatabaseSupplier.java`中我们可以得到数据库名、表名和表中每列的名称。实际上AsyncStorage只是将k-v值直接保存在一张表里而已。
那么从数据库中读取数据应该是很简单了，只要在每次更新时进行读取就行了，也就是在`RemoteViewsFactory`的`onCreate`和`onDataSetChanged`中读取。（ps：你当然可以通过网络请求来获取数据，rn使用了okhttp+fresco，你可以在app中直接使用这两个库）

由于我们在rn中保存时一般是转成json字符串的，所以读取后还需要解析成对象才能使用，这里用一个你会熟悉的解析库就行了。（RN自带了一个jackson-core库，不过这个用起来不是那么方便，你可以再引入jackson-databind就会好用很多了）

另外有一点要注意的是，app在没有保存任何东西的情况下，AsyncStorage对应的表是不会创建的，这时候直接读取这张表肯定会报错。
**解决方案**：捕获一下异常即可
```java
private String queryFromDB(SQLiteDatabase db, String key) {
    // try-with-resource need min-api 19
    Cursor c = null;
    try {
        c = db.rawQuery("select * from " + TABLE_CATALYST + " where " + KEY_COLUMN + " = ?", new String[]{key});
        if (c.getCount() > 0) {
            c.moveToFirst();
            String result = c.getString(c.getColumnIndex(VALUE_COLUMN));
            c.close();
            return result;
        }
    } catch (SQLiteException ignored) {
    } finally {
        if (c != null) c.close();
    }
    return "";
}
```

### app响应点击事件
设置点击事件的PendingIntent就按照文档的写法就可以了，如果要在rn中得到点击传递的参数的话，还要写一个原生模块来获取当前Activity的Intent对象并去除数据。

这个部分可以参考[react-native-system-notification][4]这个开源库里的写法，不过在点击时app是不会再前台运行的（目前来说是这样的），所以点击后只要startActivity并在Intent中带上`FLAG_ACTIVITY_CLEAR_TOP`这个flag就行了。然后在rn中通过原生模块获得Intent中带的数据。

具体完成的样子就是这样了
![todolite_widget.png][5]

点击后的跳转
![todolite_widget_click.jpg][6]

### [8.1更新] 关于RemoteViews的一个BUG ?
之前发现在appwidgets里如果description没有数据会显示`"No description."`，第一次滚动下来时会显示正确的结果，不过重新滚回去再滚下来显示就会出现异常。

Debug半天发现取得和生成的字符串没问题后，仔细观察了下异常数据，发现异常的数据似乎是前面项遗留的数据。我之前只是简单地判断了下有description时更新到视图中，于是我再加了条在没有description把显示值设置为`"No description."`，发现就没问题了。看起来是由于RemoteViews重用而导致的BUG，还真是个坑啊。


  [1]: https://github.com/Frezc/TodoLite
  [2]: https://developer.android.com/guide/topics/appwidgets/index.html
  [3]: https://github.com/benniaobuguai/opencdk-appwidget/blob/master/app/src/main/res/xml/widget_xml_news.xml
  [4]: https://github.com/Neson/react-native-system-notification
  [5]: /images/2016/06/2195390602.png
  [6]: /images/2016/06/4092440308.jpg