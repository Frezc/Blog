title: hexo使用经验分享
date: 2015-05-01 01:08:22
categories: 技术
tags: hexo
---
首先感谢[BranchZero](//loger.me)的帮忙

hexo的确是很方便的博客框架，更改主题，写文章，同步什么的几句命令就搞定了，对于不想花太多时间搞这个的人来说是个省时利器。

hexo的配置也是十分简单,按照[官网](//hexo.io)的文档可以十分轻松地解决
当然第一次用还是遇到了一些问题，我也通过某些方法解决了，在这里分享一下。

npm
---
墙内人民水深火热,这个不翻墙太难受了
我用的是[淘宝的NPM镜像](http://npm.taobao.org/)
速度非常不错, 按里面的配置就ok了
使用时将所有 *npm* 命令改成 *cnpm* 即可

主题
---
主题可以去[官网](http://hexo.io/themes/)或github上搜索hexo找到
我使用的是[yilia](https://github.com/litten/hexo-theme-yilia),毕竟简洁清晰。
不过这个主题也有点问题，就是没考虑好兼容https，如果使用https则需要修改掉模板中http的一些js库引用:
- 首先是mathjax的库引用,因为我觉得不会用到这个功能,所以直接在_config.xml中将其设为false.
- 然后是主题文件夹/layout/_partial/head.ejs中的
  {% codeblock lang:html %}
  <script src="http://libs.baidu.com/jquery/1.9.0/jquery.js"></script>
  {% endcodeblock %}
  改为https下的jquery库引用

Deploy
---
windows如果直接在目录下控制台中使用命令 *hexo d* 会出现错误he
{% codeblock lang:Bash %}
INFO  Deploying: git
INFO  Clearing .deploy folder...
INFO  Copying files from public folder...
events.js:85
      throw er; // Unhandled 'error' event
            ^
Error: spawn git ENOENT
    at exports._errnoException (util.js:746:11)
    at Process.ChildProcess._handle.onexit (child_process.js:1053:32)
    at child_process.js:1144:20
    at process._tickCallback (node.js:355:11)
{% endcodeblock %}
解决方法是使用Git Bash, 如果出现了Not a gitreposity错误, 则需要你手动在.deploy_git文件夹下创建git库, 然后就能上传了。
远程git库地址在_config.yml中指定(详情见文档), 建议使用ssh地址, 这样配置好密钥后每次提交就不需要输入验证信息了。

提升访问速度
---
hexo模板生成的文件基本是不变的, 可以将这些文件放到国内服务器上来增加访问速度。修改模板, 将引用地址改掉, 然后将生成文件放到服务器上就ok了。
具体是由[BranchZero](//loger.me)帮忙的 ：D.

