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
import com.xy.view.ui.ctrls.BackgroundContainer;
import com.xy.view.ui.ctrls.DecorateContainer;
import com.xy.view.ui.ctrls.FontContainer;
import com.xy.view.ui.ctrls.FrameContainer;
import com.xy.view.ui.ctrls.ImageContainer;

import flash.display.MovieClip;
import flash.display.Sprite;

public class LeftCtrl extends Sprite {
    private var _togGroup : ToggleButtonGroup;
    private var _btns : Array = [];
    private var _containers : Array = [];
    private var _eachHeight : int;

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
            addChild(_btns[i]);
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
            var container : Sprite = _containers[i];
            if (i == _togGroup.selectIndex) {
                container.y = targetY + _eachHeight;
            }

            if (targetY != btn.y) {
                TweenLite.to(btn, 0.3, {
                        y: targetY,
                        overwrite: true,
                        onCompleteParams: [container, i == _togGroup.selectIndex],
                        onComplete: function(con : Sprite, show : Boolean) : void {
                            con.visible = show;
                        }
                    });
            }
        }
    }
	
	public function resize():void{
		__stateChangeHandler();
	}
}
}
