<?php
   /**
   * 读者墙 For White-M
   *
   * @package custom
   */
   ?>
<?php if (!defined('__TYPECHO_ROOT_DIR__')) exit; ?>
<?php $this->need('header.php'); ?>
<div class="main">
  <div class="left">
    <div class="cont">
      <h2><?php $this->title() ?></h2>
  <p class="entry_data"><a href="<?php $this->permalink() ?>#comments"><?php $this->commentsNum('木有评论', '一次吐槽', '%d 次吐槽'); ?></a></p>
      <div class="content">
	  		<h3>读者墙</h3>
		<div class="readers">		
   <?php getFriendWall(); ?>
</div>
        <?php $this->content(); ?>
      </div>
    </div>
<?php $this->need('comments.php'); ?>
<?php $this->need('sidebar.php'); ?>
<?php $this->need('footer.php'); ?>