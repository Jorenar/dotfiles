<?php
class TweaksCSSExtension extends Minz_Extension {
	public function init() {
        Minz_View::appendStyle($this->getFileUrl('tweaks.css', 'css'));
	}
}
?>
