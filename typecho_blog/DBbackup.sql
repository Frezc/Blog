-- --------------------------------------------------------
-- 主机:                           115.28.68.215
-- 服务器版本:                        5.5.44-MariaDB - MariaDB Server
-- 服务器操作系统:                      Linux
-- HeidiSQL 版本:                  9.3.0.4998
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 导出  表 typecho.typecho_comments 结构
CREATE TABLE IF NOT EXISTS `typecho_comments` (
  `coid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cid` int(10) unsigned DEFAULT '0',
  `created` int(10) unsigned DEFAULT '0',
  `author` varchar(200) DEFAULT NULL,
  `authorId` int(10) unsigned DEFAULT '0',
  `ownerId` int(10) unsigned DEFAULT '0',
  `mail` varchar(200) DEFAULT NULL,
  `url` varchar(200) DEFAULT NULL,
  `ip` varchar(64) DEFAULT NULL,
  `agent` varchar(200) DEFAULT NULL,
  `text` text,
  `type` varchar(16) DEFAULT 'comment',
  `status` varchar(16) DEFAULT 'approved',
  `parent` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`coid`),
  KEY `cid` (`cid`),
  KEY `created` (`created`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- 正在导出表  typecho.typecho_comments 的数据：0 rows
/*!40000 ALTER TABLE `typecho_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `typecho_comments` ENABLE KEYS */;


-- 导出  表 typecho.typecho_contents 结构
CREATE TABLE IF NOT EXISTS `typecho_contents` (
  `cid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `slug` varchar(200) DEFAULT NULL,
  `created` int(10) unsigned DEFAULT '0',
  `modified` int(10) unsigned DEFAULT '0',
  `text` text,
  `order` int(10) unsigned DEFAULT '0',
  `authorId` int(10) unsigned DEFAULT '0',
  `template` varchar(32) DEFAULT NULL,
  `type` varchar(16) DEFAULT 'post',
  `status` varchar(16) DEFAULT 'publish',
  `password` varchar(32) DEFAULT NULL,
  `commentsNum` int(10) unsigned DEFAULT '0',
  `allowComment` char(1) DEFAULT '0',
  `allowPing` char(1) DEFAULT '0',
  `allowFeed` char(1) DEFAULT '0',
  `parent` int(10) unsigned DEFAULT '0',
  `views` int(10) DEFAULT '0',
  PRIMARY KEY (`cid`),
  UNIQUE KEY `slug` (`slug`),
  KEY `created` (`created`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- 正在导出表  typecho.typecho_contents 的数据：10 rows
/*!40000 ALTER TABLE `typecho_contents` DISABLE KEYS */;
INSERT INTO `typecho_contents` (`cid`, `title`, `slug`, `created`, `modified`, `text`, `order`, `authorId`, `template`, `type`, `status`, `password`, `commentsNum`, `allowComment`, `allowPing`, `allowFeed`, `parent`, `views`) VALUES
	(2, '关于', 'start-page', 1446314280, 1451492577, '<!--markdown-->以前的博客地址[frezc.github.io][1]。\r\n近期喜欢上了Unity的游戏开发，如果你有好的点子可以和我分享一下。\r\n欢迎有相同爱好的好友加我qq504021398，邮件(frezcw@gmail.com)联系也ok。\r\n\r\n\r\n  [1]: https://frezc.github.io', 1, 1, NULL, 'page', 'publish', NULL, 0, '1', '1', '1', 0, 708),
	(5, '第一篇博客', '5', 1446430800, 1446432137, '<!--markdown-->自己撸了个域名后就决定换个地方写博客了，以前的博客[点这访问](https://frezc.github.io)。\r\n关于为什么要换地写呢，主要还是因为电脑装win10的时候把d盘格式化掉了，原来配置了挺长时间的博客配置（改了文件能用https访问，还用七牛做了国内的cdn）都没了，我也没劲再来一遍了，于是就干脆试试typecho吧。\r\n\r\n\r\n<!--more-->\r\n\r\n---\r\n从上学期Hackthon比赛后我就没怎么写过Android了，一直在学cocos2d-js和unity，毕竟我对游戏开发还是比较感兴趣的。\r\n现在只用Unity了，毕竟比起cocos包含了很多方便的工具，自己做做游戏的话会省事很多。\r\n近期为了创新实践的项目还写了个api服务器，不得不说Laravel框架在熟悉了后还是十分简单的，对于我这种没写过php的人都能写的行云流水啊。\r\n', 0, 1, NULL, 'post', 'publish', NULL, 0, '1', '1', '1', 0, 1314),
	(6, '近期的一些琐事', '6', 1447002060, 1447005013, '<!--markdown-->近几个星期真是莫名的忙啊，积累了不少事可以写写了，这篇文章就当做一个记录了。\r\n\r\n\r\n<!--more-->\r\n\r\n\r\n----------\r\n## 创新实践课的安卓项目 ##\r\n这些项目对于个人来说并不是十分积极去参与的，不过既然都当了组长还是要做好的。带着其他几个完全不懂的还是要干很多事啊。于是呢，我就干干设计app结构，设计api，写文档，然后写服务端（另一组不会写api，我就自己做了），现在还要操心app这边的网络请求管理。。\r\n\r\n服务器端被某人推荐用Laravel+jwt+dingo去写了。laravel框架还是非常方便的，对于我这种没写过php但知道服务器端如何处理请求的人来说看完文档也就会做了；dingo这个插件并没有某人说的那么方便，虽然能直接返回数据自动生成json，但会像下面这样：\r\n\r\n    {Entity: {"xx": "xx", ...}}\r\n在外面多嵌套了一层，这样在app上解析时就不太方便了，于是最终还是使用`response()->json()`的方式。\r\n\r\n## 机器视觉课的小组项目 ##\r\n对于这种课都要做个项目我表示很吃惊，说实话我宁愿考试呢。其中翻译一篇长的要死的论文+做ppt就算了，还要小组做项目，我还是挺后悔选这门课的。不过既然不能换了，那还是要好好做的。\r\n\r\n项目的题目是通过摄像头来监视交通系统，我选这个主要还是因为没有现成的加上挺有意思这两点吧。不过这样我的组员表示完全不懂了，想想到最后应该还是要我来设计算法吧。\r\n\r\n这个项目我觉得还是挺有意思的，在十字路口通过双摄像头图像识别车辆的三维空间信息，然后就能十分精确的判断是否出现事故了，识别误差主要在图像到三维信息上。这个项目其实就一个问题，如何通过摄像机图像判断车辆中心点和矩形区域。这个我觉得可以使用模板对比的方法实现，但是对于一个尺寸的车辆还好，车辆模型一多工程量就会非常大了，总之还是有取巧的方法的，能给老师看看就够了。\r\n\r\n## 软考 ##\r\n吐槽下周六的软考吧。\r\n基础知识考的真是泛，计组、操作系统、数据库、软件工程、编译原理、设计模式、数据结构、算法分析、计网，我感觉以上全都有考到，对了还有门英语。虽然多，但都是选择题，应该能及格吧。\r\n\r\n应用技术的考试我觉得就有意思多了，考的是系统设计（数据流图）、数据库设计（ER图）、软件设计（用例图、类图）、算法（很简单的求最长公共子串），还有道拿策略模式说话，实际就是简单的面向对象的多态编程。总的来说题还是出的不怎么样，有明显错误。\r\n\r\n## 其他 ##\r\n能把薄膜键盘敲出机器键盘的声音的室友早上8点起来敲代码这事已经在督促我早睡早起了！\r\n不然早上10点前我肯定睡不着了。（わらい）', 0, 1, NULL, 'post', 'publish', NULL, 0, '1', '1', '1', 0, 1427),
	(7, '自己在Android开发中碰到的问题和解决办法', '7', 1447087860, 1447091190, '<!--markdown-->说起来android我已经半年多没碰过了，这次为了让小组成员会写网络请求和用design库，我还是自己动手写了网络请求的封装类和一个design库的demo。当然，还是不免遇到了一些问题。\r\nps: 因为是前几天的事，也没截图，就随便记录一下啦。\r\n\r\n<!--more-->\r\n\r\n## 项目升级 ##\r\n看idea总提示我项目所用的支持库需要升级，于是第一件事当然是把`build.gradle`里引用库的版本号都改到最新了，还添加了design库的引用，然后就报错了。\r\n\r\n一共有两个错误\r\n\r\n 1. 资源重定义：搜了下发现是库里的命名冲突了，我这个项目中是`com.zzt.inbox`这个库和`appcompat-v7`间的冲突，前者并不会使用了，于是就直接移除了。\r\n 2. 资源未找到：这个还是因为我只将支持库升级到了`23.1.0`，而sdk版本还停留在22的原因，将其改为23就ok了。\r\n\r\n## Intellij Idea 15 ##\r\n看到idea升级到15了就马上去装了15，打开后直接是一个错误：jre未找到。我顺着错误中给出的路径：`\\jre\\bin\\java.exe`浏览了一下，发现这个路径就是错误的，实际上是`\\jre\\jre\\bin\\java.exe`。不知道我是不是个例。\r\n\r\n当然解决方法很简单，在系统中安装一个自己的java就ok了，我由于没有安装32位的java所以idea自动使用了自带的java。最后我直接使用64位的idea就完全没问题了。\r\n\r\nidea15的新特性我了解的不多，不过最直观的感受就是打开时稍微快了一点吧。\r\n\r\n## Context的空指针问题 ##\r\n我在一个`Activity`中在某个变量初始化时调用了`this.getApplicationContext()`结果出现了空指针问题，当时我把这个函数放在`onCreate()`里后就好了。\r\n\r\n后来我看到一篇关于`Context`的[博客](http://blog.csdn.net/guolin_blog/article/details/47028975)，才明白是怎么回事。\r\n\r\n![context.png][1]\r\n\r\n从上面这张图可以看出`Activity`只是一个装饰者，通过源码可以知道`getApplicationContext()`调用的还是其内部的一个`ContextImpl`对象。而这个对象是通过`attachBaseContext(Context)`这个函数传递给`Activity`的，所以在这个函数调用之前去调用`getApplicationContext()`自然会出现空指针异常了。\r\n\r\n  [1]: http://frezc.com/usr/uploads/2015/11/74545713.png', 0, 1, NULL, 'post', 'publish', NULL, 0, '1', '1', '1', 0, 1330),
	(8, 'context.png', 'context-png', 1447090879, 1447090879, 'a:5:{s:4:"name";s:11:"context.png";s:4:"path";s:33:"/usr/uploads/2015/11/74545713.png";s:4:"size";i:12477;s:4:"type";s:3:"png";s:4:"mime";s:9:"image/png";}', 1, 1, NULL, 'attachment', 'publish', NULL, 0, '1', '0', '1', 7, 0),
	(9, '做一个多网站的动画排行榜吧', '9', 1447948500, 1448015149, '<!--markdown-->起源是以前看过的一个[B站视频][1]。\r\n视频里统计了中国的[Bangumi][2],日本的[Sati][3]和欧美的[Ann][4]的评分，并取三者平均分进行排名。\r\n\r\n总的来说，这个排名还是挺靠谱的，所以我也想做一个这样的排名，利用网页的形式展示并能够定时地更新。\r\n\r\n\r\n<!--more-->\r\n\r\n\r\n## 利用爬虫抓信息 ##\r\n经某人推荐用了[Scrapy][5]这个库来写爬虫。\r\n首先很简单通过每个网站的列表可以得到动画名和url, 由于ann上默认是英文名，所以必须去爬取每个动画的详情页来获得日文名，sati和bgm上都是能直接得到日文名的，所以并没有去爬取详情页。\r\n这些存入数据库后就开始下一步\r\n\r\n## 统一信息 ##\r\n这是最麻烦的一步了，因为各个站点的命名并不统一，就算你使用了很多的规则去匹配也不可能做到100%准确的，还是需要人工检查。虽然如此，当然能用程序匹配得越多越好了。\r\n\r\n匹配当然需要通过原日文名，于是我观察了一下sati和bgm上的日文命名区别，写了一些规则：\r\n - "ミス・モノクローム -The Animation-" 在SATI中没有 \'-\' 符号\r\n - \'!\' 在SATI上是 \'！\', 在ann和bgm上不确定\r\n - bgm可能会比sati多个副标题 如 \'攻殻機動隊ARISE\'系列\r\n - 标题间的空格可能会不相同\r\n - sati会在剧场版动画名前加上 \'劇場版\' , 而bgm不会\r\n - sati可能会在标题尾加上括号并有补充内容\r\n\r\n当然这些并不是很全，实际在匹配时用了精确到模糊的查找。\r\n - 将原标题中的\'劇場版\'和前后空格去掉，将一些全角符号替换成半角的\r\n - 精确查找，考虑到有括号补充内容的问题，也同样将括号去掉的内容和括号内的内容进行精确的查找\r\n - 考虑到标题中的特殊字符存在或有其他替代的不确定性，先将它们使用\'_\'通配符进行匹配，匹配的符号\r\n`re.compile(ur\'[-+・\\\'!-:.\\(\\)\\s]\')` ， 这里还少了个 \'～\'，因为使用正则表达式替换会出现替换两次的问题，我就使用replace函数进行替换了。\r\n - 考虑到空格的不确定性，直接使用\'%\'通配符替换了标题中的所有空格\r\n - 考虑到副标题的问题，在标题首尾加上\'%\'通配符\r\n - 最后再找不到就来一次将特殊字符全部替换成\'%\'的匹配\r\n\r\n前后最多匹配10次，如果在匹配中出现了多个结果就直接手工填充了，[代码][6]。（注意下，最好将查找的字段添加上索引，不然可能要搜索个几分钟）\r\n\r\n除了标题其实还有一个特征值：放送时间。但是通过bgm网页上获取的放送时间是中文形式的，需要去format才能和其他网站匹配。后来一想bgm不还有api吗，看了下api的属性里果然有air_date的标准形式，也可以拿来筛选。\r\n\r\n## 目前的进度 ##\r\n第一次用程序匹配完，4000多项数据填了3000多项，结果还是不够理想，毕竟剩下1000项数据也没法手工填。\r\n于是我干脆就先删除无用数据吧，sati上评论数少于20的就不去考虑了，删了一圈，并用放送时间进行了一圈匹配（将时间相同的输出，手工填），剩下1000多项数据，其中85项未填，看了下未填项，还真是有很多坑啊。\r\n\r\n![bad_name.png][7]\r\n\r\n（第一条全角空格没考虑，第二条两个网站的字竟然不一样，第三条sati上使用了汉字而bgm上的日文名使用了平假名）\r\n\r\n目前还需要手工把剩下的数据填上了。\r\n\r\n  [1]: http://www.bilibili.com/video/av1184434/\r\n  [2]: http://bgm.tv\r\n  [3]: http://www.animesachi.com/\r\n  [4]: http://www.animenewsnetwork.com/\r\n  [5]: http://www.scrapy.org\r\n  [6]: https://github.com/Frezc/Anime-Statistics-Crawl/blob/master/anime_statistics/db_filter/BGMNameFilter.py\r\n  [7]: http://frezc.com/usr/uploads/2015/11/3870579292.png', 0, 1, NULL, 'post', 'publish', NULL, 0, '1', '1', '1', 0, 931),
	(10, 'bad_name.png', 'bad_name-png', 1448014771, 1448014771, 'a:5:{s:4:"name";s:12:"bad_name.png";s:4:"path";s:35:"/usr/uploads/2015/11/3870579292.png";s:4:"size";i:18946;s:4:"type";s:3:"png";s:4:"mime";s:9:"image/png";}', 1, 1, NULL, 'attachment', 'publish', NULL, 0, '1', '0', '1', 9, 0),
	(11, '做个动画排行榜 - 标题匹配', '11', 1448197620, 1451029025, '<!--markdown-->上次写了篇做排行的[文章][1]，然后做到现在，匹配不同网站的信息还是一大难点啊，做到现在，剩下的数据还是手工去处理会准确且快一些。\r\n\r\n这次在将Ann与Sati信息匹配时使用了与Bgm和Sati匹配时不同的方法。\r\n\r\n\r\n<!--more-->\r\n\r\n## Ann的信息匹配 ##\r\n这次匹配的核心是ratio，jaro和jaro_winkler这3个字符串相似度算法，利用这些算法很明显可以解决之前存在的标题中有单个字符不匹配的情况。这次使用的[一些规则][2]。\r\n这里原先Ann的日期获取缺失了很多，后来看了几个页面后才发现是日期会有不同的结构，重新爬取了一遍（[代码][3]），顺便做了次筛选，分辨出评价人数过少的番剧。\r\n这次爬取后，日期基本就完整了，使用了日期比对后匹配率一下子就上来了，最后只剩85项未匹配。这些就直接手工解决了。\r\n\r\n最后一个问题就是有些番剧在一个网站上是合并的，而在其他两个网站上是分开的。这里我原本是直接留下第一季的信息，但是后来发现还挺多的，还是将多个url用逗号隔开保存了，到时候取分时直接计算多个url的平均分了。\r\n\r\n## 网站计划 ##\r\n网站我目前的想法是，后端api服务器Laravel，前端Semantic UI + Vue.js。\r\n不过目前时间太少，这个计划会挺慢的。\r\n\r\n## 其他 ##\r\n因为python没有和c那样的for循环，所以在项目中一直使用while循环进行迭代，这次加了个continue，发现就出bug了。于是又找了下资料，才知道python中写索引迭代要这么写\r\n\r\n    for i in range(start, end):\r\n        your code\r\n\r\n相当于\r\n\r\n    for(i=start; i < end; i++){\r\n        your code\r\n    }\r\n\r\n\r\n  [1]: http://frezc.com/archives/9/\r\n  [2]: https://github.com/Frezc/Anime-Statistics-Crawl/blob/master/name_compare_rule.md\r\n  [3]: https://github.com/Frezc/Anime-Statistics-Crawl/blob/master/anime_statistics/spiders/ANNConsSpider.py', 0, 1, NULL, 'post', 'publish', NULL, 0, '1', '1', '1', 0, 803),
	(12, '动画的排行榜 - 页面实现', '12', 1451017080, 1451029013, '<!--markdown-->离上篇文章都已经一个多月了啊，最近都在玩mho，也没什么时间来做这个。不过目前还是把基本的功能都给实现了，做了一个展示页面。\r\n\r\n和以前说的一样，后端是使用[Laravel](https://laravel.com/)框架实现的api服务器，前端是用[vue.js](http://cn.vuejs.org/)和[semantic-ui](http://semantic-ui.com/)实现的页面。\r\n[点此访问][1]\r\n\r\n\r\n<!--more-->\r\n\r\n## 后端 ##\r\nLaravel也不是第一次用了，还是挺熟悉的，不过也碰到过一些问题，这里记录一下。\r\n\r\n - 数据库配置：api返回错误信息`The Response content must be a string or object implementing __toString()`时，首先还是要检查一下数据库的配置是否正确。我这里将动漫排行的数据放在了一个独立的数据库中管理，所以要在laravel里额外配置不同的数据库连接，这里会十分容易出错。\r\n - 跨域请求：使用ajax请求不同域名的api时需要注意下跨域请求的问题，为了能进行跨域请求，返回的header里需要有`Access-Control-Allow-Origin`这一项来确定允许跨域请求的域名。我这里为了方便，让所有api能让所有域名访问（方便本地测试），直接修改nginx的配置文件，在`location`中添加一条`add_header Access-Control-Allow-Origin *;`就ok了。\r\n\r\n## 前端 ##\r\n前端的css库使用了某人推荐的semantic-ui，我也没用过bootstrap，所以用什么都无所谓，不过semantic比起bootstrap的资料真是少。\r\n然后是vue.js，数据的双向绑定和定义组件都是非常好用的，我没有用过其他类似的库，所以也不好比较。\r\n\r\n虽然没有必要，但还是试着用了webpack管理项目，这个库简单来说就是将一堆js和css文件打包的一个js文件中，在发布时你的页面中只要引用一个打包后的js文件就行了，对于非常复杂的单页应用来说，这是个能减少项目复杂度的工具。\r\n\r\n然后讲讲问题\r\n\r\n - 渲染速度：原本我想把1000多项数据直接展示的，不过渲染速度还是有限，vue.js渲染1000项的列表也得要接近2秒的时间，于是想想还是分页了。\r\n - 提示框：在页面中使用了semantic的提示框组件，不过使用的时候仅仅在html中添加`data-title`和`data-content`并没有什么用，还要调用这些节点的`popup()`函数。但是节点都是通过vue.js之后动态生成的，那要怎么在渲染完成后调用呢？\r\n这里可以使用vue.js提供的自定义指令实现，注册一个指令，在`bind`接口中调用就ok了。\r\n\r\n## 其他 ##\r\n本来想借用下Bangumi的图片的，不过没法跨域请求，那就没办法了，之后有空就去爬取一遍吧。\r\n\r\n剩下还有个留言评论的模块，没时间就用多说来做了。\r\n\r\nPS: 最近一直在玩mho 华东一 隐士之森 id: 心悦会员 欢迎找我玩\r\nPS2: steam也开始打折了，不过启示录2怎么就第一章打折啊，卡表还是坑。\r\n\r\n\r\n  [1]: http://statistics.frezc.com/anime-rank.html', 0, 1, NULL, 'post', 'publish', NULL, 0, '1', '1', '1', 0, 99),
	(13, '用SVG画一个笑脸男图标', '13', 1451492580, 1451669194, '<!--markdown-->自从看完攻壳的第一季后就想自己做个会动的笑脸男的矢量图图标了，最近花了点时间终于搞定了。\r\n下面我会谈谈网页上矢量图该怎么写。\r\n[预览][1]。[源代码][2]。\r\n\r\n\r\n<!--more-->\r\n\r\n## 制作矢量图的工具 ##\r\n虽然在网页上是用代码实现的，但是设计还是需要一个能画矢量图的工具的。\r\n可以用Illustrator(Ai)或者一个在线的工具就可以了。我这里直接用了别人用ai设计的矢量图，所以对详情设计也不太了解。\r\n\r\n然后使用一个越方便越好的画svg的js库就行了。原本看网上大家都推荐使用raphael.js，但是这个库没有画路径文字的方法，于是果断找了另外一个库svg.js，这个库能解决这个问题，还比raphael.js要小。\r\n\r\n## 用代码画矢量图 ##\r\n笑脸男的图像里基本上都是使用路径画好的，所以只要使用画路径的方法就行了。关于路径，w3有一套[规范][3]，只要能看懂这里的写法就好，这是所有库都通用的标准写法。\r\n其中可能让人困惑的一点就是arc画法了（其实规范里的图已经说明的挺好了）。它是提供当前点（起始点）、x、y上的半径、旋转角度、large-arc-flag、sweep-flag和终点来确定一个弧的。其中large-arc-flag指是否画大一点的弧，sweep-flag指从起点到终点是否为顺时针画线。\r\n\r\n对路径熟悉后就可以把你设计图给搬进代码里了，如果你的编辑器能直接生成w3标准的代码的话就再好不过了。\r\n\r\n## 转动的文字 ##\r\n文字的部分其实有点麻烦，麻烦在做动画上。\r\n\r\n    var t1 = paper.text(s);\r\n    t1.fill(\'#23498C\').font({size: 50, \'letter-spacing\': 2.3, weight: 700})\r\n    t1.path(\'M 605,365 A 300,300 0 1,1 605,260\')\r\n\r\n先将路径确定好，并调整文字的一些属性，使其和原图一样。\r\n\r\n    t1.textPath().attr(\'startOffset\', \'0\').animate({ ease: \'-\', duration:                 10000}).attr(\'startOffset\', \'100%\').loop()\r\n\r\n然后调用动画方法就能动了。但是这样无法将文字循环，文字播放到终点就消失了。\r\n一开始我想再用一个文字矢量图接着这个画的，但是svg里的`startOffset`不能使用负值（负值当然也是有效的，但是不能像0~100%这样设置）。于是想用逆时针路径然后倒过来播放，可惜这样文字就倒过来了，也不知道是否有办法设置。\r\n\r\n最后终于想到一个完美的方案\r\n\r\n    t1.path(\'M 605,365 A 300,300 0 1,1 605,260 M 605,365 A 300,300 0 1,1 605,260\')\r\n    t1.textPath().attr(\'startOffset\', \'0\').animate({ ease: \'-\', duration: 10000}).attr(\'startOffset\', \'50%\').loop()\r\n\r\n把路径画两遍，然后播放时`startOffset`从0~50%进行循环就行了。\r\n如果你也想实现这种无限循环地旋转的话，可以试试这个方法。\r\n\r\n## 其他 ##\r\n之所以做这个还是由于对笑脸男这个人物的喜爱吧，有能力的同时愿意来为真相做出贡献。有意思的是，攻壳第二季第二集的主人公和他完全就是相反的人。空想但没有勇气去做，想想自己和大概也就是这样的人了。\r\n\r\n  [1]: http://frezc.github.io/NetResources/waraiotoko/\r\n  [2]: https://github.com/Frezc/NetResources/blob/master/waraiotoko/main.js\r\n  [3]: http://www.w3.org/TR/SVG/paths.html', 0, 1, NULL, 'post', 'publish', NULL, 0, '1', '1', '1', 0, 0);
/*!40000 ALTER TABLE `typecho_contents` ENABLE KEYS */;


-- 导出  表 typecho.typecho_fields 结构
CREATE TABLE IF NOT EXISTS `typecho_fields` (
  `cid` int(10) unsigned NOT NULL,
  `name` varchar(200) NOT NULL,
  `type` varchar(8) DEFAULT 'str',
  `str_value` text,
  `int_value` int(10) DEFAULT '0',
  `float_value` float DEFAULT '0',
  PRIMARY KEY (`cid`,`name`),
  KEY `int_value` (`int_value`),
  KEY `float_value` (`float_value`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- 正在导出表  typecho.typecho_fields 的数据：0 rows
/*!40000 ALTER TABLE `typecho_fields` DISABLE KEYS */;
/*!40000 ALTER TABLE `typecho_fields` ENABLE KEYS */;


-- 导出  表 typecho.typecho_links 结构
CREATE TABLE IF NOT EXISTS `typecho_links` (
  `lid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'links表主键',
  `name` varchar(200) DEFAULT NULL COMMENT 'links名称',
  `url` varchar(200) DEFAULT NULL COMMENT 'links网址',
  `sort` varchar(200) DEFAULT NULL COMMENT 'links分类',
  `image` varchar(200) DEFAULT NULL COMMENT 'links图片',
  `description` varchar(200) DEFAULT NULL COMMENT 'links描述',
  `user` varchar(200) DEFAULT NULL COMMENT '自定义',
  `order` int(10) unsigned DEFAULT '0' COMMENT 'links排序',
  PRIMARY KEY (`lid`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- 正在导出表  typecho.typecho_links 的数据：1 rows
/*!40000 ALTER TABLE `typecho_links` DISABLE KEYS */;
INSERT INTO `typecho_links` (`lid`, `name`, `url`, `sort`, `image`, `description`, `user`, `order`) VALUES
	(1, 'BranchZero', 'http://loger.me/', NULL, 'http://loger.me/usr/themes/touch5/images/logo.png', NULL, NULL, 1);
/*!40000 ALTER TABLE `typecho_links` ENABLE KEYS */;


-- 导出  表 typecho.typecho_metas 结构
CREATE TABLE IF NOT EXISTS `typecho_metas` (
  `mid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) DEFAULT NULL,
  `slug` varchar(200) DEFAULT NULL,
  `type` varchar(32) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `count` int(10) unsigned DEFAULT '0',
  `order` int(10) unsigned DEFAULT '0',
  `parent` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`mid`),
  KEY `slug` (`slug`)
) ENGINE=MyISAM AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

-- 正在导出表  typecho.typecho_metas 的数据：33 rows
/*!40000 ALTER TABLE `typecho_metas` DISABLE KEYS */;
INSERT INTO `typecho_metas` (`mid`, `name`, `slug`, `type`, `description`, `count`, `order`, `parent`) VALUES
	(1, '默认分类', 'default', 'category', '只是一个默认分类', 2, 1, 0),
	(9, '记事', '记事', 'tag', NULL, 1, 0, 0),
	(6, '技术', '技术', 'tag', NULL, 1, 0, 0),
	(7, 'acg', 'acg', 'tag', NULL, 1, 0, 0),
	(8, '旧博客', '旧博客', 'tag', NULL, 1, 0, 0),
	(10, 'laravel', 'laravel', 'tag', NULL, 2, 0, 0),
	(11, '项目', '项目', 'tag', NULL, 1, 0, 0),
	(12, '软考', '软考', 'tag', NULL, 1, 0, 0),
	(13, 'App', 'app', 'category', NULL, 1, 2, 0),
	(14, 'android', 'android', 'tag', NULL, 1, 0, 0),
	(15, '项目升级', '项目升级', 'tag', NULL, 1, 0, 0),
	(16, 'intellij idea', 'intellij-idea', 'tag', NULL, 1, 0, 0),
	(17, '其他技术', 'other-tech', 'category', NULL, 2, 3, 0),
	(18, 'python', 'python', 'tag', NULL, 1, 0, 0),
	(19, '爬虫', '爬虫', 'tag', NULL, 2, 0, 0),
	(20, '动画', '动画', 'tag', NULL, 1, 0, 0),
	(21, '排行', '排行', 'tag', NULL, 2, 0, 0),
	(22, 'bangumi', 'bangumi', 'tag', NULL, 1, 0, 0),
	(23, 'animesachi', 'animesachi', 'tag', NULL, 1, 0, 0),
	(24, 'animenewsnetwork', 'animenewsnetwork', 'tag', NULL, 1, 0, 0),
	(25, 'vue.js', 'vue-js', 'tag', NULL, 1, 0, 0),
	(26, 'semantic', 'semantic', 'tag', NULL, 1, 0, 0),
	(27, '动漫', '动漫', 'tag', NULL, 1, 0, 0),
	(28, '跨域请求', '跨域请求', 'tag', NULL, 1, 0, 0),
	(29, 'Web', 'web', 'category', NULL, 2, 4, 0),
	(30, '笑脸男', '笑脸男', 'tag', NULL, 1, 0, 0),
	(31, '笑い男', '笑い男', 'tag', NULL, 1, 0, 0),
	(32, 'svg.js', 'svg-js', 'tag', NULL, 1, 0, 0),
	(33, 'raphael.js', 'raphael-js', 'tag', NULL, 1, 0, 0),
	(34, '矢量图', '矢量图', 'tag', NULL, 1, 0, 0),
	(35, 'textpath', 'textpath', 'tag', NULL, 1, 0, 0),
	(36, 'animate', 'animate', 'tag', NULL, 0, 0, 0),
	(37, 'circular animate', 'circular-animate', 'tag', NULL, 1, 0, 0);
/*!40000 ALTER TABLE `typecho_metas` ENABLE KEYS */;


-- 导出  表 typecho.typecho_relationships 结构
CREATE TABLE IF NOT EXISTS `typecho_relationships` (
  `cid` int(10) unsigned NOT NULL,
  `mid` int(10) unsigned NOT NULL,
  PRIMARY KEY (`cid`,`mid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- 正在导出表  typecho.typecho_relationships 的数据：38 rows
/*!40000 ALTER TABLE `typecho_relationships` DISABLE KEYS */;
INSERT INTO `typecho_relationships` (`cid`, `mid`) VALUES
	(5, 1),
	(5, 6),
	(5, 7),
	(5, 8),
	(6, 1),
	(6, 9),
	(6, 10),
	(6, 11),
	(6, 12),
	(7, 13),
	(7, 14),
	(7, 15),
	(7, 16),
	(9, 17),
	(9, 18),
	(9, 19),
	(9, 20),
	(9, 21),
	(9, 22),
	(9, 23),
	(9, 24),
	(11, 17),
	(12, 10),
	(12, 19),
	(12, 21),
	(12, 25),
	(12, 26),
	(12, 27),
	(12, 28),
	(12, 29),
	(13, 29),
	(13, 30),
	(13, 31),
	(13, 32),
	(13, 33),
	(13, 34),
	(13, 35),
	(13, 37);
/*!40000 ALTER TABLE `typecho_relationships` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
