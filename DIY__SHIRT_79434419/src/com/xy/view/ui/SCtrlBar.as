package com.xy.view.ui {
import com.xy.ui.CtrlBar;
import com.xy.util.EnterFrameCall;

public class SCtrlBar extends CtrlBar {
    public function SCtrlBar() {
        super();
    }

    public function resize() : void {
        var w : int = Math.max(changeModelBtn.x + changeModelBtn.width, EnterFrameCall.getStage().stageWidth - 200 - 20);
        bg.width = w;
    }
}
}
