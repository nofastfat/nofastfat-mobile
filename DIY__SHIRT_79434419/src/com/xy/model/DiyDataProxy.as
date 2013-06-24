package com.xy.model {
import com.xy.model.enum.DiyDataNotice;
import com.xy.model.vo.BitmapDataVo;

import flash.display.BitmapData;

import org.puremvc.as3.patterns.proxy.Proxy;

public class DiyDataProxy extends Proxy {
    public static const NAME : String = "DiyDataProxy";

    private var _images : Array = [];

    public function DiyDataProxy() {
        super(NAME);
    }

    public function get images() : Array {
        return _images;
    }

    /**
     * 添加图片
     * @param bitmapDats
     */
    public function addImages(bitmapDats : Array) : void {
        for each (var bmd : BitmapData in bitmapDats) {
            _images.push(new BitmapDataVo(bmd));
        }

        sendNotification(DiyDataNotice.IMAGE_UPDATE);
    }

    public function clearAll() : void {
        _images = [];
        sendNotification(DiyDataNotice.IMAGE_UPDATE);
    }

    public function imageStatusChange(id : String, selected : Boolean) : void {
        for each (var vo : BitmapDataVo in _images) {
            if (vo.id == id) {
                vo.show = selected;
            }
        }
        sendNotification(DiyDataNotice.IMAGE_UPDATE);
    }

    public function getShowAbleBmds() : Array {
        var arr : Array = [];

        for each (var vo : BitmapDataVo in _images) {
            if (vo.show) {
                arr.push(vo);
            }
        }

        return arr;
    }

}
}
