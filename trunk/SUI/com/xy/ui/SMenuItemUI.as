package com.xy.ui {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;


/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-11-13 上午10:23:47
 **/
public class SMenuItemUI extends Sprite {
	private var _sw : Number;
	private var _sh : Number;
	private var _label : String = "菜单";
	private var _selected : Boolean;
	private var _upIcon : DisplayObject;
	private var _downIcon : DisplayObject;

	public function setLabel(txt : String) : void {
		_label = txt;
		tf.autoSize = TextFieldAutoSize.CENTER;
		tf.text = _label;
		tf.height = tf.textHeight + 10;
		mouseChildren = false;
	}

	public function SMenuItemUI() {
		super();
		downBg.x = downBg.y = upBg.x = upBg.y = tf.x = tf.y = 0;

		selected = false;
	}

	public function resized() : void {
		tf.width = 10;
		_sw = width;
		_sh = height;
		scaleX = scaleY = 1;
		downBg.width = upBg.width = tf.width = _sw;
		downBg.height = upBg.height = _sh;
		tf.y = (_sh - tf.height) / 2;
		layout();
	}

	public function get selected() : Boolean {
		return _selected;
	}

	public function set selected(value : Boolean) : void {
		_selected = value;
		if (_selected) {
			if (contains(upBg)) {
				removeChild(upBg);
			}
			addChildAt(downBg, 0);
			tf.textColor = 0xFFFFFF;
		} else {
			if (contains(downBg)) {
				removeChild(downBg);
			}
			addChildAt(upBg, 0);
			tf.textColor = 0xCCCCCC;
		}
	}

	private function layout() : void {
		tf.x = 0;
		tf.width = _sw;
		if (_upIcon != null) {
			var startY : int = (_sh - tf.height - _upIcon.height - 5) / 2;
			_upIcon.y = startY;
			tf.y = startY + _upIcon.height + 5;
			_upIcon.x = (_sw - _upIcon.width) / 2;
		} else {
			tf.y = (_sh - tf.height) / 2;
		}
	}

	public function get upIcon() : DisplayObject {
		return _upIcon;
	}

	public function set upIcon(value : DisplayObject) : void {
		if (!selected) {
			if (_upIcon != null && contains(_upIcon)) {
				removeChild(_upIcon);
			}

			if (value != null) {
				addChildAt(value, 1);
			}
		}
		_upIcon = value;
		if (_downIcon == null) {
			downIcon = value;
		}
		layout();
	}

	public function get downIcon() : DisplayObject {
		return _downIcon;
	}

	public function set downIcon(value : DisplayObject) : void {
		if (selected) {
			if (_downIcon != null && contains(_downIcon)) {
				removeChild(_downIcon);
			}
			if (value != null) {
				addChildAt(value, 1);
			}
		}
		_downIcon = value;
		if (_upIcon == null) {
			upIcon = value;
		}
		layout();
	}


}
}
