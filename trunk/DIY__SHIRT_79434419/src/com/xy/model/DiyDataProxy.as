package com.xy.model {
import com.xy.interfaces.Map;
import com.xy.model.enum.DiyDataNotice;
import com.xy.model.enum.SourceType;
import com.xy.model.vo.BitmapDataVo;
import com.xy.util.MulityLoad;
import com.xy.util.STool;

import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.text.Font;

import org.puremvc.as3.patterns.proxy.Proxy;

public class DiyDataProxy extends Proxy {
    public static const NAME : String = "DiyDataProxy";

    private var _images : Array = [];
    private var _backgrounds : Map = new Map();
    private var _decorates : Map = new Map();
    private var _frames : Map = new Map();
    private var _models : Map = new Map();

    private var _currentSelectModel : BitmapDataVo;

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

    public function chooseModel(vo : BitmapDataVo) : void {
        _currentSelectModel.show = false;
        _currentSelectModel = vo;
        _currentSelectModel.show = true;
        sendNotification(DiyDataNotice.MODEL_UPDATE);
    }

    public function get currentSelectModel() : BitmapDataVo {
        return _currentSelectModel;
    }

    public function get frames() : Map {
        return _frames;
    }

    public function get decorates() : Map {
        return _decorates;
    }

    public function get models() : Map {
        return _models;
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

            case SourceType.DECORATE:
                arr = _decorates.get(vo.type);
                index = arr.indexOf(vo);
                if (index != -1) {
                    arr.splice(index, 1);
                }
                break;
            case SourceType.FRAME:
				arr = _frames.get(vo.type);
				index = arr.indexOf(vo);
				if (index != -1) {
					arr.splice(index, 1);
				}
                break;
            case SourceType.MODEL:
				arr = _models.get(vo.type);
				index = arr.indexOf(vo);
				if (index != -1) {
					arr.splice(index, 1);
				}
				
				if(_currentSelectModel.id == vo.id){
					_currentSelectModel = _models.get(_models.keys[0])[0];
				}
                break;
        }
    }

    public function get backgrounds() : Map {
        return _backgrounds;
    }

    public function initConfigXML(xml : XML) : void {
        var randomShow : int = 5;
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


        randomShow = 5;
        for each (xx in xml..dc) {
            type = String(xx.@type);
            url = String(xx.@url);

            if (!_decorates.containsKey(type)) {
                _decorates.put(type, []);
            }
            vo = new BitmapDataVo();
            vo.type = type;
            vo.url = url;
            vo.show = false;

            _decorates.get(type).push(vo);

            if (randomShow > 0 && STool.random(1, 2) == 1) {
                vo.show = true;
                randomShow--;
            }
        }

        randomShow = 5;
        for each (xx in xml..fm) {
            type = String(xx.@type);
            url = String(xx.@url);

            if (!_frames.containsKey(type)) {
                _frames.put(type, []);
            }
            vo = new BitmapDataVo();
            vo.type = type;
            vo.url = url;
            vo.show = false;

            _frames.get(type).push(vo);

            if (randomShow > 0 && STool.random(1, 2) == 1) {
                vo.show = true;
                randomShow--;
            }
        }

        for each (xx in xml..model) {
            type = String(xx.@type);
            url = String(xx.@url);
            var rectStr : String = String(xx.@rect);
            var rectArr : Array = rectStr.split(",");
            if (rectArr.length != 4) {
                rectArr = [0, 0, 0, 0];
            }

            if (!_models.containsKey(type)) {
                _models.put(type, []);
            }
            vo = new BitmapDataVo();
            vo.type = type;
            vo.url = url;
            vo.show = false;
            vo.rect = new Rectangle(rectArr[0], rectArr[1], rectArr[2], rectArr[3])

            _models.get(type).push(vo);

            if (_currentSelectModel == null) {
                _currentSelectModel = vo;
                _currentSelectModel.show = true;
            }

            if (_currentSelectModel != null) {
                MulityLoad.getInstance().load([_currentSelectModel], function() : void {
                    sendNotification(DiyDataNotice.MODEL_UPDATE);
                }, SourceType.MODEL);
            }
        }
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

    public function getShowableDecorate() : Array {
        var rs : Array = [];
        for each (var arr : Array in _decorates.values) {
            for each (var vo : BitmapDataVo in arr) {
                if (vo.show) {
                    rs.push(vo);
                }
            }
        }
        return rs;
    }

    public function getShowableFrame() : Array {
        var rs : Array = [];
        for each (var arr : Array in _frames.values) {
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
