package com.xy.view.layer {
import com.xy.component.toolTip.ToolTip;
import com.xy.component.toolTip.enum.ToolTipMode;
import com.xy.ui.SwitchButton;
import com.xy.util.EnterFrameCall;
import com.xy.util.STool;
import com.xy.view.event.TreeContainerEvent;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

public class TreeContainer extends Sprite {
    private var _sWidth : int;
    private var _sHeight : int;

    private var _infoContainer : Sprite;
    private var _taskContainer : Sprite;
    private var _bg : Sprite;
    private var _switchBtn : SwitchButton;

    private var _lastLocation : Point = new Point();

    public function TreeContainer() {
        super();
        _bg = new Sprite();
        _bg.graphics.beginFill(0xFFFFFF);
        _bg.graphics.drawRect(0, 0, 1, 1);
        _bg.graphics.endFill();
        addChild(_bg);

        _switchBtn = new SwitchButton();

        _switchBtn.gotoAndStop(2);
        ToolTip.setSimpleTip(_switchBtn, "切换至执行地图", ToolTipMode.RIGHT_BOTTOM_CENTER);

        _bg.addEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_UP, __upHandler);

        _infoContainer = new Sprite();
        _taskContainer = new Sprite();
        switchContainer(true);
    }

    /**
     * 切换子容器
     * @param toInfo
     */
    public function switchContainer(toInfo : Boolean) : void {
        if (toInfo) {
            addChild(_infoContainer);
            STool.remove(_taskContainer);

            _bg.width = _sWidth;
            _bg.height = _sHeight;

            STool.remove(_switchBtn);
            resetUI();
        } else {

            addChild(_taskContainer);
            STool.remove(_infoContainer);
            _bg.width = EnterFrameCall.getStage().stageWidth;
            _bg.height = _sHeight;

            addChild(_switchBtn);
            resetUI();
        }
    }

    private function resetUI() : void {
        _switchBtn.x = _bg.width - _switchBtn.width - 10;
        _switchBtn.y = 5;
    }

    public function get infoContainer() : Sprite {
        return _infoContainer;
    }

    public function get taskContainer() : Sprite {
        return _taskContainer;
    }

    private function __downHandler(e : MouseEvent) : void {
        Mouse.cursor = MouseCursor.HAND;
        _lastLocation.x = EnterFrameCall.getStage().mouseX;
        _lastLocation.y = EnterFrameCall.getStage().mouseY;
        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_MOVE, __moveHandler);
    }

    private function __upHandler(e : MouseEvent) : void {
        Mouse.cursor = MouseCursor.AUTO;
        EnterFrameCall.getStage().removeEventListener(MouseEvent.MOUSE_MOVE, __moveHandler);
    }

    private function __moveHandler(e : MouseEvent) : void {
        var offsetX : Number = EnterFrameCall.getStage().mouseX - _lastLocation.x;
        var offsetY : Number = EnterFrameCall.getStage().mouseY - _lastLocation.y;

        if (_infoContainer.stage != null) {
            _infoContainer.dispatchEvent(new TreeContainerEvent(TreeContainerEvent.LOCATION_MOVE, offsetX, offsetY));
        } else {
            _taskContainer.dispatchEvent(new TreeContainerEvent(TreeContainerEvent.LOCATION_MOVE, offsetX, offsetY));
        }

        _lastLocation.x = EnterFrameCall.getStage().mouseX;
        _lastLocation.y = EnterFrameCall.getStage().mouseY;
    }

    /**
    * 舞台上允许显示的最大高
    * @return
    */
    public function get sHeight() : int {
        return _sHeight;
    }

    /**
     * 舞台上允许显示的最大宽
     * @return
     */
    public function get sWidth() : int {
        return _sWidth;
    }

    public function resize(newW : int, newH : int) : void {
        _sWidth = newW;
        _sHeight = newH;

        _bg.width = _sWidth;
        _bg.height = _sHeight;
        resetUI();
    }

    public function get switchBtn() : MovieClip {
        return _switchBtn;
    }
}
}
