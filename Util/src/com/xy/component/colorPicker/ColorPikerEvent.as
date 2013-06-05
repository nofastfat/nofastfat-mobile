package com.xy.component.colorPicker {
import flash.events.Event;

/**
 * 色板点击
 * @author xy
 */
public class ColorPikerEvent extends Event {
	public static const SELECT_COLOR : String = "SELECT_COLOR";

	/**
	 * 颜色
	 * @return
	 */
	private var _color : uint;

	/**
	 * index
	 */
	private var _index : int;

	public function ColorPikerEvent(type : String, color : uint, index : int, bubbles : Boolean = false, cancelable : Boolean = false) {
		super(type, bubbles, cancelable);
		_color = color;
		_index = index;
	}

	/**
	 * 获取颜色
	 * @return
	 */
	public function get color() : uint {
		return _color;
	}

	/**
	* 获取序列
	* @return
	*/
	public function get index() : int {
		return _index;
	}
	
	override public function clone():Event{
		return new ColorPikerEvent(type, _color, _index);
	}
}
}
