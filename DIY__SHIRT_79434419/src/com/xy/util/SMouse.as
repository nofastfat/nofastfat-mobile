package com.xy.util {
import com.xy.model.vo.BitmapDataVo;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.Font;
import flash.text.TextField;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

public class SMouse {

    private static var _intance : SMouse;

    public static function getInstance() : SMouse {
        if (_intance == null) {
            _intance = new SMouse();
        }

        return _intance;
    }

    private var _bmp : Bitmap;
    private var _currentVo : BitmapDataVo;
    private var _offsetX : int;
    private var _offsetY : int;
    private var _hotArea : Rectangle;
    private var _textShape : Sprite;
    private var _tf : TextField;

    /**
     * 0==图片，1==字体
     */
    private var _mouseType : int;

    public function SMouse() {
        _bmp = new Bitmap();
        _textShape = new Sprite();
        _textShape.mouseChildren = false;
        _textShape.mouseEnabled = false;

        _textShape.graphics.beginFill(0xFFFFFF);
        _textShape.graphics.lineStyle(1, 0x000000);
        _textShape.graphics.drawRect(0, 0, 100, 20);
        _textShape.graphics.endFill();
        _tf = new TextField();
        _textShape.addChild(_tf);
        _tf.width = 100;
        _tf.height = 20;
    }

    public function setHotArea(rect : Rectangle) : void {
        _hotArea = rect;
    }

    public function setMouseFont(font : Font) : void {
        _mouseType = 1;
        _tf.htmlText = "<font face='" + font.fontName + "'>这里输入文字</font>";
        EnterFrameCall.getStage().addChild(_textShape);
        startMouse();
    }

    public function setMouseBmd(vo : BitmapDataVo, mouseX : int = 0, mouseY : int = 0) : void {
        _mouseType = 0;
        _currentVo = vo;
        _bmp.bitmapData = _currentVo.bmd;

        var scaleX : Number = 100 / _currentVo.bmd.width;
        var scaleY : Number = 100 / _currentVo.bmd.height;
        var scale : Number;

        if (scaleX < 1 || scaleY < 1 || (scaleX > 1 && scaleY > 1)) {
            scale = Math.min(scaleX, scaleY);
        } else {
            scale = Math.max(scaleX, scaleY);
        }

        if (scale >= 1) {
            _bmp.scaleX = _bmp.scaleY = 1;
            _offsetX = mouseX / scale;
            _offsetY = mouseY / scale;
        } else {
            _bmp.scaleX = _bmp.scaleY = scale;
            _offsetX = mouseX;
            _offsetY = mouseY;
        }

        EnterFrameCall.getStage().addChild(_bmp);
        startMouse();
    }

    private function startMouse() : void {
        Mouse.cursor = MouseCursor.HAND;
        move();

        EnterFrameCall.add(move);

        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_UP, __upHandler);
    }

    private function move() : void {
        var stageX : Number = EnterFrameCall.getStage().stage.mouseX;
        var stageY : Number = EnterFrameCall.getStage().stage.mouseY;
        switch (_mouseType) {
            case 0:
                _bmp.x = stageX - _offsetX;
                _bmp.y = stageY - _offsetY;
                break;
            case 1:
                _textShape.x = stageX - 50;
                _textShape.y = stageY - 10;
                break;
        }
    }

    private function __upHandler(e : MouseEvent) : void {
        EnterFrameCall.del(move);
        Mouse.cursor = MouseCursor.AUTO;
        STool.remove(_bmp);
        STool.remove(_textShape);

        if (_hotArea != null && _hotArea.contains(e.stageX, e.stageY)) {

        }
    }
}
}
