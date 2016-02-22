<?php if (!defined('__TYPECHO_ROOT_DIR__')) exit; ?>
<?php $this->need('header.php'); ?>
<div class="main">
  <div class="left">
    <div class="cont">
      <h2><?php $this->title() ?></h2>
     <!-- <p class="entry_data"><a href="<?php $this->permalink() ?>#comments"><?php $this->commentsNum('木有评论', '一次吐槽', '%d 次吐槽'); ?></a></p> -->
      <div class="content">
        <?php $this->content(); ?>
      </div>
    </div>
<?php $this->need('comments.php'); ?>
  </div>
<?php $this->need('sidebar.php'); ?>
<?php $this->need('footer.php'); ?>