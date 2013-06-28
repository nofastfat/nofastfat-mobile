package com.xy.view.ui.componet {
import com.xy.util.Rotator;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Point;

public class DiyBase extends Sprite {
    private var _rotate : Rotator;

    private var _bg : ResizeBg;

    protected var _realW : Number;
    protected var _realH : Number;

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
        var center : Point = new Point(_realW / 2, _realH / 2);
        mat.rotate(rotation * Math.PI / 180);
        center = mat.transformPoint(center);

        center.offset(x, y);
        _rotate.setRegistrationPoint(center);
    }

    public function scaleOffset(offsetW : Number, offsetH : Number) : void {
        width += offsetW;
        height += offsetH;

        _realW += offsetW;
        _realH += offsetH;
    }


}
}
