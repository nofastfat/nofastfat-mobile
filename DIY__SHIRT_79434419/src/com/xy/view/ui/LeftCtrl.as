package com.xy.view.ui {
import com.greensock.TweenLite;
import com.xy.component.buttons.ToggleButton;
import com.xy.component.buttons.ToggleButtonGroup;
import com.xy.component.buttons.event.ToggleButtonGroupEvent;
import com.xy.ui.BackgroundBtn;
import com.xy.ui.DecorateBtn;
import com.xy.ui.FontBtn;
import com.xy.ui.FrameBtn;
import com.xy.ui.ImageBtn;
import com.xy.util.EnterFrameCall;
import com.xy.view.ui.ctrls.AbsContainer;
import com.xy.view.ui.ctrls.BackgroundContainer;
import com.xy.view.ui.ctrls.DecorateContainer;
import com.xy.view.ui.ctrls.FontContainer;
import com.xy.view.ui.ctrls.FrameContainer;
import com.xy.view.ui.ctrls.ImageContainer;

import flash.debugger.enterDebugger;
import flash.display.MovieClip;
import flash.display.Sprite;

public class LeftCtrl extends Sprite {
    private var _togGroup : ToggleButtonGroup;
    private var _btns : Array = [];
    private var _containers : Array = [];
    private var _eachHeight : int;

    private var _offsets : Array = [];

    public function LeftCtrl() {
        super();

        _btns = [
            new ImageBtn(),
            new FontBtn(),
            new BackgroundBtn(),
            new DecorateBtn(),
            new FrameBtn()
            ];

        _eachHeight = _btns[0].height;

        _containers = [
            new ImageContainer(),
            new FontContainer(),
            new BackgroundContainer(),
            new DecorateContainer(),
            new FrameContainer()
            ];

        var togBtns : Array = [];

        for (var i : int = 0; i < _containers.length; i++) {
            _offsets[i] = 0;
            addChild(_btns[i]);
			_btns[i].y = -1;
            addChild(_containers[i]);

            togBtns.push(new ToggleButton(_btns[i]));
        }

        _togGroup = new ToggleButtonGroup();
        _togGroup.setToggleButtons(togBtns);
        _togGroup.addEventListener(ToggleButtonGroupEvent.STATE_CHANGE, __stateChangeHandler);

        __stateChangeHandler();
    }

    private function __stateChangeHandler(e : ToggleButtonGroupEvent = null) : void {
        var totalHeight : int = EnterFrameCall.getStage().stageHeight;

        for (var i : int = 0; i < _btns.length; i++) {
            var btn : MovieClip = _btns[i];
            var targetY : int;
            if (i <= _togGroup.selectIndex) {
                targetY = _eachHeight * i;
            } else {
                targetY = totalHeight - (_btns.length - i) * _eachHeight;
            }

            _offsets[i] = targetY - btn.y;
        }

        EnterFrameCall.add(offsetAdd);
    }

    private function offsetAdd() : void {

        var needRemove : Boolean = true;
        for (var i : int = 0; i < _offsets.length; i++) {
            var speedX : Number = Math.abs(_offsets[i] * 0.35);
            if (speedX < 1) {
                speedX = 1;
            }


            if (_offsets[i] != 0) {
                if (Math.abs(_offsets[i]) < speedX) {
					_btns[i].y += _offsets[i];
					_containers[i].y = _btns[i].y + _btns[i].height;
                    _offsets[i] = 0;
                } else {
                    var cal : int = _offsets[i] < 0 ? -speedX : speedX;
					_btns[i].y += cal;
					_containers[i].y = _btns[i].y + _btns[i].height;
                    _offsets[i] -= cal;
                }
            }

            if (_offsets[i] != 0) {
                needRemove = false;
            }
        }

        if (needRemove) {
            EnterFrameCall.del(offsetAdd);
        }

    }

    public function resize() : void {
        var totalHeight : int = EnterFrameCall.getStage().stageHeight;
        for each (var container : AbsContainer in _containers) {
            container.resize(totalHeight - _eachHeight * _btns.length);
        }
        __stateChangeHandler();
    }
}
}
