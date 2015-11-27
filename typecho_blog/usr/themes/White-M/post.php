<?php if (!defined('__TYPECHO_ROOT_DIR__')) exit; ?>
<?php $this->need('header.php'); ?>
<div class="main">
  <div class="left">
    <div class="cont">
      <h2><?php $this->title() ?></h2>
      <p class="entry_data">发布时间：<?php $this->date('Y年n月j日'); ?> / 分类：<?php $this->category(','); ?> <!-- / <?php Views_Plugin::theViews('', ' 次围观'); ?> --> / <a href="<?php $this->permalink() ?>#comments"><?php $this->commentsNum('抢沙发！', '一次吐槽', '%d 次吐槽'); ?></a></p>
      <div class="content">
        <?php $this->content(); ?>
        <p class="tag"><?php _e('标签'); ?>：<?php $this->tags(', ', true, '没有标签呢'); ?></p>
      </div>
    </div>
<?php $this->need('comments.php'); ?>
<?php $this->need('sidebar.php'); ?>
<?php $this->need('footer.php'); ?>
