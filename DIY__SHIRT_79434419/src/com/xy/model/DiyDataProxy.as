package com.xy.model {
import com.xy.interfaces.Map;
import com.xy.model.enum.DiyDataNotice;
import com.xy.model.enum.SourceType;
import com.xy.model.vo.BitmapDataVo;
import com.xy.util.MulityLoad;
import com.xy.util.STool;
import com.xy.util.Tools;

import flash.display.BitmapData;
import flash.text.Font;
import flash.utils.setTimeout;

import org.puremvc.as3.patterns.proxy.Proxy;

public class DiyDataProxy extends Proxy {
    public static const NAME : String = "DiyDataProxy";

    private var _images : Array = [];
    private var _backgrounds : Map = new Map();

    public var userableFonts : Array = Font.enumerateFonts(true);

    public function DiyDataProxy() {
        super(NAME);

        userableFonts.sort(function(a : Font, b : Font) : int {
            var aHas : Boolean = STool.strHasChinese(a.fontName);
            var bHas : Boolean = STool.strHasChinese(b.fontName);

            if (aHas && bHas) {
                return 0;
            }
            if (aHas) {
                return -1;
            }

            if (bHas) {
                return 1;
            }

            return 0;
        });
    }

    public function skipSource(sourceType : int, vo : BitmapDataVo) : void {
        switch (sourceType) {
            case SourceType.BACKGROUND:
                var arr : Array = _backgrounds.get(vo.type);
                var index : int = arr.indexOf(vo);
                if (index != -1) {
                    arr.splice(index, 1);
                }
                break;
        }
    }

    public function get backgrounds() : Map {
        return _backgrounds;
    }

    public function initConfigXML(xml : XML) : void {
        var randomShow : int = 10;
        for each (var xx : XML in xml..bg) {
            var type : String = String(xx.@type);
            var url : String = String(xx.@url);

            if (!_backgrounds.containsKey(type)) {
                _backgrounds.put(type, []);
            }
            var vo : BitmapDataVo = new BitmapDataVo();
            vo.type = type;
            vo.url = url;
            vo.show = false;

            _backgrounds.get(type).push(vo);

            if (randomShow > 0 && STool.random(1, 2) == 1) {
                vo.show = true;
                randomShow--;
            }
        }

        MulityLoad.getInstance().load(getShowableBg(), function() : void {
            setTimeout(sendNotification, 100, DiyDataNotice.BACKGROUND_UPDATE);
        }, SourceType.BACKGROUND);

    }

    public function getShowableBg() : Array {
        var rs : Array = [];
        for each (var arr : Array in _backgrounds.values) {
            for each (var vo : BitmapDataVo in arr) {
                if (vo.show) {
                    rs.push(vo);
                }
            }
        }
        return rs;
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
