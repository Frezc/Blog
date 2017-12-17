title: 使用intellij的模板（live template）
date: 2015-06-07 20:42:45
categories: develop
tags:
- intellij idea
- live template
---
intellij的live template功能十分强大，可以简化很多重复的代码，可以说是使用好intellij必会的一个东西。

##什么是live template
live template相当于一个代码块的缩写
在编辑代码的过程中按下`Ctrl+j`可以查看当前上下文中可用的所有模板，下面是一些可能常用的模板（可以不用上面的快捷键，直接打出缩写会出现提示）。
**psvm**:
```java
public static void main(String[] args){

}
```
**psfi**、**psfs**:
```java
public static final int
public static final String
```
**sout**、**soutv**:
```java
System.out.println($END$);
System.out.println("$EXPR_COPY$ = " + $EXPR$); //这里是指打印类中的一个变量
```

##live template是如何生成的
在`Settings -> Editor -> Code Style -> Live Templates`里可以查看并修改所有的模板，当然也能自己创建。
我们先看看**output**下的**soutm**是怎么写的
```java
System.out.println("$CLASS_NAME$.$METHOD_NAME$");
```
这个模板是用来生成打印当前类和方法名的，这里面有两个变量**$CLASS_NAME$**和**$METHOD_NAME$**，点击右边的**Edit variables**来看看它们是怎么定义的。
___
在**Edit Template Variables**对话框中可以看到这两个变量，通过每列的标题就知道是干什么的了，这里主要注意两点：
1. 变量是有顺序的，idea会按顺序来生成这些变量，所以注意依赖关系。
2. Expression栏可以填双引号包含的字符串、其他已经定义的变量和预定义的函数，从下拉列表里可以选择预定义的函数。函数说明请参考[官方文档](https://www.jetbrains.com/idea/help/edit-template-variables-dialog.html#functions)

在预定义函数中有个十分强大的函数`groovyScript("groovy code")`，它可以执行groovy语句。比如模板**soutp**:`System.out.println($FORMAT$);`这里的变量`$FORMAT$`对应的Expression是
```groovy
groovyScript("'\"' + _1.collect { it + ' = [\" + ' + it + ' + \"]'}.join(', ') + '\"'", methodParameters())
```
稍微解释下这句，方法`methodParameters()`返回了当前方法参数的数组，这个数组对应着前面groovy语句中的_1，然后遍历_1，生成类似`"xxx = [" + xxx + "]...`的java代码，多个之间使用`,`隔开，这句实际生成的代码如下:
```java
System.out.println("user = [" + user + "], isSave = [" + isSave + "]");
```

##自定义live template
这里我自定义了一个live template
**lim**:`Log.i("$END$","$CLASS_NAME$.$METHOD_NAME$:" + $METHOD_PARAMETERS$);`
这个模板是用来生成将当前方法加参数名与值打印到Log的方法。其中
**$CLASS_NAME$**:`className()`
**$METHOD_NAME$**:`methodName()`
**$METHOD_PARAMETERS$**:`groovyScript("'\"' + _1.collect { it + ' = [\" + ' + it + ' + \"]'}.join(', ') + '\"'", methodParameters())`
**$END$**:上面的变量生成结束后光标停留位置
建议把**Skip if defined**勾选，这样就不会询问你是否要更改上面的变量了。

####优化
上面的模板在输入完TAG后还要手动把光标移到语句尾，显得很麻烦，有没有办法再输入完TAG后回车直接进入下一行呢？ 当然是可以的，修改成如下即可：
```java
Log.i("$TAG$","$CLASS_NAME$.$METHOD_NAME$:" + $METHOD_PARAMETERS$);
$END$
```
新增的**$TAG$**变量的Expression可以填你的初始值，如`"Test"`，如果你需要修改就不要勾选**Skip if defined**。这样在输入玩TAG后直接回车就能跳转到下一行了，是不是十分方便。

![lim](https://frezc.github.io/2015/06/07/use-intellij-live-template/lim.png)