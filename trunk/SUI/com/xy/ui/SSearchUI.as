package com.xy.ui {

import flash.display.MovieClip;
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
public class SSearchUI extends MovieClip{
	private var _name : String = "search";
	
	[Inspectable]
	public function set label(txt : String):void{
		_name = txt;
		initName();
	}
	
	private var _call : Function;

	public function SSearchUI() {
		super();
		inputTf.addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownHandler);
		clearBtn.addEventListener(MouseEvent.CLICK, __clickClearHandler);
		inputTf.addEventListener(FocusEvent.FOCUS_OUT, __focusOutHandler);
		clearBtn.visible = false;

		if(SUIRoot.IS_IOS){
			removeChild(clearBtn);
		}

		inputTf.text = "";
		initName();
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
			inputTf.textColor = 0x000000;
			inputTf.text = value;
		}
	}

	public function clear() : void {
		inputTf.htmlText = "<font color='#999999'>" + _name + "</font>";
	}

	private function initName() : void {
		inputTf.textColor = 0x999999;
		inputTf.text = _name;
	}

	private function __mouseDownHandler(e : Event) : void {
		clearBtn.visible = true;
		e.stopImmediatePropagation();
		e.stopPropagation();
		if (inputTf.text == _name) {
			inputTf.text = "";
		}
		inputTf.textColor = 0x000000;
	}

	private function __clickClearHandler(e : MouseEvent) : void {
		inputTf.text = "";
		clearBtn.visible = false;

		initName();

		if (_call != null) {
			_call("");
		}
	}

	private function __focusOutHandler(e : FocusEvent) : void {

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
