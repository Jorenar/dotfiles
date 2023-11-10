<?php
class TweaksJSExtension extends Minz_Extension {
	public function init() {
        Minz_View::appendScript($this->getFileUrl('tweaks.js', 'js'));
	}
}
?>
