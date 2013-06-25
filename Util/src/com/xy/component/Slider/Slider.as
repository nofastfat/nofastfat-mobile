package com.xy.component.Slider {
import com.xy.component.Slider.event.SliderEvent;
import com.xy.util.EnterFrameCall;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.utils.clearInterval;
import flash.utils.setInterval;

/**
 * silder控制组件 ，该组件只做控制，不做显示
 * @author xy
 */
[Event(name = "data_update", type = "SliderEvent")]
public class Slider extends EventDispatcher {
    private static var COUNT : int = 0;

    /**
     * 左动
     */
    protected var _prevBtn : DisplayObject;

    /**
     * 右动
     */
    protected var _nextBtn : DisplayObject;

    /**
     * 滑动MC
     */
    protected var _sliderBtn : DisplayObject;

    /**
     * 用于滑动的背景MC
     */
    protected var _sliderBg : DisplayObject;

    /**
     * 是否已经初始化
     */
    protected var _isInit : Boolean = false;

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

    /**
     * UI每个步进值
     */
    protected var _uiStepLen : Number;

    /**
     * 显示的模式
     */
    protected var _mode : int = 0;

    protected var _downMouseX : Number;
    protected var _downX : Number;

    /**
     * 点击不动时，定时器
     */
    protected var _timer : uint;

    private var _lastValue : int = -1;

    /**
     * 设置用于控制的UI
     * @param sliderBtn
     * @param sliderBg
     * @param prevBtn
     * @param nextBtn
     */
    public function setCtrlUI(sliderBtn : DisplayObject, sliderBg : DisplayObject, prevBtn : DisplayObject = null, nextBtn : DisplayObject = null, sliderMode : int = SliderMode.HORIZONTAL) : void {
        if (_isInit) {
            throw new Error("无法重复设置UI");
            return;
        }

        _mode = sliderMode;
        _prevBtn = prevBtn;
        _nextBtn = nextBtn;
        _sliderBtn = sliderBtn;
        _sliderBg = sliderBg;
        _isInit = true;

        if (_prevBtn != null) {
            _prevBtn.addEventListener(MouseEvent.MOUSE_DOWN, __downMoreHandler);
            _prevBtn.addEventListener(MouseEvent.MOUSE_UP, __upMoreHandler);
        }

        if (_nextBtn != null) {
            _nextBtn.addEventListener(MouseEvent.MOUSE_DOWN, __downMoreHandler);
            _nextBtn.addEventListener(MouseEvent.MOUSE_UP, __upMoreHandler);
        }
        _sliderBtn.addEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_UP, __upHandler);

        if (_mode == SliderMode.VERTICAL) {
            EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_WHEEL, __mouseWheelHandler, false, COUNT++);
        }

        resetUI();
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

        resetUI();
    }

    /**
     * 获取当前的数值
     * @return
     */
    public function getValue() : int {
        return _currentValue;
    }

    /**
     * 重置UI
     */
    public function resetUI() : void {
        var range : int = _max - _min;
        if (range <= 0) {
            range = 1;
        }

        _sliderBtn.visible = (_max > _min);

        if (_mode == SliderMode.VERTICAL) {
            var maxUIH : int = _sliderBg.height;
            _sliderBtn.x = _sliderBg.x + (_sliderBg.width - _sliderBtn.width) / 2;
            _uiStepLen = (maxUIH - _sliderBtn.height) / range;
            var maxHeight : int = maxUIH - _sliderBtn.height;
            var per : Number = _currentValue / range;
            _sliderBtn.y = _sliderBg.y + per * maxHeight;
        } else {
            var maxUIW : int = _sliderBg.width;
            _sliderBtn.y = _sliderBg.y + (_sliderBg.height - _sliderBtn.height) / 2;
            _uiStepLen = (maxUIW - _sliderBtn.width) / range;
            var maxWidth : int = _sliderBg.width - _sliderBtn.width;
            per = _currentValue / range;
            _sliderBtn.x = _sliderBg.x + per * maxWidth;
        }
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
        if (_currentValue == _lastValue) {
            return;
        }
        _lastValue = _currentValue;

        var range : int = _max - _min;
        if (range <= 0) {
            range = 1;
        }
        if (_mode == SliderMode.VERTICAL) {
            var maxHeight : int = _sliderBg.height - _sliderBtn.height;
            var per : Number = _currentValue / range;
            _sliderBtn.y = _sliderBg.y + per * maxHeight;
        } else {
            var maxWidth : int = _sliderBg.width - _sliderBtn.width;
            per = _currentValue / range;
            _sliderBtn.x = _sliderBg.x + per * maxWidth;
        }

        dispatchEvent(new SliderEvent(SliderEvent.DATA_UPDATE, _currentValue));
    }

    protected function __downHandler(e : MouseEvent) : void {
        if (_mode == SliderMode.VERTICAL) {
            _downX = _sliderBtn.y;
            _downMouseX = EnterFrameCall.getStage().mouseY;
        } else {
            _downX = _sliderBtn.x;
            _downMouseX = EnterFrameCall.getStage().mouseX;
        }
        EnterFrameCall.add(enterFrameHandler);
    }

    protected function __upHandler(e : MouseEvent) : void {
        EnterFrameCall.del(enterFrameHandler);
        __upMoreHandler();
    }

    protected function __mouseWheelHandler(e : MouseEvent) : void {
        if (_sliderBtn.stage == null) {
            return;
        }

        e.stopImmediatePropagation();
        e.stopPropagation();
        var lastValue : int = _currentValue;

        var delta : int = e.delta;
        if (e.delta < 0) {
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

    /**
     * 更新值
     */
    protected function enterFrameHandler() : void {
        if (_mode == SliderMode.VERTICAL) {
            var stageY : Number = EnterFrameCall.getStage().mouseY;
            var locationX : Number = _downX + stageY - _downMouseX;

            var maxY : Number = _sliderBg.y + _sliderBg.height;
            locationX = locationX < _sliderBg.y ? _sliderBg.y : locationX;
            locationX = locationX > maxY ? maxY : locationX;

            locationX -= _sliderBg.y;
        } else {
            var stageX : Number = EnterFrameCall.getStage().mouseX;
            locationX = _downX + stageX - _downMouseX;

            var maxX : Number = _sliderBg.x + _sliderBg.width;
            locationX = locationX < _sliderBg.x ? _sliderBg.x : locationX;
            locationX = locationX > maxX ? maxX : locationX;

            locationX -= _sliderBg.x;
        }


        _currentValue = Math.round(locationX / _uiStepLen);
        _currentValue = _currentValue - _currentValue % _step;
        if (_currentValue > _max) {
            _currentValue = _max;
        }
        if (_currentValue < _min) {
            _currentValue = _min;
        }

        updateUiByValue();
    }

    public function dispose() : void {
        if (_prevBtn != null) {
            _prevBtn.removeEventListener(MouseEvent.MOUSE_DOWN, __downMoreHandler);
            _prevBtn.removeEventListener(MouseEvent.MOUSE_UP, __upMoreHandler);
        }

        if (_nextBtn != null) {
            _nextBtn.removeEventListener(MouseEvent.MOUSE_DOWN, __downMoreHandler);
            _nextBtn.removeEventListener(MouseEvent.MOUSE_UP, __upMoreHandler);
        }
        _sliderBtn.removeEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
        EnterFrameCall.getStage().removeEventListener(MouseEvent.MOUSE_UP, __upHandler);
        EnterFrameCall.getStage().removeEventListener(MouseEvent.MOUSE_WHEEL, __mouseWheelHandler);

        _prevBtn = null;
        _nextBtn = null;
        _sliderBtn = null;
        _sliderBg = null;
        _isInit = false;
        EnterFrameCall.del(enterFrameHandler);
    }
}
}
