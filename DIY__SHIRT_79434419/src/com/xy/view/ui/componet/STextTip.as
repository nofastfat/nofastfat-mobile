package com.xy.view.ui.componet {
import com.xy.component.toolTip.interfaces.ITipViewContent;
import com.xy.ui.TextTip;

public class STextTip extends TextTip implements ITipViewContent {

    private static var _imageTip : STextTip = new STextTip();

    public static function getInstance() : STextTip {
        return _imageTip;
    }

    public function STextTip() {
        super();
    }

    public function setData(data : *) : void {
        msgTf.htmlText = "<font color='#000000'>" + data + "</font>";
    }

    public function destroy() : void {
    }
}
}
