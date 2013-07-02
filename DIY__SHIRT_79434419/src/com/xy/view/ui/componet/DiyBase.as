package com.xy.view.ui.componet {
import com.xy.model.vo.EditVo;
import com.xy.util.Rotator;
import com.xy.util.STool;
import com.xy.util.Tools;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;

public class DiyBase extends Sprite {
    private var _rotate : Rotator;

    private var _bg : ResizeBg;

    protected var _editVo : EditVo;

    public function DiyBase(id : String = null) {
        super();
        if (id == null) {
            id = Tools.makeId();
        }

        _bg = new ResizeBg(this);
        _rotate = new Rotator(this);
        _editVo = new EditVo(id);
    }

    public function setByEditVo(vo : EditVo) : void {
        _editVo = vo;
        var ix : Number = vo.ix;
        var iy : Number = vo.iy;

        _rotate.rotation = vo.rotation;
        _bg.getRotate().rotation = vo.rotation;

        if (vo.lastP != null) {
            var dis : DisplayObject = getChildAt(0);
			dis.x = vo.childX;
			dis.y = vo.childY;
			vo.registerIndex = 0;
            var p : Point = new Point(vo.realW - dis.width, vo.realH - dis.height);
            p = p.add(vo.lastP);
            p = localToGlobal(p);
            scaleTo(p.x, p.y);
        }

        x = ix;
        y = iy;
        _bg.resize();

        resetRegister();

    }

    public function moveOffset(ix : Number, iy : Number) : void {
        x += ix;
        y += iy;

        resetRegister();
        _bg.moveOffset(ix, iy);
    }

    public function resetRegister() : void {
        var mat : Matrix = new Matrix();
        var center : Point = new Point(realW / 2 + childX, realH / 2 + childY);
        mat.rotate(rotation * Math.PI / 180);
        center = mat.transformPoint(center);

        center.offset(x, y);
        _rotate.setRegistrationPoint(center);
    }

    public function recordStage(w : int, h : int) : void {
        var dis : DisplayObject = getChildAt(0);
        _editVo.lastP = new Point(w, h);
        _editVo.lastP = globalToLocal(_editVo.lastP);
    }

    public function scaleTo(w : int, h : int) : void {
        var dis : DisplayObject = getChildAt(0);
        var p : Point = new Point(w, h);
        p = globalToLocal(p);
        var record : Point = p.clone();
        p = p.subtract(_editVo.lastP);
        _editVo.lastP = record;

        var nowX : int = dis.x;
        var nowY : int = dis.y;
        switch (_editVo.registerIndex) {
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
        setChild0Size(Math.abs(p.x), Math.abs(p.y));
        childX = dis.x;
        childY = dis.y;

        _editVo.realW = dis.width;
        _editVo.realH = dis.height;

        resetRegister();
        drawBorder();
    }

    protected function setChild0Size(w : Number, h : Number) : void {
        var dis : DisplayObject = getChildAt(0);
        dis.width = w;
        dis.height = h;
    }

    public function resetScaleRegisterTo(index : int) : void {
        _editVo.registerIndex = index;
    }

    public function setLineSickness(sickness : int) : void {
        _editVo.lineSickness = sickness;
        drawBorder();
    }

    public function setColor(color : uint) : void {
        _editVo.lineColor = color;
        drawBorder();
    }

    public function setAlpha(alpha : Number) : void {
        this.alpha = alpha;
        _editVo.alpha = alpha;
    }

    public function upLevel() : void {
        if (parent != null) {
            var childIndex : int = parent.getChildIndex(this);
            childIndex++;
            if (childIndex < parent.numChildren) {
                parent.setChildIndex(this, childIndex);
            }
        }
    }

    public function downLevel() : void {
        if (parent != null) {
            var childIndex : int = parent.getChildIndex(this);
            childIndex--;
            if (childIndex >= 0) {
                parent.setChildIndex(this, childIndex);
            }
        }
    }

    public function deleted() : void {
        destroy();
    }

    public function destroy() : void {
        _bg.destroy();
        _bg = null;

        STool.clear(this);
        STool.remove(this);
        _editVo = null;
    }

    private function drawBorder() : void {
        graphics.clear();

        if (_editVo.lineSickness != 0) {
            graphics.lineStyle(_editVo.lineSickness, _editVo.lineColor);
            graphics.drawRect(-_editVo.lineSickness / 2 + childX, -_editVo.lineSickness / 2 + childY, realW + _editVo.lineSickness, realH + _editVo.lineSickness);
        }
    }

    public function get editVo() : EditVo {
        return _editVo;
    }

    public function get id() : String {
        return _editVo.id;
    }

    public function get childX() : Number {
        return _editVo.childX;
    }

    public function get childY() : Number {
        return _editVo.childY;
    }

    public function set childX(value : Number) : void {
        _editVo.childX = value;
    }

    public function set childY(value : Number) : void {
        _editVo.childY = value;
    }

    public function get realH() : Number {
        return _editVo.realH;
    }

    public function get realW() : Number {
        return _editVo.realW;
    }

    public function get rotate() : Rotator {
        return _rotate;
    }

    public function get bg() : ResizeBg {
        return _bg;
    }

    override public function set rotation(value : Number) : void {
        super.rotation = value;

        _editVo.rotation = value;
    }

    override public function set x(value : Number) : void {
        super.x = value;
        _editVo.ix = x;
    }

    override public function set y(value : Number) : void {
        super.y = value;
        _editVo.iy = y;
    }

}
}
