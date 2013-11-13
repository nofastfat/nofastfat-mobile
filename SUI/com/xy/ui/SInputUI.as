package com.xy.ui {

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;
import flash.text.TextField;

/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-9-11 下午12:32:45
 **/
public class SInputUI extends Sprite {
	private var _call : Function;

	private var _name : String = "";

	private var _sw : Number;

	private var _allowNull : Boolean = true;
	
	private var _rt : String = null;

	[Inspectable]
	public function set label(txt : String) : void {
		_name = txt;
		initName();
	}
	
	[Inspectable]
	public function set allowNull(allow : Boolean) : void {
		_allowNull = allow;
	}
	
	[Inspectable]
	public function set restrict(rt : String) : void {
		_rt = rt;
		if(_rt == ""){
			_rt = null;
		}
	}
	
	

	public function SInputUI() {
		super();
		if (bg != null) {
			bg.gotoAndStop(1);
		}
		inputTf.addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
		clearBtn.addEventListener(MouseEvent.CLICK, __clickClearHandler);
		inputTf.addEventListener(FocusEvent.FOCUS_OUT, __focusOutHandler);
		clearBtn.visible = false;

		if (SUIRoot.IS_IOS) {
			removeChild(clearBtn);
		}

		inputTf.text = "";
		initName();
		_sw = width;
		scaleX = 1;
		resized();
	}

	private function resized() : void {
		bg.width = _sw;
		inputTf.width = _sw - inputTf.x - clearBtn.width - 10;
		clearBtn.x = inputTf.x + inputTf.width + 5;
	}
	
	public function verify():Boolean{
		if(!_allowNull && getValue() == ""){
			STipUI.getInstance().show(this, _name + " 是必填项。");
			return false;
		}
		
		return true;
	}


	/**
	 * 当文字内容变化时
	 * @param call function(txt : String):void;
	 */
	public function setChangeCall(call : Function) : void {
		_call = call;
		inputTf.addEventListener(Event.CHANGE, __changeHandler);
	}

	private function __changeHandler(e : Event) : void {
		if (_call != null) {
			_call(getValue());
		}
	}

	public function initData(value : String) : void {
		value = SUITool.skipNull(value);
		if (value == "") {
			clear();
		} else {
			inputTf.restrict = _rt;
			inputTf.textColor = 0x000000;
			inputTf.text = value;
		}
	}

	public function clear() : void {
		inputTf.restrict = null;
		inputTf.htmlText = "<font color='#999999'>" + _name + "</font>";
	}

	private function initName() : void {
		inputTf.textColor = 0x999999;
		inputTf.text = _name;
	}

	private function __mouseDownHandler(e : Event) : void {
		if (bg != null) {
			bg.gotoAndStop(2);
		}
		clearBtn.visible = true;
		e.stopImmediatePropagation();
		e.stopPropagation();
		if (inputTf.text == _name) {
			inputTf.text = "";
		}
		inputTf.textColor = 0x000000;
		inputTf.restrict = _rt;
	}

	private function __clickClearHandler(source : * = null) : void {
		inputTf.text = "";
		clearBtn.visible = false;

		initName();

		if (_call != null) {
			_call("");
		}
	}

	private function __focusOutHandler(e : FocusEvent) : void {
		if (bg != null) {
			bg.gotoAndStop(1);
		}

		if (e.relatedObject != clearBtn) {
			clearBtn.visible = false;
		}

		if (inputTf.text == "") {
			initName();
		}
	}

	public function getValue() : String {
		if (inputTf.text == _name) {
			return "";
		} else {
			return inputTf.text;
		}
	}

	public function destroy() : void {
		inputTf.removeEventListener(FocusEvent.FOCUS_OUT, __focusOutHandler);
		inputTf.removeEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
		inputTf.removeEventListener(Event.CHANGE, __changeHandler);
		clearBtn.removeEventListener(MouseEvent.CLICK, __clickClearHandler);
		_call = null;
	}
}
}
