<?php
function themeConfig($form) {
    echo ('<style>body{font-family:Microsoft Yahei,微软雅黑;}</style><div style="font-size:14px;border-left:5px solid #1A1A1A;padding-left:8px;">White-M&nbsp;Theme&nbsp;版本：3.4(15.04.29)&nbsp;&nbsp;<strong>主题设置页</strong>&nbsp;&nbsp;<a href="http://www.microhu.com" title="检查更新">检查更新</a></div>');
    /** Logo显示 */
    $logoUrl = new Typecho_Widget_Helper_Form_Element_Text('logoUrl', NULL, NULL, _t('Logo地址') , _t('<strong>留空即显示文字Logo</strong>&nbsp;在这里填入一个logo图片的地址'));
    $form->addInput($logoUrl);
    /** 导航显示内容 */
    $menuDisplay = new Typecho_Widget_Helper_Form_Element_Checkbox('menuDisplay', array(
        'cat' => _t('显示分类目录') ,
        'page' => _t('显示独立页面')
    ) , array(
        'cat'
    ) , _t('导航显示内容'));
    $form->addInput($menuDisplay->multiMode());
    /** 社会化 */
    $sinaUrl = new Typecho_Widget_Helper_Form_Element_Text('sinaUrl', NULL, NULL, _t('新浪微博'), _t('在这里填入一个新浪微博地址'));
    $form->addInput($sinaUrl);
    $steamUrl = new Typecho_Widget_Helper_Form_Element_Text('steamUrl', NULL, NULL, _t('steam'), _t('在这里填入一个steam地址'));
    $form->addInput($steamUrl);
    $bilibiliUrl = new Typecho_Widget_Helper_Form_Element_Text('bilibiliUrl', NULL, NULL, _t('bilibili'), _t('在这里填入你的bilibili空间地址'));
    $form->addInput($bilibiliUrl);
    $githubUrl = new Typecho_Widget_Helper_Form_Element_Text('githubUrl', NULL, NULL, _t('github'), _t('在这里填入一个github地址'));
    $form->addInput($githubUrl);

    $sidebarBlock = new Typecho_Widget_Helper_Form_Element_Checkbox('sidebarBlock', array(
        'ShowHotPosts' => _t('显示热门文章') ,
        'ShowRecentPosts' => _t('在内页显示最新文章') ,
        'ShowRecentComments' => _t('显示最近回复') ,
        'ShowCategory' => _t('显示分类') ,
        'ShowArchive' => _t('显示归档') ,
        'Links' => _t('在首页显示友情链接')
    ) , array(
        'ShowRecentPosts',
        'ShowRecentComments',
        'ShowCategory',
        'ShowArchive',
        'Links'
    ) , _t('侧边栏显示'));
    $form->addInput($sidebarBlock->multiMode());
}
//获得读者墙
function getFriendWall() {
    $db = Typecho_Db::get();
    $sql = $db->select('COUNT(author) AS cnt', 'author', 'url', 'mail')->from('table.comments')->where('status = ?', 'approved')->where('type = ?', 'comment')->where('authorId = ?', '0')->where('mail != ?', '') //排除自己上墙
    ->group('author')->order('cnt', Typecho_Db::SORT_DESC)->limit('24'); //读取几位用户的信息
    $result = $db->fetchAll($sql);
    if (count($result) > 0) {
        $maxNum = $result[0]['cnt'];
        foreach ($result as $value) {
            $mostactive.= '<li><img alt src="http://1.gravatar.com/avatar/' . md5(strtolower($value['mail'])) . '?s=36&d=&r=G" height="48" width="48"></img><a target="_blank" rel="nofollow" href="' . $value['url'] . '" title="' . $value['author'] . '-' . $value['cnt'] . '条评论">' . $value['author'] . '</a><br><strong>' . $value['cnt'] . '条</strong></li>';
        }
        echo $mostactive;
    }
}