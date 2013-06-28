package com.xy.view.ui.componet {
import com.xy.model.vo.BitmapDataVo;

import flash.display.Bitmap;

/**
 * 系统预设的图片
 * @author xy
 */
public class DiySystemImage extends DiyBase {
    private var _vo : BitmapDataVo;

    public function DiySystemImage(vo : BitmapDataVo) {
        super();
        this._vo = vo;
        var bmp : Bitmap = new Bitmap(vo.bmd);
        addChild(bmp);
		
		_realW = bmp.width;
		_realH = bmp.height;
    }
}
}
