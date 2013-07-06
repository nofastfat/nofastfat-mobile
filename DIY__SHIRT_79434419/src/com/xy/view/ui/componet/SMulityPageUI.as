package com.xy.view.ui.componet {
import com.xy.component.Slider.Slider;
import com.xy.component.Slider.SliderMode;
import com.xy.component.Slider.event.SliderEvent;
import com.xy.model.vo.ExportVo;
import com.xy.ui.MulityPageUI;
import com.xy.util.EnterFrameCall;
import com.xy.view.ui.events.SMulityPageUIEvent;

import flash.events.Event;
import flash.events.MouseEvent;

public class SMulityPageUI extends MulityPageUI {
    private var _slider : Slider;

    private var _currentPageSize : int;
    private var _itemMaxWidth : int;

    /**
     * [ExportVo, ExportVo, ...]
     */
    private var _images : Array = [];
    private var _imageThumbs : Array = [];

    private var _select : int = 0;

    public function SMulityPageUI() {
        super();
        _slider = new Slider();
        _slider.setCtrlUI(scrollUI.scrollBtn, scrollUI.bg, scrollUI.prevBtn, scrollUI.nextBtn, SliderMode.HORIZONTAL);
        _slider.setData(0, 100, 1, 0);
        _slider.addEventListener(SliderEvent.DATA_UPDATE, __updateHandler);
    }

    public function setData(images : Array) : void {
        _images = images;
        _slider.setData(0, _images.length, 1, 0);
        setSelected(0);
        updateShow();
    }

    private function setSelected(index : int) : void {
        for (var i : int = 0; i < _imageThumbs.length; i++) {
            var thumb : SImagePageThumb = _imageThumbs[i];
            if (i + _slider.getValue() != index) {
                thumb.gotoAndStop(1);
            } else {
                thumb.gotoAndStop(2);
            }
        }
        _select = index;
    }
    
    public function updateSelectedShow():void{
    	var thumb : SImagePageThumb = _imageThumbs[_select - _slider.getValue()];
    	var vo : ExportVo = _images[_select];
    	if(thumb != null){
    		thumb.setData(vo);
    	}
    }

    private function updateShow() : void {
        _currentPageSize = _itemMaxWidth / 85;

        if (_currentPageSize <= 0) {
            _currentPageSize = 1
        }

        var totalPage : int;
        totalPage = _images.length - _currentPageSize;
        _slider.setData(0, totalPage, 1, _slider.getValue());
        scrollUI.visible = _images.length > _currentPageSize;

        var eachWidth : int = _itemMaxWidth / _currentPageSize;

        var maxer : int = Math.max(_currentPageSize, _imageThumbs.length);

        for (var i : int = 0; i < maxer; i++) {
            var thumb : SImagePageThumb = _imageThumbs[i];
            if (thumb == null) {
                thumb = new SImagePageThumb();
                addChildAt(thumb, 1);
                _imageThumbs[i] = thumb;
                thumb.addEventListener(MouseEvent.CLICK, __clickHandler);
            }

            if (i < _currentPageSize) {
                thumb.x = scrollUI.x + i * eachWidth;
                thumb.y = 10;

                var index : int = i + _slider.getValue();
                var vo : ExportVo = _images[index];
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

        setSelected(_select);
    }

    private function __clickHandler(e : MouseEvent) : void {
        var index : int = _imageThumbs.indexOf(e.currentTarget);

        if (index + _slider.getValue() != _select) {
            setSelected(index + _slider.getValue());
            dispatchEvent(new SMulityPageUIEvent(SMulityPageUIEvent.SELECT_ONE, _images[_select]));
        }
    }

    public function resize() : void {
        this.x = 20;

        var w : int = EnterFrameCall.getStage().stageWidth - 200 - 20 - 20 - 140;
        _itemMaxWidth = w;
        bg.width = w;
        scrollUI.bg.width = w - 20 - 30;
        scrollUI.nextBtn.x = scrollUI.bg.width + 13;
        _slider.resetUI();

        this.y = EnterFrameCall.getStage().stageHeight - this.height - 20;
        updateShow();
    }

    private function __updateHandler(e : Event) : void {
        updateShow();
    }
}
}
