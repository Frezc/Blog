<?php if (!defined('__TYPECHO_ROOT_DIR__')) exit; ?>
<!DOCTYPE HTML>
<html>
<head>
  <meta charset="<?php $this->options->charset(); ?>">
  <meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1">
  <meta name="renderer" content="webkit">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <title><?php $this->archiveTitle(array(
          'category'  =>  _t('分类 %s 下的文章'),
          'search'    =>  _t('包含关键字 %s 的文章'),
          'tag'       =>  _t('标签 %s 下的文章'),
          'author'    =>  _t('%s 发布的文章')
      ), '', ' - '); ?><?php $this->options->title(); ?></title>
  <link rel="shortcut icon" href="<?php $this->options->siteUrl(); ?>favicon.ico" />
  <!-- 使用url函数转换相关路径 -->
  <link rel="stylesheet" href="<?php $this->options->themeUrl('style.css'); ?>" />
  <!-- 通过自有函数输出HTML头部信息 -->
  <?php if($this->is('index')): ?>
    <link rel="canonical" href="<?php $this->options->siteUrl(); ?>" />
  <?php endif; ?>
  <?php if($this->is('post')): ?>
    <link rel="canonical" href="<?php $this->permalink() ?>" />
  <?php endif; ?>
  <?php $this->header('generator=&template=&pingback=&xmlrpc=&wlw='); ?>
  <script type="text/javascript" src="<?php $this->options->themeUrl('jquery.min.js'); ?>"></script>
  <script type="text/javascript" src="<?php $this->options->themeUrl('lazyload.js'); ?>"></script>
  <script type="text/javascript">
  	jQuery(function() {          
      	jQuery("img").not(".thumb").lazyload({
          	placeholder:"<?php $this->options->themeUrl('loading.gif'); ?>",
              effect:"fadeIn"
            });
      	});
  </script>
</head>
<body>
  <div class="fuck">
  <div class="head">
    <h1 class="logo">
    <a href="<?php $this->options->siteUrl(); ?>" title="<?php $this->options->title() ?>">
    <?php if ($this->options->logoUrl): ?>
      <img src="<?php $this->options->logoUrl() ?>">
    <?php else: ?>
    <?php $this->options->title() ?>
    <?php endif; ?>
    </a></h1>
    <ul class="nav">
      <li<?php if($this->is('index')): ?> class="current"<?php endif; ?>><a href="<?php $this->options->siteUrl(); ?>" title="<?php _e('首页'); ?>"><?php _e('首页'); ?></a></li>
  	  <?php if (empty($this->options->menuDisplay) || in_array('cat', $this->options->menuDisplay)): ?>
              <?php $this->widget('Widget_Metas_Category_List')->to($categories); ?>
              <?php while($categories->next()): ?>
                  <li<?php if($this->is('category', $categories->slug)): ?> class="current"<?php endif; ?>><a href="<?php $categories->permalink(); ?>"><?php $categories->name(); ?></a></li>
              <?php endwhile; ?>
      <?php endif; ?>
    	<?php if (empty($this->options->menuDisplay) || in_array('page', $this->options->menuDisplay)): ?>
    	<?php $this->widget('Widget_Contents_Page_List')->to($pages); ?>
      	<?php while($pages->next()): ?>
          <li><a href="<?php $pages->permalink(); ?>" title="<?php $pages->title(); ?>"><?php $pages->title(); ?></a></li>
       	<?php endwhile; ?>
      <?php endif; ?>
    </ul>
</div>