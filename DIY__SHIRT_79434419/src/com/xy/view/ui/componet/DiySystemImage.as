package com.xy.view.ui.componet {
import com.xy.model.vo.BitmapDataVo;
import com.xy.util.STool;

import flash.display.Bitmap;
import flash.geom.Rectangle;

/**
 * 系统预设的图片
 * @author xy
 */
public class DiySystemImage extends DiyBase {
    private var _vo : BitmapDataVo;
    private var _bmp : Bitmap;
    private var _bmdDrag : BitmapDragTip;

    public function DiySystemImage(vo : BitmapDataVo, modelRect : Rectangle, bmdDrag : BitmapDragTip) {
        super();
        this._vo = vo;
        this._bmdDrag = bmdDrag;
        _bmp = new Bitmap(vo.bmd);
        addChild(_bmp);

        var scaleX : Number = modelRect.width * 0.8 / _bmp.width;
        var scaleY : Number = modelRect.height * 0.8 / _bmp.height;
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

        _realW = _bmp.width;
        _realH = _bmp.height;
    }

    private var _lastScaleX : Number;
    private var _lastScaleY : Number;

    public function setFullStatus(full : Boolean) : void {
        _editVo.isFull = full;

        if (full) {
            _lastScaleX = _bmp.scaleX;
            _lastScaleY = _bmp.scaleY;
            _bmp.scaleX = _bmp.scaleY = 1;
            _bmp.scrollRect = new Rectangle(_editVo.bmdScroll.x, _editVo.bmdScroll.y, _realW, _realH);
            _bmdDrag.showBy(this);
        } else {
            STool.remove(_bmdDrag);
            _bmp.scaleX = _lastScaleX;
            _bmp.scaleY = _lastScaleY;
            _bmp.scrollRect = new Rectangle(0, 0, _vo.bmd.width, _vo.bmd.height);
        }
    }

    public function bmdMoveOffset(ix : Number, iy : Number) : void {
        if (!_editVo.isFull) {
            return;
        }
        _editVo.bmdScroll.x += ix;
        _editVo.bmdScroll.y += iy;
        _bmp.scrollRect = new Rectangle(_editVo.bmdScroll.x, _editVo.bmdScroll.y, _realW, _realH);

        if (_bmdDrag.stage != null) {
            _bmdDrag.resetRect();
        }
    }

    override protected function setChild0Size(w : Number, h : Number) : void {
        if (_editVo.isFull) {
            _bmp.scrollRect = new Rectangle(_editVo.bmdScroll.x, _editVo.bmdScroll.y, w, h);
            _lastScaleX = w / _vo.bmd.width;
            _lastScaleY = h / _vo.bmd.height;
        } else {
            super.setChild0Size(w, h);
            _lastScaleX = _bmp.scaleX;
            _lastScaleY = _bmp.scaleY;
        }

        if (_bmdDrag.stage != null) {
            _bmdDrag.resetRect();
        }
    }

    public function get vo() : BitmapDataVo {
        return _vo;
    }
}
}
