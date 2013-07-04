package com.xy.view.ui.ctrls {
import com.xy.component.Slider.Slider;
import com.xy.component.Slider.SliderMode;
import com.xy.component.Slider.event.SliderEvent;
import com.xy.component.colorPicker.ColorPicker;
import com.xy.component.colorPicker.enum.PreSwatches;
import com.xy.model.enum.SourceType;
import com.xy.model.vo.BitmapDataVo;
import com.xy.ui.BlackButton;
import com.xy.ui.BlueButton;
import com.xy.ui.ScrollUI;
import com.xy.util.MulityLoad;
import com.xy.util.STool;
import com.xy.util.Tools;
import com.xy.view.ui.componet.SImageThumbUI;
import com.xy.view.ui.componet.SSimpleColorUI;
import com.xy.view.ui.events.BackgroundContainerEvent;
import com.xy.view.ui.events.ImageContainerEvent;
import com.xy.view.ui.events.SImageSizeUIEvent;
import com.xy.view.ui.events.SImageThumbUIEvent;
import com.xy.view.ui.events.SSimpleColorUIEvent;

import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.Font;
import flash.utils.setTimeout;

import mx.core.FontAsset;

public class BackgroundContainer extends AbsContainer {
    private var _addBtn : BlackButton;
    private var _deleteBgBtn : BlueButton;
    private var _sizeUI : SSimpleColorUI;

    private var _imageThumbs : Array = [];

    private var _slider : Slider;
    private var _scrollUI : ScrollUI;

    private var _itemMaxHeight : int;
    private var _currentPageSize : int;

    private var _images : Array = [];

    public function BackgroundContainer() {

        super();
        _addBtn = Tools.makeBlackButton("更多背景");
        _deleteBgBtn = Tools.makeBlueButton("取消背景");
        _sizeUI = new SSimpleColorUI();

        addChild(_addBtn);
        addChild(_deleteBgBtn);
        addChild(_sizeUI);

        _scrollUI = new ScrollUI();
        addChild(_scrollUI);

        _slider = new Slider();
        _slider.setCtrlUI(_scrollUI.scrollBtn, _scrollUI.bg, _scrollUI.prevBtn, _scrollUI.nextBtn, SliderMode.VERTICAL);
        _slider.setData(0, 10, 1, 0);

        _scrollUI.x = 200 - _scrollUI.width - 5;

        _scrollUI.y = _addBtn.y + _addBtn.height + 10;

        _addBtn.addEventListener(MouseEvent.CLICK, __uploadImageHandler);
        _slider.addEventListener(SliderEvent.DATA_UPDATE, __sliderHandler);
		_deleteBgBtn.addEventListener(MouseEvent.CLICK, __deleteBgHandler);

        _sizeUI.addEventListener(SSimpleColorUIEvent.CHOOSE_COLOR, __chooseColorHandler);
		
		
		updateDelete(false);
    }

    public function setData(bmds : Array) : void {
        _images = bmds;

        updateShow();
    }

    private function updateShow() : void {
        _currentPageSize = _itemMaxHeight / 130;


        if (_currentPageSize <= 0) {
            _currentPageSize = 1
        }

        var totalPage : int;
        totalPage = _images.length - _currentPageSize;
        _slider.setData(0, totalPage, 1, _slider.getValue());
        _scrollUI.visible = _images.length > _currentPageSize;


        var sx : int = _scrollUI.visible ? _scrollUI.x : 200;
        var eachHeight : int = _itemMaxHeight / _currentPageSize;

        var maxer : int = Math.max(_currentPageSize, _imageThumbs.length);


        var needLoad : Boolean = false;
        var loads : Array = [];
        for (var i : int = 0; i < maxer; i++) {
            var index : int = i + _slider.getValue();
            var vo : BitmapDataVo = _images[index];
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

            for (i = 0; i < maxer; i++) {
                var thumb : SImageThumbUI = _imageThumbs[i];
                if (thumb == null) {
                    thumb = new SImageThumbUI(130, 130, 1);
                    addChildAt(thumb, 1);
                    _imageThumbs[i] = thumb;
                    thumb.addEventListener(SImageThumbUIEvent.STATUS_CHANGE, __statusChangeHandler);
                }
                thumb.setSize(130, 130);

                if (i < _currentPageSize) {
                    thumb.x = (sx - thumb.width) / 2;
                    thumb.y = i * eachHeight + _scrollUI.y;
                    index = i + _slider.getValue();
                    vo = _images[index];
                    if (vo == null) {
                        thumb.visible = false;
                    } else {
                        thumb.visible = true;
                        thumb.setData(vo);
                    }
                } else {
                    thumb.visible = false;
                }
            }
        }
    }

    public function updateDelete(enable : Boolean) : void {
        STool.setMovieClipEnable(_deleteBgBtn, enable);
		_deleteBgBtn.mouseChildren = enable;
    }

    private function loadOk() : void {
        setTimeout(updateShow, 100);
    }

    private function __uploadImageHandler(e : MouseEvent) : void {
        dispatchEvent(new BackgroundContainerEvent(BackgroundContainerEvent.SHOW_MORE_PANEL));
    }

    private function __sliderHandler(e : SliderEvent) : void {
        updateShow();
    }

	private function __deleteBgHandler(e : MouseEvent):void{
		dispatchEvent(new BackgroundContainerEvent(BackgroundContainerEvent.DELETE_BG));
	}
	
    private function __chooseColorHandler(e : SSimpleColorUIEvent) : void {
        dispatchEvent(new BackgroundContainerEvent(BackgroundContainerEvent.UPDATE_BACKGROUND, null, e.color));
    }

    private function __statusChangeHandler(e : SImageThumbUIEvent) : void {
        var thumb : SImageThumbUI = e.currentTarget as SImageThumbUI;
        thumb.vo.show = e.selected;
        if (!e.selected) {
            dispatchEvent(new BackgroundContainerEvent(BackgroundContainerEvent.HIDE_BACKGROUND, thumb.vo.id));
        }
    }

    override public function resize(height : int) : void {
        super.resize(height);
        if (_addBtn != null) {
            _addBtn.x = (200 - _addBtn.width) / 2;
            _addBtn.y = 10;
        }

        if (_deleteBgBtn != null) {
            _deleteBgBtn.x = 10;
            _deleteBgBtn.y = height - _deleteBgBtn.height - 7;
        }

        if (_sizeUI != null) {
            _sizeUI.x = 200 - _sizeUI.width - 10;
            _sizeUI.y = height - _sizeUI.height - 5;
        }


        if (_scrollUI != null) {
            _itemMaxHeight = height - (_addBtn.y + _addBtn.height) - _sizeUI.height - 40;
            _scrollUI.bg.height = _itemMaxHeight;
            _scrollUI.prevBtn.y = 0;
            _scrollUI.bg.y = _scrollUI.prevBtn.height;
            _scrollUI.nextBtn.y = _scrollUI.bg.height + _scrollUI.nextBtn.height;
            _slider.resetUI();
        }

        updateShow();

    }

    override public function setChildVisible(visible : Boolean) : void {
        if (visible) {
            addChild(_scrollUI);
        } else {
            STool.remove(_scrollUI);
        }
    }

}
}
