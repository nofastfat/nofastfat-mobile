package com.xy.view.ui {
import com.xy.ui.CtrlBar;
import com.xy.util.EnterFrameCall;
import com.xy.view.ui.events.SCtrlBarEvent;

import flash.events.MouseEvent;

public class SCtrlBar extends CtrlBar {
    public function SCtrlBar() {
        super();
        changeModelBtn.addEventListener(MouseEvent.CLICK, __changeModelHandler);
    }

    public function resize() : void {
        var w : int = Math.max(changeModelBtn.x + changeModelBtn.width, EnterFrameCall.getStage().stageWidth - 200 - 20);
        bg.width = w;
    }

    private function __changeModelHandler(e : MouseEvent) : void {
        dispatchEvent(new SCtrlBarEvent(SCtrlBarEvent.CHANGE_MODEL));
    }
}
}
