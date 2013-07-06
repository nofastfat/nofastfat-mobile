package com.xy.view.ui.panels {
import com.xy.model.vo.CalVo;
import com.xy.ui.BlueButton;
import com.xy.ui.ChooseCalPanel;
import com.xy.util.EnterFrameCall;
import com.xy.util.STool;
import com.xy.util.Tools;
import com.xy.view.ui.componet.ScrollMenu;
import com.xy.view.ui.events.ScrollMenuEvent;

import flash.events.MouseEvent;


public class ChooseCalendar extends AbsPanel {
    private var _content : ChooseCalPanel;
    private var _startBtn : BlueButton;
    private var _scrollMenu : ScrollMenu;
    private var _dates : Array = [];
    private var _ends : Array = [];

    public function ChooseCalendar(w : int = 388, h : int = 230, title : String = "选择日历起止时间") {
        super(w, h, title);

        _content = new ChooseCalPanel();
        container.addChild(_content);

        _startBtn = Tools.makeBlueButton("开始DIY");
        container.addChild(_startBtn);

        _startBtn.y = _content.height + 20;
        _startBtn.x = 130;

        _scrollMenu = new ScrollMenu();

        _content.selectBtn.tf.mouseEnabled = false;
        _content.selectBtn.buttonMode = true;
        _content.selectBtn.addEventListener(MouseEvent.CLICK, __showMenuHandler);
        _scrollMenu.addEventListener(ScrollMenuEvent.CHOOSE_VALUE, __chooseHandler);
        _startBtn.addEventListener(MouseEvent.CLICK, __closeHandler);
        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_UP, __upHandler);
    }

    public function setData(dates : Array) : void {
        _dates = dates;
        _ends = _dates.splice(_dates.length - 11, 11);
        _content.selectBtn.tf.text = dates[0];
        updateInfo();
    }

    private function __showMenuHandler(e : MouseEvent) : void {
        _scrollMenu.showBy(_dates, _content.selectBtn, "", _content.selectBtn.tf.text);
    }

    private function __chooseHandler(e : ScrollMenuEvent) : void {
        _content.selectBtn.tf.text = e.value;
        updateInfo();
    }

    private function __upHandler(e : MouseEvent) : void {
        STool.remove(_scrollMenu);
    }

    private function getValue() : Array {
        var txt : String = _content.selectBtn.tf.text;
        txt = txt.substr(0, txt.length - 1);
        var arr : Array = txt.split("年");
        return [int(arr[0]), int(arr[1])];
    }

    public function getResult() : Array {
        var arr : Array = [];
        var vl : Array = getValue();
        var startIndex : int = 0;
        for (var i : int = 0; i < _dates.length; i++) {
            var vo : CalVo = _dates[i];
            if (vo.year == vl[0] && vo.month == vl[1]) {
                startIndex = i;
                break;
            }
        }

        for (i = 0; i < 12; i++) {
            var index : int = i + startIndex;
            var tmpVp : CalVo;
            if (_dates.length - 1 >= index) {
                tmpVp = _dates[index];
            } else {
                tmpVp = _ends[index - _dates.length];
            }
            arr.push(tmpVp);
        }
        return arr;
    }

    private function updateInfo() : void {
        var vl : Array = getValue();
        var txt : String = "日历月份从<b><font color='#D55C0D'>{0}</font></b>年<b><font color='#D55C0D'>{1}</font></b>月-<b><font color='#D55C0D'>{2}</font></b>年<b><font color='#D55C0D'>{3}</font></b>月";
        var startIndex : int = 0;
        for (var i : int = 0; i < _dates.length; i++) {
            var vo : CalVo = _dates[i];
            if (vo.year == vl[0] && vo.month == vl[1]) {
                startIndex = i;
                break;
            }
        }
        startIndex += 11;

        var endVo : CalVo;
        if (_dates.length - 1 >= startIndex) {
            endVo = _dates[startIndex];
        } else {
            endVo = _ends[startIndex - _dates.length];
        }

        _content.infoText.htmlText = STool.format(txt, vl[0], vl[1], endVo.year, endVo.month);
    }

}
}
