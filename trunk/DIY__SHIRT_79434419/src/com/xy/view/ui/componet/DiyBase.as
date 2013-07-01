package com.xy.view.ui.componet {
import com.xy.model.vo.EditVo;
import com.xy.util.Rotator;
import com.xy.util.STool;

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

    protected var _editVo : EditVo;

    public function DiyBase() {
        super();

        _bg = new ResizeBg(this);
        _rotate = new Rotator(this);
        _editVo = new EditVo();
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
        setChild0Size(Math.abs(p.x), Math.abs(p.y));
        childX = dis.x;
        childY = dis.y;

        _realW = dis.width;
        _realH = dis.height;

        resetRegister();
        drawBorder();
    }
    
    protected function setChild0Size(w : Number, h : Number):void{
        var dis : DisplayObject = getChildAt(0);
        dis.width = w;
        dis.height = h;
    }

    public function resetScaleRegisterTo(index : int) : void {
        _registerIndex = index;
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
    	if(parent != null){
    		var childIndex : int = parent.getChildIndex(this);
    		childIndex++;
    		if(childIndex < parent.numChildren){
    			parent.setChildIndex(this, childIndex);
    		}
    	}
    }

    public function downLevel() : void {
    	if(parent != null){
    		var childIndex : int = parent.getChildIndex(this);
    		childIndex--;
    		if(childIndex >= 0){
    			parent.setChildIndex(this, childIndex);
    		}
    	}
    }

    public function deleted() : void {
    	destroy();
    }
    
	public function destroy():void{
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
            graphics.drawRect(-_editVo.lineSickness / 2 + childX, -_editVo.lineSickness / 2 + childY, _realW + _editVo.lineSickness, _realH + _editVo.lineSickness);
        }
    }


    public function get editVo() : EditVo {
        return _editVo;
    }

}
}
