package com.xy.view.ui.ctrls {
import com.xy.component.Slider.Slider;
import com.xy.component.Slider.SliderMode;
import com.xy.component.Slider.event.SliderEvent;
import com.xy.model.vo.BitmapDataVo;
import com.xy.ui.BlackButton;
import com.xy.ui.ScrollUI;
import com.xy.util.STool;
import com.xy.util.Tools;
import com.xy.view.ui.componet.SImageThumbUI;
import com.xy.view.ui.events.ImageContainerEvent;
import com.xy.view.ui.events.SImageSizeUIEvent;
import com.xy.view.ui.events.SImageThumbUIEvent;

import flash.events.MouseEvent;
import flash.text.Font;

import mx.core.FontAsset;

public class ImageContainer extends AbsContainer {
    private var _addBtn : BlackButton;
    private var _sizeUI : SImageSizeUI;

    private var _imageThumbs : Array = [];

    private var _slider : Slider;
    private var _scrollUI : ScrollUI;

    private var _itemMaxHeight : int;
    private var _currentPageSize : int;

    private var _images : Array = [];

    private var _listType : int = 0;

    public function ImageContainer() {
        super();
        _addBtn = Tools.makeBlackButton("添加图片");
        _sizeUI = new SImageSizeUI();

        addChild(_addBtn);
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

        _sizeUI.addEventListener(SImageSizeUIEvent.STATUS_CHANGE, __imageStatusHandler);
    }

    public function setData(bmds : Array) : void {
        _images = bmds;

        updateShow();
    }

    private function updateShow() : void {
        _currentPageSize = _itemMaxHeight / 130;

        if (_listType == 1) {
            _currentPageSize = _itemMaxHeight / 70;

            _currentPageSize *= 2;
        }

        if (_currentPageSize <= 0) {
            _currentPageSize = 1
        }

		var totalPage : int;
        if (_listType == 0) {
            totalPage =  _images.length - _currentPageSize;
        } else {
            totalPage = (_images.length - _currentPageSize)/2;
            if((_images.length - _currentPageSize) % 2 != 0){
            	totalPage++;
            }
        }
        _slider.setData(0, totalPage, 1, _slider.getValue());
        _scrollUI.visible = _images.length > _currentPageSize;


        var sx : int = _scrollUI.visible ? _scrollUI.x : 200;
        var eachHeight : int = _itemMaxHeight / _currentPageSize;

        if (_listType == 1) {
            eachHeight *= 2;
        }

        var maxer : int = Math.max(_currentPageSize, _imageThumbs.length);

        for (var i : int = 0; i < maxer; i++) {
            var thumb : SImageThumbUI = _imageThumbs[i];
            if (thumb == null) {
                thumb = new SImageThumbUI(130, 130, 1);
                addChildAt(thumb, 1);
                _imageThumbs[i] = thumb;
                thumb.addEventListener(SImageThumbUIEvent.STATUS_CHANGE, __statusChangeHandler);
            }
            if (_listType == 0) {
                thumb.setSize(130, 130);
            } else {
                thumb.setSize(70, 70);
            }

            if (i < _currentPageSize) {
                if (_listType == 0) {
                    thumb.x = (sx - thumb.width) / 2;
                    thumb.y = i * eachHeight + _scrollUI.y;
                } else {
                    thumb.x = (i % 2 == 0) ?
                        ((sx - thumb.width * 2 - 10) / 2) :
                        ((sx - thumb.width * 2 - 10) / 2 + thumb.width + 10);

                    thumb.y = int(i / 2) * eachHeight + _scrollUI.y;
                }
                
                var index : int = _listType == 0 ? i + _slider.getValue() : i + _slider.getValue()*2;
                var vo : BitmapDataVo = _images[index];
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

    private function __uploadImageHandler(e : MouseEvent) : void {
        dispatchEvent(new ImageContainerEvent(ImageContainerEvent.UPLOAD_IMAGE));
    }

    private function __sliderHandler(e : SliderEvent) : void {
        updateShow();
    }

    private function __imageStatusHandler(e : SImageSizeUIEvent) : void {
        _listType = e.selected;
        updateShow();
    }

    private function __statusChangeHandler(e : SImageThumbUIEvent) : void {
        var thumb : SImageThumbUI = e.currentTarget as SImageThumbUI;
        thumb.vo.show = e.selected;
        if (!e.selected) {
            dispatchEvent(new ImageContainerEvent(ImageContainerEvent.UPDATE_SELECT));
        }
    }

    override public function resize(height : int) : void {
        super.resize(height);
        if (_addBtn != null) {
            _addBtn.x = (200 - _addBtn.width) / 2;
            _addBtn.y = 10;
        }

        if (_sizeUI != null) {
            _sizeUI.x = 200 - _sizeUI.width - 10;
            _sizeUI.y = height - _sizeUI.height - 5;
        }

        if (_scrollUI != null) {
            _itemMaxHeight = height - (_addBtn.y + _addBtn.height) - _sizeUI.height - 20;
            _scrollUI.bg.height = _itemMaxHeight;
            _scrollUI.prevBtn.y = 0;
            _scrollUI.bg.y = _scrollUI.prevBtn.height;
            _scrollUI.nextBtn.y = _scrollUI.bg.height + _scrollUI.nextBtn.height;
            _slider.resetUI();
        }

        updateShow();

    }
	
	override public function setChildVisible(visible : Boolean):void{
		if(visible){
			addChild(_scrollUI);
		}else{
			STool.remove(_scrollUI);
		}
	}

}
}
