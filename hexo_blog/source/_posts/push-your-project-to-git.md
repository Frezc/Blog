title: 如何将你的项目上传到git远程库上
date: 2015-05-03 16:13:55
categories: develop
tags: git
---
以前我以为git只能在远程库创建后pull下来再将项目复制进去才能上传。
后来知道了原来可以直接通过创建本地仓库然后合并到远程仓库里，
我这里通过SourceTree(简称st)来演示下操作。

创建远程库
---
你可以在oschina、github或者其他提供git服务器的网站上创建，具体不演示了我在github上创建了一个项目
![远程库](https://frezc.github.io/2015/05/03/push-your-project-to-git/init.png)

创建本地库
---
点击st的*克隆/新建*选择创建新仓库标签，将目标路径设为你的项目根目录，点击创建
![本地库](https://frezc.github.io/2015/05/03/push-your-project-to-git/init_local.png)
然后点击右上角的设置，在远程仓库选项卡里点击添加，将远程库的url复制到*URL/路径*里，远端名称建议和远程库名称相同，其他的自己填写，然后确定。
![设置远程库](https://frezc.github.io/2015/05/03/push-your-project-to-git/set_remote.png)

提交
---
在你项目的选项卡里将未暂存文件暂存(建议这里在根目录写好.gitignore文件来忽略不必要上传的文件，具体怎么写去问谷歌百度)
![暂存文件](https://frezc.github.io/2015/05/03/push-your-project-to-git/save.png)
然后点击提交(提交的作者和邮箱可以在工具-选项-默认用户信息里设置)，填写好提交信息，如果你勾选了*立即推送变更到 - *则会在提交后马上执行push操作。
![提交](https://frezc.github.io/2015/05/03/push-your-project-to-git/commit.png)
如果没有勾选，这里点击推送，确定
![推送](https://frezc.github.io/2015/05/03/push-your-project-to-git/push.png)
然后你的项目就上传到远程库了
![成功](https://frezc.github.io/2015/05/03/push-your-project-to-git/success.png)

其他tips
---
- .gitignore要无视的文件和项目类型以及IDE有关，如果你用intellij idea写android项目，可以参考我的[.gitignore](https://github.com/Frezc/BangumiTimeMachine/blob/master/.gitignore)
- 如果.gitignore如果无法忽视某些文件，请检查你的远程库上时候有这些文件，请提交一次删除这些文件后的项目，然后再更新.gitignore
- 一般来说你的远程库更新后st会自动检测到更新，如果没有请点击**获取**来的到更新，然后再通过**拉取**更新。