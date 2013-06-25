package com.xy.view.ui.componet {
import com.xy.component.toolTip.ToolTip;
import com.xy.component.toolTip.enum.ToolTipMode;
import com.xy.ui.FontThumb;
import com.xy.util.STool;

import flash.text.Font;
import flash.text.FontStyle;

public class SFontThumb extends FontThumb {
    public function SFontThumb() {
        super();

    }

    public function setFont(font : Font) : void {
        fontNameTf.htmlText = "<font face='" + font.fontName + "'>" + font.fontName + "</font>";
        testTf.htmlText = "<font face='" + font.fontName + "'>ABC</font>";
        ToolTip.setTip(this, STextTip.getInstance(), "[" + font.fontName + "]<br>拖拽到右边添加文字", ToolTipMode.RIGHT_BOTTOM_CENTER);
    }
}
}
