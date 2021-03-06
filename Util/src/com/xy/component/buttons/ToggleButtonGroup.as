package com.xy.component.buttons {
import com.xy.component.buttons.event.ToggleButtonEvent;
import com.xy.component.buttons.event.ToggleButtonGroupEvent;

import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

/**
 * 状态按钮组，控制组件 ，该组件只做控制，不做显示
 * @author xy
 */
[Event(name = "STATE_CHANGE", type = "com.xy.component.buttons.event.ToggleButtonGroupEvent")]
public class ToggleButtonGroup extends EventDispatcher {
	private var _btns : Array = [];

	private var _lastSelectedButton : ToggleButton;
	
	private var _allowNullSelect : Boolean;
	private var _allowSameEvent : Boolean;

	public function ToggleButtonGroup(allowNullSelect : Boolean = false, allowSameEvent:Boolean = false) {
		_allowNullSelect = allowNullSelect;
		_allowSameEvent = allowSameEvent;
	}

	/**
	 * 设置被控制的toggle按钮
	 * @param toggleButtons [ToggleButton, ToggleButton, ...]
	 */
	public function setToggleButtons(toggleButtons : Array, defaultSelectedIndex : int = 0) : void {
		if (toggleButtons == null) {
			return;
		}

		for (var i : int = 0; i < _btns.length; i++) {
			var btn : ToggleButton = _btns[i];
			btn.removeEventListener(ToggleButtonEvent.STATE_CHANGE, __stageChangeHandler);
			btn.dispose();
		}

		_btns = toggleButtons;

		for (i = 0; i < _btns.length; i++) {
			btn = _btns[i];
			btn.selected = false;
			btn.addEventListener(ToggleButtonEvent.STATE_CHANGE, __stageChangeHandler);
		}

		setSelected(defaultSelectedIndex);
	}

	public function setSelected(index : int, dispatch : Boolean = false) : void {
		if (_lastSelectedButton != null) {
			_lastSelectedButton.selected = false;
			_lastSelectedButton = null;
		}

		if (index < 0 || index >= _btns.length) {
			return;
		}

		_lastSelectedButton = _btns[index];
		_lastSelectedButton.selected = true;

		if (dispatch) {
			dispatchEvent(new ToggleButtonGroupEvent(ToggleButtonGroupEvent.STATE_CHANGE, index));
		}
	}

	public function getSelectedIndex() : int {
		return _btns.indexOf(_lastSelectedButton);
	}

	public function dispose() : void {
		for (var i : int = 0; i < _btns.length; i++) {
			var btn : ToggleButton = _btns[i];
			btn.removeEventListener(ToggleButtonEvent.STATE_CHANGE, __stageChangeHandler);
			btn.dispose();
		}

		_btns = [];
		_lastSelectedButton = null;
	}

	private function __stageChangeHandler(e : ToggleButtonEvent) : void {
		var togButton : ToggleButton = e.currentTarget as ToggleButton;

		var isSame : Boolean = togButton == _lastSelectedButton;

		var index : int = _btns.indexOf(togButton);

		if (isSame && _allowNullSelect) {
			index = -1;
		}
		setSelected(index);
		if (!isSame || _allowNullSelect || _allowSameEvent) {
			dispatchEvent(new ToggleButtonGroupEvent(ToggleButtonGroupEvent.STATE_CHANGE, index));
		}
	}
	
	public function get selectIndex() : int {
		return _btns.indexOf(_lastSelectedButton);
	}
	
	public function get selectLine() : ToggleButton {
		return _lastSelectedButton;
	}
}
}
