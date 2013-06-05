package com.xy.component.numericStepper {
import com.xy.component.numericStepper.event.NumericStepperEvent;
import com.xy.util.EnterFrameCall;

import flash.display.DisplayObject;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.utils.clearInterval;
import flash.utils.setInterval;

[Event(name = "data_update", type = "NumericStepperEvent")]
public class NumericStepper extends EventDispatcher {
	private var _isInit : Boolean;
	private var _prevBtn : DisplayObject;
	private var _nextBtn : DisplayObject;
	private var _tf : TextField;
	private var _timer : uint;

	/**
	 * 最小值
	 */
	protected var _min : int;

	/**
	 * 最大值
	 */
	protected var _max : int;

	/**
	 * 步进值
	 */
	protected var _step : int;

	/**
	 * 当前值
	 */
	protected var _currentValue : int;

	public function NumericStepper() {
		super();
	}

	public function setCtrlUI(prevBtn : DisplayObject, nextBtn : DisplayObject, tf : TextField) : void {
		if (_isInit) {
			throw new Error("无法重复设置UI");
			return;
		}

		_prevBtn = prevBtn;
		_nextBtn = nextBtn;
		_tf = tf;
		_tf.restrict = "0-9";
		_isInit = true;

		_prevBtn.addEventListener(MouseEvent.MOUSE_DOWN, __downMoreHandler);
		_prevBtn.addEventListener(MouseEvent.MOUSE_UP, __upMoreHandler);
		_tf.addEventListener(Event.CHANGE, __changeHandler);

		_nextBtn.addEventListener(MouseEvent.MOUSE_DOWN, __downMoreHandler); 
		_nextBtn.addEventListener(MouseEvent.MOUSE_UP, __upMoreHandler);
		EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_UP, __upHandler);
		_tf.addEventListener(MouseEvent.MOUSE_WHEEL, __wheelHandler);
	}

	/**
	 * 设置数据
	 * @param min
	 * @param max
	 * @param step
	 */
	public function setData(min : int, max : int, step : int, currentValue : int) : void {
		if (max < min) {
			max = min;
		}

		_min = min;
		_max = max;
		_step = step;
		_currentValue = currentValue;
		if (_currentValue < _min) {
			_currentValue = _min;
		}
		if (_currentValue > _max) {
			_currentValue = _max;
		}

		updateUiByValue();
	}

	protected function __wheelHandler(e : MouseEvent) : void {
		e.stopPropagation();
		var lastValue : int = _currentValue;

		var delta : int = e.delta;
		if (e.delta > 0) {
			delta *= -1;
		}
		var vl : int = Math.ceil(delta * (_max - _min) / (_step * 100));
		if (e.delta > 0) {
			_currentValue -= vl;
		} else {
			_currentValue += vl;
		}
		if (_currentValue > _max) {
			_currentValue = _max;
		}
		if (_currentValue < _min) {
			_currentValue = _min;
		}

		if (lastValue != _currentValue) {
			updateUiByValue();
		}
	}

	private function __changeHandler(e : Event) : void {
		var vl : int = int(_tf.text);
		if (vl < _min) {
			vl = _min;
		}

		if (vl > _max) {
			vl = _max;
		}

		_currentValue = vl;
		updateUiByValue();
	}

	protected function __downMoreHandler(e : MouseEvent) : void {
		__upMoreHandler();
		if (e.currentTarget == _prevBtn) {
			__prevHandler();
			_timer = setInterval(__prevHandler, 100);
		} else if (e.currentTarget == _nextBtn) {
			__nextHandler();
			_timer = setInterval(__nextHandler, 100);
		}
	}

	protected function __upHandler(e : MouseEvent) : void {
		__upMoreHandler();
	}

	protected function __upMoreHandler(e : MouseEvent = null) : void {
		clearInterval(_timer);
		_timer = 0;
	}


	protected function __prevHandler(e : MouseEvent = null) : void {
		if (_min >= _max || _currentValue <= _min || (_currentValue - _step) < _min) {
			return;
		}

		_currentValue -= _step;
		updateUiByValue();
	}

	protected function __nextHandler(e : MouseEvent = null) : void {
		if (_min >= _max || _currentValue >= _max || (_currentValue + _step) > _max) {
			return;
		}
		_currentValue += _step;
		updateUiByValue();
	}

	/**
	 * 根据值来更新UI
	 */
	protected function updateUiByValue() : void {
		_tf.text = _currentValue.toString();
		dispatchEvent(new NumericStepperEvent(NumericStepperEvent.DATA_UPDATE, _currentValue));
	}

	public function dispose() : void {
		_tf.removeEventListener(Event.CHANGE, __changeHandler);
		_tf.removeEventListener(MouseEvent.MOUSE_WHEEL, __wheelHandler);
		_prevBtn.removeEventListener(MouseEvent.MOUSE_DOWN, __downMoreHandler);
		_prevBtn.removeEventListener(MouseEvent.MOUSE_UP, __upMoreHandler);

		_nextBtn.removeEventListener(MouseEvent.MOUSE_DOWN, __downMoreHandler);
		_nextBtn.removeEventListener(MouseEvent.MOUSE_UP, __upMoreHandler);
		EnterFrameCall.getStage().removeEventListener(MouseEvent.MOUSE_UP, __upHandler);

		_prevBtn = null;
		_nextBtn = null;
		_isInit = false;
	}
}
}
