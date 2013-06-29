package com.xy.view.ui.componet {
import com.xy.util.Rotator;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;

public class DiyBase extends Sprite {
    private var _rotate : Rotator;

    private var _bg : ResizeBg;

    protected var _realW : Number;
    protected var _realH : Number;

    protected var _registerIndex : int = 0;

    public var childX : Number = 0;
    public var childY : Number = 0;

    public function DiyBase() {
        super();

        _bg = new ResizeBg(this);
        _rotate = new Rotator(this);
    }

    public function get realH() : Number {
        return _realH;
    }

    public function get realW() : Number {
        return _realW;
    }

    public function get rotate() : Rotator {
        return _rotate;
    }

    public function get bg() : ResizeBg {
        return _bg;
    }

    public function moveOffset(ix : Number, iy : Number) : void {
        x += ix;
        y += iy;

        resetRegister();
        _bg.moveOffset(ix, iy);
    }

    public function resetRegister() : void {
        var mat : Matrix = new Matrix();
        var center : Point = new Point(_realW / 2 + childX, _realH / 2 + childY);
        mat.rotate(rotation * Math.PI / 180);
        center = mat.transformPoint(center);

        center.offset(x, y);
        _rotate.setRegistrationPoint(center);
    }

    private var _lastP : Point;

    public function recordStage(w : int, h : int) : void {
        var dis : DisplayObject = getChildAt(0);
        _lastP = new Point(w, h);
        _lastP = globalToLocal(_lastP);
    }

    public function scaleTo(w : int, h : int) : void {
        var dis : DisplayObject = getChildAt(0);
        var p : Point = new Point(w, h);
        p = globalToLocal(p);
        var record : Point = p.clone();
        p = p.subtract(_lastP);
        _lastP = record;

        var nowX : int = dis.x;
        var nowY : int = dis.y;
        switch (_registerIndex) {
            case 0:
                p.x += dis.width;
                p.y += dis.height;
                break;
            case 1:
                p.x *= -1;
                dis.x -= p.x;
                p.x += dis.width;
                p.y += dis.height;
                break;
            case 2:
                p.y *= -1;
                dis.y -= p.y;
                p.x += dis.width;
                p.y += dis.height;
                break;
            case 3:
                p.x *= -1;
                p.y *= -1;
                dis.x -= p.x;
                dis.y -= p.y;

                p.x += dis.width;
                p.y += dis.height;
                break;
        }
        dis.width = Math.abs(p.x);
        dis.height = Math.abs(p.y);
        childX = dis.x;
        childY = dis.y;

        _realW = dis.width;
        _realH = dis.height;

        resetRegister();
    }

    public function resetScaleRegisterTo(index : int) : void {
        _registerIndex = index;
    }

}
}
