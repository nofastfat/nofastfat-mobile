package com.xy.view.ui.ctrls {
import com.xy.component.Slider.Slider;
import com.xy.component.Slider.SliderMode;
import com.xy.component.Slider.event.SliderEvent;
import com.xy.model.vo.BitmapDataVo;
import com.xy.ui.BlackButton;
import com.xy.ui.ScrollUI;
import com.xy.util.Tools;
import com.xy.view.ui.componet.SImageThumbUI;
import com.xy.view.ui.events.ImageContainerEvent;
import com.xy.view.ui.events.SImageThumbUIEvent;

import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;

public class ImageContainer extends AbsContainer {
    private var _addBtn : BlackButton;
    private var _sizeUI : SImageSizeUI;

    private var _imageThumbs : Array = [];

    private var _slider : Slider;
    private var _scrollUI : ScrollUI;

    private var _itemMaxHeight : int;
    private var _currentPageSize : int;

    private var _images : Array = [];

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
    }

    public function setData(bmds : Array) : void {
        _images = bmds;

        updateShow();
    }

    private function updateShow() : void {
		_slider.setData(0, _images.length - _currentPageSize, 1, _slider.getValue());
        _scrollUI.visible = _images.length > _currentPageSize;


        var sx : int = _scrollUI.visible ? _scrollUI.x : 200;
        var eachHeight : int = _itemMaxHeight / _currentPageSize;

        var maxer : int = Math.max(_currentPageSize, _imageThumbs.length);

        for (var i : int = 0; i < maxer; i++) {
            var thumb : SImageThumbUI = _imageThumbs[i];
            if (thumb == null) {
                thumb = new SImageThumbUI(150, 150, 1);
                addChildAt(thumb, 1);
                _imageThumbs[i] = thumb;
				thumb.addEventListener(SImageThumbUIEvent.STATUS_CHANGE, __statusChangeHandler);
            }

            if (i < _currentPageSize) {
                thumb.x = (sx - thumb.width) / 2;
                thumb.y = i * eachHeight + _scrollUI.y;
				var vo : BitmapDataVo = _images[i + _slider.getValue()];
				if(vo == null){
					thumb.visible = false;
				}else{
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

	private function __statusChangeHandler(e : SImageThumbUIEvent):void{
		var thumb : SImageThumbUI = e.currentTarget as SImageThumbUI;
		thumb.vo.show = e.selected;
		if(!e.selected){
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
            _sizeUI.y = height - _sizeUI.height - 10;
        }

        if (_scrollUI != null) {
            _itemMaxHeight = height - (_addBtn.y + _addBtn.height) - _sizeUI.height - 40;
            _currentPageSize = _itemMaxHeight / 170;
            if (_currentPageSize <= 0) {
                _currentPageSize = 1
            }

            _scrollUI.bg.height = _itemMaxHeight;
            _scrollUI.prevBtn.y = 0;
            _scrollUI.bg.y = _scrollUI.prevBtn.height;
            _scrollUI.nextBtn.y = _scrollUI.bg.height + _scrollUI.nextBtn.height;
            _slider.resetUI();
        }

        updateShow();

    }

}
}
