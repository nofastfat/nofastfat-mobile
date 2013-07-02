package com.xy.view.ui.componet {
import com.xy.model.DiyDataProxy;
import com.xy.ui.BitmapDragButton;
import com.xy.ui.Resize1Icon;
import com.xy.ui.Resize2Icon;
import com.xy.ui.RotationIcon;
import com.xy.util.EnterFrameCall;
import com.xy.util.Rotator;
import com.xy.util.STool;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

import org.puremvc.as3.patterns.facade.Facade;

public class ResizeBg extends Sprite {

    private var _rotationMc : Sprite;
    private var _leftTopMc : Sprite;
    private var _leftBottomMc : Sprite
    private var _rightTopMc : Sprite;
    private var _rightBottomMc : Sprite;

    private var _resize1Icon : Resize1Icon;
    private var _resize2Icon : Resize2Icon;
    private var _rotationIcon : RotationIcon;

    private var _diy : DiyBase;

    private var _mouseIsDown : Boolean;

    private var _w : Number;
    private var _h : Number;

    private var _rotate : Rotator;

    private var _bmdDragBtn : BitmapDragButton;

    private var _isSimpleShow : Boolean = false;

    public function ResizeBg(diyBase : DiyBase) {
        super();

        _diy = diyBase;

        _rotate = new Rotator(this);

        _rotationMc = makeRotationMc();
        _leftTopMc = makeReszieMc();
        _leftBottomMc = makeReszieMc();
        _rightTopMc = makeReszieMc();
        _rightBottomMc = makeReszieMc();

        _resize1Icon = new Resize1Icon();
        _resize2Icon = new Resize2Icon();
        _rotationIcon = new RotationIcon();

        _bmdDragBtn = new BitmapDragButton();

        addChild(_rotationMc);
        addChild(_leftTopMc);
        addChild(_leftBottomMc);
        addChild(_rightTopMc);
        addChild(_rightBottomMc);

        _resize1Icon.mouseChildren = false;
        _resize1Icon.mouseEnabled = false;
        _resize2Icon.mouseChildren = false;
        _resize2Icon.mouseEnabled = false;
        _rotationIcon.mouseChildren = false;
        _rotationIcon.mouseEnabled = false;

        mouseEnabled = false;

        _rotationMc.addEventListener(MouseEvent.ROLL_OVER, __rotationOverHandler);
        _rotationMc.addEventListener(MouseEvent.ROLL_OUT, __outHandler);
        _rotationMc.addEventListener(MouseEvent.MOUSE_DOWN, __rotationDownHandler);

        _leftTopMc.addEventListener(MouseEvent.ROLL_OVER, __resize1OverHandler);
        _leftTopMc.addEventListener(MouseEvent.ROLL_OUT, __outHandler);
        _rightBottomMc.addEventListener(MouseEvent.ROLL_OVER, __resize1OverHandler);
        _rightBottomMc.addEventListener(MouseEvent.ROLL_OUT, __outHandler);
        _leftTopMc.addEventListener(MouseEvent.MOUSE_DOWN, __down1Handler);
        _rightBottomMc.addEventListener(MouseEvent.MOUSE_DOWN, __down1Handler);

        _leftBottomMc.addEventListener(MouseEvent.ROLL_OVER, __resize2OverHandler);
        _leftBottomMc.addEventListener(MouseEvent.ROLL_OUT, __outHandler);
        _rightTopMc.addEventListener(MouseEvent.ROLL_OVER, __resize2OverHandler);
        _rightTopMc.addEventListener(MouseEvent.ROLL_OUT, __outHandler);
        _leftBottomMc.addEventListener(MouseEvent.MOUSE_DOWN, __down2Handler);
        _rightTopMc.addEventListener(MouseEvent.MOUSE_DOWN, __down2Handler);

        _bmdDragBtn.addEventListener(MouseEvent.ROLL_OVER, __overDragHandler);
        _bmdDragBtn.addEventListener(MouseEvent.ROLL_OUT, __outDragHandler);
        _bmdDragBtn.addEventListener(MouseEvent.MOUSE_DOWN, __downDragHandler);

        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_UP, __upHandler);
    }

    private function __rotationOverHandler(e : MouseEvent) : void {
        Mouse.hide();
        EnterFrameCall.getStage().addChild(_rotationIcon);
        move();
        EnterFrameCall.add(move);
    }

    private function __outHandler(e : MouseEvent) : void {
        if (!_mouseIsDown) {
            Mouse.show();
            STool.remove(_resize1Icon);
            STool.remove(_resize2Icon);
            STool.remove(_rotationIcon);
        }
    }

    private function __resize1OverHandler(e : MouseEvent) : void {
        Mouse.hide();
        EnterFrameCall.getStage().addChild(_resize1Icon);
        _resize1Icon.rotation = rotation;
        move();
        EnterFrameCall.add(move);
    }

    private function __resize2OverHandler(e : MouseEvent) : void {
        Mouse.hide();
        EnterFrameCall.getStage().addChild(_resize2Icon);
        _resize2Icon.rotation = rotation;
        move();
        EnterFrameCall.add(move);
    }

    private function move() : void {
        var mouseX : Number = EnterFrameCall.getStage().mouseX;
        var mouseY : Number = EnterFrameCall.getStage().mouseY;
        if (_rotationIcon != null && _rotationIcon.stage != null) {
            _rotationIcon.x = mouseX;
            _rotationIcon.y = mouseY;
        }
        if (_resize1Icon != null && _resize1Icon.stage != null) {
            _resize1Icon.x = mouseX;
            _resize1Icon.y = mouseY;
        }
        if (_resize2Icon != null && _resize2Icon.stage != null) {
            _resize2Icon.x = mouseX;
            _resize2Icon.y = mouseY;
        }
    }

    private var _stageP : Point;
    private var _lastAngle : Number;

    private function __rotationDownHandler(e : MouseEvent) : void {
        Mouse.hide();
        EnterFrameCall.getStage().addChild(_rotationIcon);
        _mouseIsDown = true;

        var stageX : Number = EnterFrameCall.getStage().mouseX;
        var stageY : Number = EnterFrameCall.getStage().mouseY;

        _lastAngle = Math.atan2(stageX - _stageP.x, stageY - _stageP.y);
        _lastAngle = 180 - _lastAngle * 180 / Math.PI;
        EnterFrameCall.add(rotate);
    }

    private function rotate() : void {
        var stageX : Number = EnterFrameCall.getStage().mouseX;
        var stageY : Number = EnterFrameCall.getStage().mouseY;

        var angle : Number = Math.atan2(stageX - _stageP.x, stageY - _stageP.y);

        angle = 180 - angle * 180 / Math.PI;

        var rs : Number = angle - _lastAngle;

        _rotate.rotateBy(rs);
        _diy.rotate.rotateBy(rs);

        _lastAngle = angle;
    }

	public function getRotate():Rotator{
		return _rotate;
	}


    private function resizeWH() : void {
        var stageX : Number = EnterFrameCall.getStage().mouseX;
        var stageY : Number = EnterFrameCall.getStage().mouseY;

        scaleTo(stageX, stageY);
    }

    private function scaleTo(stageX : Number, stageY : Number) : void {
        _diy.scaleTo(stageX, stageY);
        resize();
    }

    private function __down1Handler(e : MouseEvent) : void {
        if (e.currentTarget == _rightBottomMc) {
            _diy.resetScaleRegisterTo(0);
        } else {
            _diy.resetScaleRegisterTo(3);
        }

        Mouse.hide();
        EnterFrameCall.getStage().addChild(_resize1Icon);
        _mouseIsDown = true;
        _diy.recordStage(EnterFrameCall.getStage().mouseX, EnterFrameCall.getStage().mouseY);

        EnterFrameCall.add(resizeWH);
    }

    private function __down2Handler(e : MouseEvent) : void {
        if (e.currentTarget == _rightTopMc) {
            _diy.resetScaleRegisterTo(2);
        } else {
            _diy.resetScaleRegisterTo(1);
        }
        Mouse.hide();
        EnterFrameCall.getStage().addChild(_resize2Icon);
        _mouseIsDown = true;
        _diy.recordStage(EnterFrameCall.getStage().mouseX, EnterFrameCall.getStage().mouseY);

        EnterFrameCall.add(resizeWH);
    }

    private function __overDragHandler(e : MouseEvent) : void {
        Mouse.cursor = MouseCursor.HAND;
    }

    private function __outDragHandler(e : MouseEvent) : void {
        Mouse.cursor = MouseCursor.AUTO;
    }

    private function __downDragHandler(e : MouseEvent) : void {
        Mouse.cursor = MouseCursor.HAND;
        _lastX = EnterFrameCall.getStage().mouseX;
        _lastY = EnterFrameCall.getStage().mouseY;

        EnterFrameCall.add(dragBmd);
    }

    private var _lastX : Number;
    private var _lastY : Number;

    private function dragBmd() : void {
        Mouse.cursor = MouseCursor.HAND;
        var stageX : Number = EnterFrameCall.getStage().mouseX;
        var stageY : Number = EnterFrameCall.getStage().mouseY;

        var offsetX : Number = stageX - _lastX;
        var offsetY : Number = stageY - _lastY;

        if (_diy is DiySystemImage) {
            (_diy as DiySystemImage).bmdMoveOffset(offsetX, offsetY);
        }

        _lastX = stageX;
        _lastY = stageY;
    }

    private function __upHandler(e : MouseEvent) : void {
        Mouse.show();
        Mouse.cursor = MouseCursor.AUTO;
        STool.remove(_resize1Icon);
        STool.remove(_resize2Icon);
        STool.remove(_rotationIcon);

        EnterFrameCall.del(rotate);
        EnterFrameCall.del(move);
        EnterFrameCall.del(resizeWH);
        EnterFrameCall.del(dragBmd);
        _mouseIsDown = false;
    }

    public function showTo(parent : Sprite, simpleShow : Boolean = false) : void {
        parent.addChild(this);
        _isSimpleShow = simpleShow;

        _leftTopMc.visible = _leftBottomMc.visible = _rightBottomMc.visible = _rightTopMc.visible = _rotationMc.visible = !_isSimpleShow;

        resize();
    }

    public function hide() : void {
        STool.remove(this);
    }

    public function resize() : void {
        var p1 : Point = new Point(_diy.childX, _diy.childY);
        var mat : Matrix = new Matrix()
        mat.rotate(rotation * Math.PI / 180);
        p1 = mat.transformPoint(p1);

        var p : Point = new Point(_diy.x + p1.x, _diy.y + p1.y);
        p = _diy.parent.localToGlobal(p);
        p = parent.globalToLocal(p);
        this.x = p.x;
        this.y = p.y;

        _w = _diy.realW;
        _h = _diy.realH;

        graphics.clear();

        graphics.lineStyle(2, 0xE3A96C);
        graphics.drawRect(-2, -2, _w + 4, _h + 4);
        graphics.endFill();

        if (!_isSimpleShow) {
            graphics.moveTo(_w / 2, _h / 2);
            graphics.lineTo(_w / 2, -50);
        }

        _rotationMc.x = _w / 2;
        _rotationMc.y = -50;

        _leftBottomMc.y = _h;

        _rightTopMc.x = _w;

        _rightBottomMc.x = _w;
        _rightBottomMc.y = _h;

        _bmdDragBtn.x = _w / 2;
        _bmdDragBtn.y = _h / 2;

        resetRegister();

        if (_diy.editVo.isFull) {
            addChild(_bmdDragBtn);
        } else {
            STool.remove(_bmdDragBtn);
        }
    }

    public function resetRegister() : void {

        var mat : Matrix = new Matrix();
        var center : Point = new Point(_w / 2, _h / 2);
        mat.rotate(rotation * Math.PI / 180);
        center = mat.transformPoint(center);
        center.offset(x, y);
        _stageP = parent.localToGlobal(center);
        _rotate.setRegistrationPoint(center);
    }

    public function moveOffset(ix : Number, iy : Number) : void {
        x += ix;
        y += iy;

        resetRegister();
    }

    private function makeRotationMc() : Sprite {
        var sizeW : int = 12;
        var sizeH : int = 8;
        var sp : Sprite = new Sprite();
        sp.graphics.beginFill(0xE4AA6D);
        sp.graphics.drawEllipse(-sizeW / 2, -sizeH / 2, sizeW, sizeH);
        sp.graphics.endFill();

        return sp;
    }

    private function makeReszieMc() : Sprite {
        var sizeW : int = 8;
        var sizeH : int = 6;
        var sp : Sprite = new Sprite();
        sp.graphics.lineStyle(1, 0xcccccc);
        sp.graphics.beginFill(0xF07C03);
        sp.graphics.drawRect(-sizeW / 2, -sizeH / 2, sizeW, sizeH);
        sp.graphics.endFill();

        return sp;
    }

    public function destroy() : void {
        EnterFrameCall.del(rotate);
        EnterFrameCall.del(move);
        EnterFrameCall.del(resizeWH);
        EnterFrameCall.del(dragBmd);

        _rotationMc.removeEventListener(MouseEvent.ROLL_OVER, __rotationOverHandler);
        _rotationMc.removeEventListener(MouseEvent.ROLL_OUT, __outHandler);
        _rotationMc.removeEventListener(MouseEvent.MOUSE_DOWN, __rotationDownHandler);


        _leftTopMc.removeEventListener(MouseEvent.ROLL_OVER, __resize1OverHandler);
        _leftTopMc.removeEventListener(MouseEvent.ROLL_OUT, __outHandler);
        _rightBottomMc.removeEventListener(MouseEvent.ROLL_OVER, __resize1OverHandler);
        _rightBottomMc.removeEventListener(MouseEvent.ROLL_OUT, __outHandler);
        _leftTopMc.removeEventListener(MouseEvent.MOUSE_DOWN, __down1Handler);
        _rightBottomMc.removeEventListener(MouseEvent.MOUSE_DOWN, __down1Handler);

        _leftBottomMc.removeEventListener(MouseEvent.ROLL_OVER, __resize2OverHandler);
        _leftBottomMc.removeEventListener(MouseEvent.ROLL_OUT, __outHandler);
        _rightTopMc.removeEventListener(MouseEvent.ROLL_OVER, __resize2OverHandler);
        _rightTopMc.removeEventListener(MouseEvent.ROLL_OUT, __outHandler);
        _leftBottomMc.removeEventListener(MouseEvent.MOUSE_DOWN, __down2Handler);
        _rightTopMc.removeEventListener(MouseEvent.MOUSE_DOWN, __down2Handler);

        _bmdDragBtn.removeEventListener(MouseEvent.ROLL_OVER, __overDragHandler);
        _bmdDragBtn.removeEventListener(MouseEvent.ROLL_OUT, __outDragHandler);
        _bmdDragBtn.removeEventListener(MouseEvent.MOUSE_DOWN, __downDragHandler);
        EnterFrameCall.getStage().removeEventListener(MouseEvent.MOUSE_UP, __upHandler);

        STool.clear(this);
        STool.remove(this);
        _diy = null;
        _leftBottomMc = null;
        _leftTopMc = null;
        _resize1Icon = null;
        _resize2Icon = null;
        _rotationIcon = null;
        _rightBottomMc = null;
        _rightTopMc = null;
        _rotate.destroy();
        _rotate = null;
        _rotationMc = null;
    }
}
}
