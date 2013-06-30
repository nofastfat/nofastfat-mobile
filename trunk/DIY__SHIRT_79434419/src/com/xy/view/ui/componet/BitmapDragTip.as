package com.xy.view.ui.componet {
import com.xy.model.DiyDataProxy;
import com.xy.util.EnterFrameCall;

import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Rectangle;

import org.puremvc.as3.patterns.facade.Facade;

public class BitmapDragTip extends Sprite {
    private var _diy : DiySystemImage;

    private var _bmp : Bitmap;

    private var _rect : Shape;

    public function BitmapDragTip() {
        super();
        _bmp = new Bitmap();
        _rect = new Shape();
        addChild(_bmp);
        addChild(_rect);
    }

    public function showBy(diy : DiySystemImage) : void {
        if (!diy.editVo.isFull) {
            return;
        }
        _diy = diy;
        _bmp.bitmapData = diy.vo.bmd;
        var modelRect : Rectangle = dataProxy.currentSelectModel.rect;

        var scaleX : Number = modelRect.width / diy.vo.bmd.width;
        var scaleY : Number = modelRect.height / diy.vo.bmd.height;
        var scale : Number;

        if (scaleX < 1 || scaleY < 1 || (scaleX > 1 && scaleY > 1)) {
            scale = Math.min(scaleX, scaleY);
        } else {
            scale = Math.max(scaleX, scaleY);
        }

        if (scale >= 1) {
            _bmp.scaleX = _bmp.scaleY = 1;
        } else {
            _bmp.scaleX = _bmp.scaleY = scale;
        }

        EnterFrameCall.getStage().addChild(this);
        resetRect();
    }

    public function resetRect() : void {
        _rect.graphics.clear();
        _rect.graphics.lineStyle(1, 0x00FFFF);
        _rect.graphics.drawRect(_diy.editVo.bmdScroll.x * _bmp.scaleX, _diy.editVo.bmdScroll.y * _bmp.scaleY, _diy.realW * _bmp.scaleX, _diy.realH * _bmp.scaleY);

        x = EnterFrameCall.getStage().stageWidth - _bmp.width - 10;
    }

    private function get dataProxy() : DiyDataProxy {
        return Facade.getInstance().retrieveProxy(DiyDataProxy.NAME) as DiyDataProxy;
    }
}
}
