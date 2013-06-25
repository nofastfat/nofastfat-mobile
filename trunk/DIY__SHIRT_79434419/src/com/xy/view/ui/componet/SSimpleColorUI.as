package com.xy.view.ui.componet {
import com.xy.component.colorPicker.ColorPicker;
import com.xy.component.colorPicker.ColorPikerEvent;
import com.xy.component.colorPicker.enum.PreSwatches;
import com.xy.ui.SimpleColorUI;
import com.xy.util.EnterFrameCall;
import com.xy.util.STool;
import com.xy.view.ui.events.SSimpleColorUIEvent;

import flash.events.MouseEvent;
import flash.geom.Point;

public class SSimpleColorUI extends SimpleColorUI {
    private var _piker : ColorPicker;

    public function SSimpleColorUI() {
        super();
        _piker = new ColorPicker(16, 8, new Point(11, 11), PreSwatches.PS_COLORS);

        colorBtn.addEventListener(MouseEvent.CLICK, __showColorPickerHandler);
        _piker.addEventListener(ColorPikerEvent.SELECT_COLOR, __selectColorHandler);
        EnterFrameCall.getStage().addEventListener(MouseEvent.CLICK, __hideHandler);
    }

    private function __showColorPickerHandler(e : MouseEvent) : void {
        var p : Point = new Point(x, y);
        p = parent.localToGlobal(p);
        p.y = p.y - _piker.height - 5;

        EnterFrameCall.getStage().addChild(_piker);
        _piker.x = p.x;
        _piker.y = p.y;
        e.stopImmediatePropagation();
        e.stopPropagation();
    }

    private function __hideHandler(e : MouseEvent) : void {
        STool.remove(_piker);

    }

    private function __selectColorHandler(e : ColorPikerEvent) : void {
        dispatchEvent(new SSimpleColorUIEvent(SSimpleColorUIEvent.CHOOSE_COLOR, e.color));
    }
}
}
