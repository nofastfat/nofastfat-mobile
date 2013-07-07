package com.xy.view.ui.ctrls {
import com.xy.component.Slider.Slider;
import com.xy.component.Slider.SliderMode;
import com.xy.component.Slider.event.SliderEvent;
import com.xy.model.URLConfig;
import com.xy.ui.ScrollUI;
import com.xy.util.STool;
import com.xy.view.ui.componet.SFontThumb;

import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class FontContainer extends AbsContainer {
    private var _slider : Slider;
    private var _scrollUI : ScrollUI;

    private var _itemMaxHeight : int;
    private var _currentPageSize : int;


    private var _fonts : Array = [];
    private var _fontThumbs : Array = [];

    private var _tf : TextField;

    public function FontContainer() {
        super();


        _scrollUI = new ScrollUI();
        addChild(_scrollUI);

        _slider = new Slider();
        _slider.setCtrlUI(_scrollUI.scrollBtn, _scrollUI.bg, _scrollUI.prevBtn, _scrollUI.nextBtn, SliderMode.VERTICAL);
        _slider.setData(0, 10, 1, 0);

        _scrollUI.x = 200 - _scrollUI.width - 5;

        _scrollUI.y = 15;
        _slider.addEventListener(SliderEvent.DATA_UPDATE, __sliderHandler);

        _tf = new TextField();
        _tf.height = 20;
        _tf.width = 200;
		//_tf.filters = [new GlowFilter(0x000000, 1, 3, 3, 5)];
        _tf.defaultTextFormat = new TextFormat("宋体", 12, 0x0000ff, null, null, true, URLConfig.HOW_TO_ADD_FONT, "_blank", TextFormatAlign.CENTER);
        _tf.htmlText = "<a href='" + URLConfig.HOW_TO_ADD_FONT + "' target='_blank'><font face='宋体' color='#0000ff'>如何使用更多的字体？</font></a>";
        addChild(_tf);
    }

    public function setData(fonts : Array) : void {
        _fonts = fonts;
        updateShow();
    }


    private function updateShow() : void {
        _currentPageSize = _itemMaxHeight / 65;

        var totalPage : int;
        totalPage = _fonts.length - _currentPageSize;
        _slider.setData(0, totalPage, 1, _slider.getValue());
        _scrollUI.visible = _fonts.length > _currentPageSize;
        var sx : int = _scrollUI.visible ? _scrollUI.x : 200;
        var eachHeight : int = _itemMaxHeight / _currentPageSize;
        var maxer : int = Math.max(_currentPageSize, _fontThumbs.length);


        for (var i : int = 0; i < maxer; i++) {
            var thumb : SFontThumb = _fontThumbs[i];
            if (thumb == null) {
                thumb = new SFontThumb();
                addChildAt(thumb, 1);
                _fontThumbs[i] = thumb;
            }
            var font : Font = _fonts[_slider.getValue() + i];
            if (font == null) {
                thumb.visible = false;
            } else {
                thumb.visible = true;
                thumb.setFont(font);
                thumb.x = (sx - thumb.width) / 2;
                thumb.y = i * eachHeight + _scrollUI.y;
            }
        }
    }

    private function __sliderHandler(e : SliderEvent) : void {
        updateShow();
    }

    override public function resize(height : int) : void {
        super.resize(height);

        _itemMaxHeight = height - 50;

        if (_scrollUI != null) {
            _scrollUI.bg.height = _itemMaxHeight;
            _scrollUI.prevBtn.y = 0;
            _scrollUI.bg.y = _scrollUI.prevBtn.height;
            _scrollUI.nextBtn.y = _scrollUI.bg.height + _scrollUI.nextBtn.height;
            _slider.resetUI();
        }
        updateShow();

        _tf.y = _itemMaxHeight + 25;
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
