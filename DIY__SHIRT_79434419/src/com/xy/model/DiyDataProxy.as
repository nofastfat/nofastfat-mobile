package com.xy.model {
import com.xy.interfaces.Map;
import com.xy.model.enum.DiyDataNotice;
import com.xy.model.enum.SourceType;
import com.xy.model.history.IHistory;
import com.xy.model.vo.BitmapDataVo;
import com.xy.model.vo.CalVo;
import com.xy.model.vo.DefaultImageVo;
import com.xy.util.MulityLoad;
import com.xy.util.STool;
import com.xy.util.Tools;

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

    private var _ctrlHistory : Array = [];
    private var _currentHistoryIndex : int = -1;

    public var currentPageDatas : Array = [];
    public var cals : Array = [];
    
    public var uName : String;
    public var uPwd : String;

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

    public function recordHistory(history : IHistory) : void {
        if (_currentHistoryIndex + 1 >= _ctrlHistory.length) {
            _ctrlHistory.push(history);
            _currentHistoryIndex++;
        } else {
            _currentHistoryIndex++;
            _ctrlHistory[_currentHistoryIndex] = history;
            var delArr : Array = _ctrlHistory.splice(_currentHistoryIndex + 1, _ctrlHistory.length);
            for each (var his : IHistory in delArr) {
                his.destroy();
            }
        }

        if (_ctrlHistory.length > 100) {
            delArr = _ctrlHistory.splice(0, _ctrlHistory.length - 100);
            for each (his in delArr) {
                his.destroy();
            }
        }

        sendNotification(DiyDataNotice.HISTORY_UPDATE);
    }

    public function redo() : void {
        if (_currentHistoryIndex + 1 >= _ctrlHistory.length) {
            return;
        }
        _currentHistoryIndex++;
        var his : IHistory = _ctrlHistory[_currentHistoryIndex];
        his.redo();
        sendNotification(DiyDataNotice.HISTORY_UPDATE);
    }

    public function undo() : void {
        if (_ctrlHistory.length == 0 || _currentHistoryIndex < 0) {
            return;
        }
        var his : IHistory = _ctrlHistory[_currentHistoryIndex];
        his.undo();
        _currentHistoryIndex--;
        sendNotification(DiyDataNotice.HISTORY_UPDATE);
    }

    public function get ctrlHistory() : Array {
        return _ctrlHistory;
    }

    public function chooseModel(vo : BitmapDataVo, record : Boolean = true) : void {
        if (vo == null) {
            return;
        }
        _currentSelectModel.show = false;
        _currentSelectModel = vo;
        _currentSelectModel.show = true;
        sendNotification(DiyDataNotice.MODEL_UPDATE, record);
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

                if (_currentSelectModel.id == vo.id) {
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
            var id : String = String(xx.@id);
            var type : String = String(xx.@type);
            var url : String = String(xx.@url);

            if (!_backgrounds.containsKey(type)) {
                _backgrounds.put(type, []);
            }
            var vo : BitmapDataVo = new BitmapDataVo(xx.name(), id);
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
            id = String(xx.@id);
            type = String(xx.@type);
            url = String(xx.@url);

            if (!_decorates.containsKey(type)) {
                _decorates.put(type, []);
            }
            vo = new BitmapDataVo(xx.name(), id);
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
            id = String(xx.@id);
            type = String(xx.@type);
            url = String(xx.@url);

            if (!_frames.containsKey(type)) {
                _frames.put(type, []);
            }
            vo = new BitmapDataVo(xx.name(), id);
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
            id = String(xx.@id);
            type = String(xx.@type);
            url = String(xx.@url);
            var info : String = xx.@info;
            var page : int = int(xx.@page);
            var bgs : String = String(xx.@bgs);
            bgs = Tools.gainConfig(bgs);

            if (info == null) {
                info = "";
            }
            var rectStr : String = String(xx.@rect);
            rectStr = Tools.gainConfig(rectStr);

            var rectArr : Array = rectStr.split(",");
            if (rectArr.length != 4) {
                rectArr = [0, 0, 0, 0];
            }

            if (!_models.containsKey(type)) {
                _models.put(type, []);
            }
            vo = new BitmapDataVo(xx.name(), id);
            vo.type = type;
            vo.url = url;
            vo.show = false;
            vo.rect = new Rectangle(Number(rectArr[0]), Number(rectArr[1]), Number(rectArr[2]), Number(rectArr[3]));
            vo.info = info;
            vo.calStyle = String(xx.@calStyle);

            rectStr = String(xx.@calRect);
            rectArr = rectStr.split(",");
            if (rectArr.length != 4) {
                rectArr = [0, 0, 0, 0];
            }
            vo.calRect = new Rectangle(Number(rectArr[0]), Number(rectArr[1]), Number(rectArr[2]), Number(rectArr[3]));

            for each (var xxx : XML in xx.defaultImage) {
                var dvo : DefaultImageVo = new DefaultImageVo();
                dvo.id = String(xxx.@id);
                rectStr = String(xxx.@rect);
                rectStr = Tools.gainConfig(rectStr);

                rectArr = rectStr.split(",");
                if (rectArr.length != 4) {
                    rectArr = [0, 0, 0, 0];
                }
                dvo.rect = new Rectangle(Number(rectArr[0]), Number(rectArr[1]), Number(rectArr[2]), Number(rectArr[3]));
                vo.defaultImages.push(dvo);
            }

            if (page >= 1) {
                vo.page = page;
            }

            if (bgs != null) {
                vo.bgs = bgs.split(",");
            }

            _models.get(type).push(vo);

        }

        var defaultModeId : String = STool.getUrlParam("modelId");
        if (defaultModeId != null && defaultModeId != "") {
            _currentSelectModel = getModelById(defaultModeId);
        }
        if (_currentSelectModel == null) {
            _currentSelectModel = _models.get(_models.keys[0])[0];
        }

        if (_currentSelectModel != null) {
            _currentSelectModel.show = true;
            MulityLoad.getInstance().load(getNeedLoadBy(_currentSelectModel), function() : void {
                sendNotification(DiyDataNotice.MODEL_INIT, _currentSelectModel);
            }, SourceType.MODEL);
        }

        for each (xx in xml..calendar) {
            id = String(xx.@id);
            type = String(xx.@type);
            url = String(xx.@url);
            var calVo : CalVo = new CalVo(xx.name(), id);
            calVo.url = url;
            calVo.style = String(xx.@style);
            calVo.year = int(xx.@year);
            calVo.month = int(xx.@month);
            cals.push(calVo);
        }

        sendNotification(DiyDataNotice.HISTORY_UPDATE);
    }

    public function getCalVoById(id : String) : CalVo {
        for each (var vo : CalVo in cals) {
            if (vo.id == id) {
                return vo;
            }
        }

        return null;
    }

    public function getCalVoBy(style : String, year : int, month : int) : CalVo {
        for each (var vo : CalVo in cals) {
            if (vo.style == style && vo.year == year && vo.month == month) {
                return vo;
            }
        }

        return null;
    }

    public function getSelectAbleCals(style : String) : Array {
        var rs : Array = [];
        for each (var vo : CalVo in cals) {
            if (vo.style == style) {
                rs.push(vo);
            }
        }
        rs.sort(sortFun);

        return rs;
    }

    private function sortFun(cal1 : CalVo, cal2 : CalVo) : int {
        if (cal1.year < cal2.year) {
            return -1;
        } else if (cal1.year > cal2.year) {
            return 1;
        } else {
            if (cal1.month < cal2.month) {
                return -1;
            } else if (cal1.month > cal2.month) {
                return 1;
            } else {
                return 0;
            }
        }
    }

    public function getNeedLoadBy(vo : BitmapDataVo) : Array {
        var rs : Array = [vo];

        for each (var dvo : DefaultImageVo in vo.defaultImages) {
            var tmp : BitmapDataVo = getBitmapDataVoById(dvo.id);
            if (tmp != null && tmp.bmd != null) {
                rs.push(tmp);
            }
        }

        for each (var id : String in vo.bgs) {
            tmp = getBitmapDataVoById(id);
            if (tmp != null && tmp.bmd != null) {
                rs.push(tmp);
            }
        }

        return rs;
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
            _images.push(new BitmapDataVo("free", null, bmd));
        }

        sendNotification(DiyDataNotice.IMAGE_UPDATE);
    }

    public function clearHistorys() : void {
        for each (var iHis : IHistory in _ctrlHistory) {
            iHis.destroy();
        }
        _ctrlHistory = [];
        _currentHistoryIndex = -1;
        sendNotification(DiyDataNotice.HISTORY_UPDATE);
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

    public function get currentHistoryIndex() : int {
        return _currentHistoryIndex;
    }

    public function getModelById(id : String) : BitmapDataVo {
        for each (var key : String in _models.keys) {
            for each (var vo : BitmapDataVo in _models.get(key)) {
                if (vo.id == id) {
                    return vo;
                }
            }
        }

        return null;
    }

    public function getBitmapDataVoById(id : String) : BitmapDataVo {
        var arr : Array = [_images, _backgrounds, _decorates, _frames];
        for each (var ar : * in arr) {
            if (ar is Array) {

                for each (var vo : BitmapDataVo in ar) {
                    if (vo.id == id) {
                        return vo;
                    }
                }
            } else {
                for each (var key : String in ar.keys) {
                    for each (vo in ar.get(key)) {
                        if (vo.id == id) {
                            return vo;
                        }
                    }
                }
            }
        }

        return null;
    }

    public function getFontByName(fontName : String) : Font {
        for each (var font : Font in userableFonts) {
            if (font.fontName == fontName) {
                return font;
            }
        }

        return null;
    }


}
}
