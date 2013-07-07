package com.xy.view.ui.componet {
import com.xy.component.toolTip.ToolTip;
import com.xy.component.toolTip.enum.ToolTipMode;
import com.xy.ui.FontThumb;
import com.xy.util.SMouse;
import com.xy.util.STool;

import flash.events.MouseEvent;
import flash.text.Font;
import flash.text.FontStyle;

public class SFontThumb extends FontThumb {
    private var _font : Font;

    public function SFontThumb() {
        super();

        addEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
    }

    public function setFont(font : Font) : void {
        _font = font;
        fontNameTf.htmlText = "<font color='#000000' face='" + font.fontName + "'>" + font.fontName + "</font>";
        testTf.htmlText = "<font color='#000000' face='" + font.fontName + "'>ABC</font>";
        ToolTip.setTip(this, STextTip.getInstance(), "[" + font.fontName + "]<br>拖拽到右边添加文字", ToolTipMode.RIGHT_BOTTOM_CENTER);
    }

    private function __downHandler(e : MouseEvent) : void {
        SMouse.getInstance().setMouseFont(_font);
    }
}
}
