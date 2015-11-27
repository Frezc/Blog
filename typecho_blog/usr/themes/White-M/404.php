<?php if (!defined('__TYPECHO_ROOT_DIR__')) exit; ?>
<?php $this->need('header.php'); ?>
<div class="main">
<div class="left">
	<div class="err">
		<h4>找不到网页</h4>
		<p>你要查看的网页可能已被删除、名称已被更改，或者暂时不可用。</p>
		<p>
		请尝试以下操作：<br />

		1. 如果您已经在地址栏中输入该网页的地址，请确认其拼写正确；<br />

		2. 点s击首页进入<a href="<?php $this->options->siteUrl(); ?>" title="<?php $this->options->title() ?>"><?php $this->options->title() ?></a>主页；<br />

		3. 单击<span class="light">后退</span>按钮，尝试其他链接；
		</p>
	</div>
</div>
<?php $this->need('sidebar.php'); ?>
<?php $this->need('footer.php'); ?>