package com.xy.view.ui.componet {
import com.xy.component.Slider.Slider;
import com.xy.component.Slider.SliderMode;
import com.xy.component.Slider.event.SliderEvent;
import com.xy.ui.ButtonList;
import com.xy.ui.ScrollUI;
import com.xy.util.EnterFrameCall;
import com.xy.util.STool;
import com.xy.util.Tools;
import com.xy.view.ui.events.ScrollMenuEvent;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

public class ScrollMenu extends Sprite {
    private var _slider : Slider;
    private var _scroll : ScrollUI;
    private var _data : Array;
    private var _btns : Array;
    private var _endPrix : String;

    private var _source : DisplayObject;
    private var _lastIndex : int;

    public function ScrollMenu() {
        super();
        _slider = new Slider();
        _scroll = new ScrollUI();
        _slider.setCtrlUI(_scroll.scrollBtn, _scroll.bg, _scroll.prevBtn, _scroll.nextBtn, SliderMode.VERTICAL);

        _slider.addEventListener(SliderEvent.DATA_UPDATE, __sliderHandler);

        _btns = [];
        var h : Number = 0;
        for (var i : int = 0; i < 6; i++) {
            var btn : ButtonList = new ButtonList();
            btn.textTf.mouseEnabled = false;
            _btns.push(btn);
            addChild(btn);
            btn.y = h;

            h += btn.height;
            btn.addEventListener(MouseEvent.CLICK, __clickHandler);
        }
        addChild(_scroll);
        _scroll.bg.height = h - btn.height;
        _scroll.prevBtn.y = 0;
        _scroll.bg.y = _scroll.prevBtn.height;
        _scroll.nextBtn.y = _scroll.bg.height + _scroll.nextBtn.height + 7;
    }

    public function get source() : DisplayObject {
        return _source;
    }

    public function showBy(data : Array, sourceTarget : DisplayObject, endPrix : String, currentValue : *) : void {
        _scroll.x = sourceTarget.width;
        _source = sourceTarget;
        _data = data;
        var index : int = _data.indexOf(currentValue) - _lastIndex;
		if(index < 0){
            index = 0;
		}
        _slider.setData(0, _data.length - 6, 1, index);
        _slider.resetUI();
        _endPrix = endPrix;
        EnterFrameCall.getStage().addChild(this);
        var p : Point = new Point(sourceTarget.x, sourceTarget.y + sourceTarget.height);
        p = sourceTarget.parent.localToGlobal(p);
        this.x = p.x;
        this.y = p.y;

        for (var i : int = 0; i < 6; i++) {
            var btn : ButtonList = _btns[i]
            btn.textTf.width = btn.btn.width = sourceTarget.width;
        }

        updateShow();
    }

    public function close() : void {
        STool.remove(this);
    }

    public function isEventNotIn(source : *) : Boolean {
        return source != this &&
            _btns.indexOf(source) == -1 &&
            source != _scroll &&
            source != _scroll.scrollBtn &&
            source != _scroll.bg &&
            source != _scroll.prevBtn &&
            source != _scroll.nextBtn;
    }

    private function updateShow() : void {
        for (var i : int = 0; i < 6; i++) {
            var btn : ButtonList = _btns[i];
            btn.textTf.text = _data[_slider.getValue() + i] + _endPrix;
        }
    }

    private function __sliderHandler(e : SliderEvent) : void {
        updateShow();
    }

    private function __clickHandler(e : MouseEvent) : void {
        var index : int = _btns.indexOf(e.currentTarget);
        if (index == -1) {
            return;
        }
        var data : String = _data[index + _slider.getValue()];
        _lastIndex = index;

        dispatchEvent(new ScrollMenuEvent(ScrollMenuEvent.CHOOSE_VALUE, data));
        close();
    }
}
}
