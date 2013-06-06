package com.xy.view.layer {
import com.xy.util.EnterFrameCall;
import com.xy.view.event.TreeContainerEvent;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

public class TreeContainer extends Sprite {
    private var _sWidth : int;
    private var _sHeight : int;

    private var _container : Sprite;
    private var _bg : Sprite;

    private var _lastLocation : Point = new Point();

    public function TreeContainer() {
        super();
        _bg = new Sprite();
        _bg.graphics.beginFill(0xFFFFFF);
        _bg.graphics.drawRect(0, 0, 1, 1);
        _bg.graphics.endFill();
        addChild(_bg);

        _bg.addEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_UP, __upHandler);

        _container = new Sprite();
        addChild(_container);
    }

    public function get container() : Sprite {
        return _container;
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
        dispatchEvent(new TreeContainerEvent(TreeContainerEvent.LOCATION_MOVE, offsetX, offsetY));

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
    }
}
}
