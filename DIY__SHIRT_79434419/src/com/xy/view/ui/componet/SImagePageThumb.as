package com.xy.view.ui.componet {
import com.xy.model.DiyDataProxy;
import com.xy.model.vo.BitmapDataVo;
import com.xy.model.vo.ExportVo;
import com.xy.ui.ImagePageThumb;
import com.xy.util.STool;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;

import org.puremvc.as3.patterns.facade.Facade;

/**
 * 横向拖动
 * @author xy
 */
public class SImagePageThumb extends ImagePageThumb {
    public function SImagePageThumb() {
        super();
        container.mouseChildren = false;
        container.mouseEnabled = false;
        infoTf.mouseEnabled = false;
    }

    public function setData(exportVo : ExportVo) : void {
    	if(exportVo == null){
    		return;
    	}
        if (exportVo.index == 0) {
            infoTf.text = "封面";
        } else if (exportVo.index >= exportVo.vo.page - 1) {
            infoTf.text = "封底";
        } else {
            infoTf.text = "第" + exportVo.index + "页";
        }
        STool.clear(container);
        var bmp : Bitmap = new Bitmap(exportVo.vo.bmd);
        bmp.width = 72;
        bmp.height = 53;
        var bgData : BitmapData = exportVo.exportBmd;

        if (bgData != null) {
            var bmp2 : Bitmap = new Bitmap(bgData);
            bmp2.width = 72;
            bmp2.height = 53;
            container.addChild(bmp2);
        }

        container.addChild(bmp);
    }

    public function get dataProxy() : DiyDataProxy {
        return Facade.getInstance().retrieveProxy(DiyDataProxy.NAME) as DiyDataProxy;
    }
}
}
