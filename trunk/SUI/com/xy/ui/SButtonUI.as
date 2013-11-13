package com.xy.ui {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.utils.Dictionary;


/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-11-12 上午10:41:23
 **/
public class SButtonUI extends Sprite {
	private static const FONT_COLOR : * = {
		red:"#FFFFFF",
		gray:"#FFFFFF",
		white:"#000000",
		green:"#FFFFFF",
		yellow:"#000000"
	};
	private var _label : String = "按钮";
	private var _style : String = "gray";
	private var _sw : Number;
	private var _sh : Number;

	[Inspectable]
	public function set label(txt : String) : void {
		_label = txt;
		updateTf();
	}

	[Inspectable(enumeration = "red,gray,white,green,yellow")]
	public function set style(txt : String) : void {
		_style = txt;
		upState.gotoAndStop(_style);
		downState.gotoAndStop(_style);
		updateTf();
	}

	public function SButtonUI() {
		super();
		tf.x = upState.x = upState.y = downState.x = downState.y = 0;
		tf.mouseEnabled = upState.mouseEnabled = downState.mouseEnabled = false;
		buttonMode = true;
		updateTf();
		resized();
		removeChild(downState);
		
		addEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
	}
	
	private function updateTf():void{
		tf.htmlText = "<font color='"+FONT_COLOR[_style]+"'>"+_label+"</font>";
	}

	public function resized() : void {
		_sw = width;
		_sh = height;
		scaleX = 1;
		scaleY = 1;
		tf.width = upState.width = downState.width = _sw;
		upState.height = downState.height = _sh;
		tf.y= 0;
		tf.height = tf.textHeight + 10;
		tf.y = (height-tf.height)/2;
	}
	
	private function __downHandler(e : MouseEvent):void{
		removeChild(upState);
		addChildAt(downState, 0);
		SUIRoot.stage.addEventListener(MouseEvent.MOUSE_UP, __upHandler);
	}
	
	public function dispose():void{
		SUIRoot.stage.removeEventListener(MouseEvent.MOUSE_UP, __upHandler);
		removeEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
	}
	
	private function __upHandler(e : MouseEvent):void{
		removeChild(downState);
		addChildAt(upState, 0);
		SUIRoot.stage.removeEventListener(MouseEvent.MOUSE_UP, __upHandler);
	}

	public function get label() : String {
		return _label;
	}

}
}
