package com.xy.view.sprite {

import starling.core.Starling;
import starling.display.Sprite;

/**
 * 面板基类
 * @author xy
 */
public class AbsPanel extends Sprite {
	protected var _bg : Sprite;
	protected var _restBgX : int;
	protected var _restBgY : int;

	protected var _offsetY : int = 100;
	protected var _showTime : Number = 0.3;
	protected var _hideTime : Number = 0.2;

	public function AbsPanel() {
		super();
	}

	public function showTo(parent : Sprite) : void {
		SoundManager.play("panel");
		addChildAt(Assets.mask, 0);
		parent.addChild(this);

		_bg.x = _restBgX;
		_bg.alpha = .2;

		_bg.y = _restBgY + _offsetY;
		Starling.juggler.tween(_bg, _showTime, {y: _restBgY, alpha: 1});
	}

	/**
	 * 带动画的隐藏
	 */
	public function hide(call : Function = null) : void {
		SoundManager.play("panel");
		Starling.juggler.tween(_bg, _hideTime, {y: _restBgY - _offsetY, alpha: 0, onComplete: function() : void {
			removeFromParent();

			if (call != null) {
				call();
			}
		}});
	}
}
}
