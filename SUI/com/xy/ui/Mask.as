package com.xy.ui {
import com.greensock.TweenLite;

import flash.display.Sprite;
import flash.events.MouseEvent;


/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-9-28 下午5:07:46
 **/
public class Mask extends Sprite {
	private static var _instance : Mask;
	private static var _call : Function;

	public static function getInstance() : Mask {
		if (_instance == null) {
			_instance = new Mask();
		}

		return _instance;
	}

	public function Mask() {
		graphics.beginFill(0x000000, 0.3);
		graphics.drawRect(0, 0, SUIRoot.stageWidth, SUIRoot.stageHeight);
		graphics.endFill();

		addEventListener(MouseEvent.CLICK, __callHander);
	}

	public function show(closeCall : Function) : void {
		_call = closeCall;
		SUIRoot.stage.addChild(this);
		TweenLite.killTweensOf(this);
		alpha = 1;
		TweenLite.from(this, 0.4, {alpha: 0.1});
	}

	public function hide() : void {
		_call = null;
		TweenLite.killTweensOf(this);
		if(SUIRoot.stage.contains(this)){
			SUIRoot.stage.removeChild(this);
		}
	}

	private function __callHander(e : MouseEvent) : void {
		if (_call != null) {
			_call();
		}
		hide();
	}
}
}
