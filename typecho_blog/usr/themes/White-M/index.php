<?php
/**
 * 白色宽版主题，简约而不简单！
 *
 * @package White-M
 * @author Mike
 * @version 3.4(15.04.29)
 * @link http://www.microhu.com
 */

 if (!defined('__TYPECHO_ROOT_DIR__')) exit;
 $this->need('header.php');
 ?>

  <div class="main">
    <div class="left">
	<?php while($this->next()): ?>
      <div class="cont">
        <h2><a href="<?php $this->permalink() ?>"><?php $this->sticky(); $this->title() ?></a></h2>
        <p class="entry_data">发布时间：<?php $this->date('Y年n月j日'); ?> / 分类：<?php $this->category(','); ?> <!--/ <?php Views_Plugin::theViews('', ' 次围观'); ?> / <a href="<?php $this->permalink() ?>#comments"><?php $this->commentsNum('抢沙发！', '一次吐槽', '%d 次吐槽'); ?></a> --></p>
        <div class="list-content">
          <?php $this->content(); ?>
        </div>
      </div>
	    <?php endwhile; ?>
      <?php $this->pageNav(); ?>
    </div>
<?php $this->need('sidebar.php'); ?>
<?php $this->need('footer.php'); ?>
