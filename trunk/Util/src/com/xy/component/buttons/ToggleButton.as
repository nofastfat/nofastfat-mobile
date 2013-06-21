package com.xy.component.buttons {
import com.xy.component.buttons.event.ToggleButtonEvent;

import flash.display.MovieClip;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;

/**
 * 状态按钮，控制组件 ，该组件只做控制，不做显示
 * @author xy
 */
[Event(name = "state_change", type = "ToggleButtonEvent")]
public class ToggleButton extends EventDispatcher {
	private var _target : MovieClip;
	private var _selected : Boolean;

	public function ToggleButton(mc : MovieClip = null, banChildEvent : Boolean = true) {
		if(mc == null){
			return;
		}
		setCtrlUI(mc, banChildEvent);
	}

	/**
	 * 设置被控制的UI
	 * @param mc 状态按钮一般是2个状态，所以MC不能少于2帧
	 */
	public function setCtrlUI(mc : MovieClip, banChildEvent : Boolean = true) : void {
		if (mc == null || mc.totalFrames < 2) {
			throw new Error("ToggleButton 控制的对象至少应该有2帧");
			return;
		}

		if (_target != null) {
			_target.removeEventListener(MouseEvent.CLICK, __clickHandler);
		}

		_selected = false;
		_target = mc;
		_target.gotoAndStop(1);
		if(banChildEvent){
			_target.mouseChildren = false;
			_target.buttonMode = true;
		}

		_target.addEventListener(MouseEvent.CLICK, __clickHandler);
	}

	public function dispose() : void {
		if (_target != null) {
			_target.removeEventListener(MouseEvent.CLICK, __clickHandler);
		}
		_target = null;
	}

	private function __clickHandler(e : MouseEvent) : void {
		selected = !selected;
		dispatchEvent(new ToggleButtonEvent(ToggleButtonEvent.STATE_CHANGE, selected));
	}

	public function get selected() : Boolean {
		return _selected;
	}

	public function set selected(value : Boolean) : void {
		_selected = value;

		if (_target == null) {
			return;
		}
		if (_selected) {
			_target.gotoAndStop(2);
		} else {
			_target.gotoAndStop(1);
		}
	}

}
}
