package com.xy.view.ui.panels {
import com.xy.component.buttons.ToggleButton;
import com.xy.component.buttons.ToggleButtonGroup;
import com.xy.component.buttons.event.ToggleButtonGroupEvent;
import com.xy.component.page.SPage;
import com.xy.component.page.event.SPageEvent;
import com.xy.interfaces.Map;
import com.xy.model.enum.SourceType;
import com.xy.model.vo.BitmapDataVo;
import com.xy.ui.BgListUI;
import com.xy.ui.PageUI;
import com.xy.ui.TabButton;
import com.xy.util.MulityLoad;
import com.xy.util.Tools;
import com.xy.view.ui.componet.SImageThumbUI;
import com.xy.view.ui.events.ChooseBackgroundPanelEvent;
import com.xy.view.ui.events.SImageThumbUIEvent;

import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.utils.setTimeout;

public class ChooseBackgroundPanel extends AbsPanel {
    private var _btn0 : TabButton;
    private var _line : Shape;

    private var _leftMenu : Sprite;

    private var _bgList : BgListUI;
    private var _togGroup : ToggleButtonGroup;

    private var _bgs : Map = new Map();

    private var _lastMc : MovieClip;

    private var _vos : Array = [];
    private var _imageThumbs : Array = [];

    private var _spage : SPage;
    private var _pageUI : PageUI;

    public function ChooseBackgroundPanel(w : int = 720, h : int = 520, title : String = "添加背景") {
        super(w, h, title);

        _btn0 = Tools.makeTabButton("风格");

        _line = new Shape();
        _line.graphics.lineStyle(1, 0xb8b8b8);
        _line.graphics.moveTo(_btn0.x + _btn0.width, _btn0.height - 1);
        _line.graphics.lineTo(_mask.width, _btn0.height - 1);

        _leftMenu = new Sprite();
        _leftMenu.graphics.beginFill(0xf0f0f0);
        _leftMenu.graphics.drawRoundRect(0, 0, 190, 425, 10, 10);
        _leftMenu.graphics.endFill();
        _leftMenu.y = _btn0.height + 10;

        _bgList = new BgListUI();
        _bgList.y = _leftMenu.y + 10;
        _bgList.x = 3;

        _togGroup = new ToggleButtonGroup();
        var arr : Array = [];

        for (var i : int = 0; i < 30; i++) {
            var mc : MovieClip = _bgList["item" + i];
            arr.push(new ToggleButton(mc));
        }
        _togGroup.setToggleButtons(arr);

        _pageUI = new PageUI();
        _spage = new SPage(12);
        _spage.setCtrlUI(_pageUI.prevBtn, _pageUI.tf, _pageUI.nextBtn);
        _pageUI.x = 400;
        _pageUI.y = 410;

        container.addChild(_line);
        container.addChild(_btn0);
        container.addChild(_leftMenu);
        container.addChild(_bgList);
        container.addChild(_pageUI);

        var offsetX : int = 207;
        var offsetY : int = 39;
        for (i = 0; i < 3; i++) {
            for (var j : int = 0; j < 4; j++) {
                var thumb : SImageThumbUI = new SImageThumbUI();
                thumb.x = offsetX + j * (thumb.width + 20);
                thumb.y = offsetY + i * (thumb.height + 20);
                thumb.addEventListener(SImageThumbUIEvent.STATUS_CHANGE, __imageThumbHandler);
                container.addChild(thumb);

                _imageThumbs.push(thumb);
            }
        }

        updateMenuShow();
        updateListShow();

        _togGroup.addEventListener(ToggleButtonGroupEvent.STATE_CHANGE, __groupChangeHandler);
        _spage.addEventListener(SPageEvent.PAGE_CHANGE, __pageHandler);
        __groupChangeHandler();
    }

    public function setData(bgs : Map) : void {
        _bgs = bgs;
        recalList();
        updateMenuShow();
        updateListShow();
    }

    public function updateListShow() : void {
        var needLoad : Boolean = false;
		var loads : Array = [];
        for (var i : int = 0; i < 12; i++) {
            var vo : BitmapDataVo = _vos[_spage.pageVo.getStartIndex() + i];
            if (vo != null) {
                if (vo.bmd == null) {
                    needLoad = true;
					loads.push(vo);
                }
            }
        }

        if (needLoad) {
			MulityLoad.getInstance().load(loads, loadOk, SourceType.BACKGROUND);
        } else {
            for (i = 0; i < 12; i++) {
                var thumb : SImageThumbUI = _imageThumbs[i];
                vo = _vos[_spage.pageVo.getStartIndex() + i];

                if (vo == null) {
                    thumb.visible = false;
                } else {
                    thumb.visible = true;
                    thumb.setData(vo);	
                }
            }
        }
    }
	
	private function loadOk():void{
		recalList();
		setTimeout(updateListShow, 100);
	}

    public function updateMenuShow() : void {
        var keys : Array = _bgs.keys.concat();
        keys.splice(0, 0, "全部");
        for (var i : int = 0; i < 30; i++) {
            var mc : MovieClip = _bgList["item" + i];
            var line : MovieClip = _bgList["line" + int(i / 3)];
            var key : String = keys[i];

            if (key == null) {
                mc.visible = false;
            } else {
                mc.visible = true;
                mc.nameTf.text = key;
            }
            line.visible = _bgList["item" + int(i / 3) * 3].visible;
        }
    }

    private function recalList() : void {
        if (_togGroup.selectIndex == 0) {
            _vos = [];
            for each (var arr : Array in _bgs.values) {
                _vos = _vos.concat(arr);
            }
        } else {
            _vos = _bgs.get(_bgs.keys[_togGroup.selectIndex - 1]);
        }
        _spage.setDataCount(_vos.length, false);
    }

    private function __groupChangeHandler(e : ToggleButtonGroupEvent = null) : void {
        var mc : MovieClip = _bgList["item" + _togGroup.selectIndex];
        if (_lastMc != null) {
            _lastMc.nameTf.textColor = "0x333333";
        }
        mc.nameTf.textColor = "0xFE6603";

        _lastMc = mc;

        recalList();
		_spage.setPage(0, false);
        updateListShow();
    }

    private function __pageHandler(e : SPageEvent) : void {

        updateListShow();
    }

    private function __imageThumbHandler(e : SImageThumbUIEvent) : void {
		dispatchEvent(new ChooseBackgroundPanelEvent(ChooseBackgroundPanelEvent.BACKGROUND_STATUS,(e.currentTarget as SImageThumbUI).vo));
    }
}
}
