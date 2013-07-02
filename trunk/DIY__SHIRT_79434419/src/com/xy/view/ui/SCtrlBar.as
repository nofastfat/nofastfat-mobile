package com.xy.view.ui {
import com.xy.ui.CtrlBar;
import com.xy.util.EnterFrameCall;
import com.xy.util.STool;
import com.xy.view.ui.events.SCtrlBarEvent;

import flash.events.MouseEvent;

public class SCtrlBar extends CtrlBar {
    public function SCtrlBar() {
        super();
        changeModelBtn.addEventListener(MouseEvent.CLICK, __changeModelHandler);
        undoBtn.addEventListener(MouseEvent.CLICK, __undoHandler);
        redoBrn.addEventListener(MouseEvent.CLICK, __redoHandler);

    }

    public function updateData(historys : Array, historyIndex : int) : void {
        STool.setButtonEnable(undoBtn, historyIndex >= 0);
        STool.setButtonEnable(redoBrn, historyIndex + 1 < historys.length);
    }

    public function resize() : void {
        var w : int = Math.max(changeModelBtn.x + changeModelBtn.width, EnterFrameCall.getStage().stageWidth - 200 - 20);
        bg.width = w;
    }

    private function __changeModelHandler(e : MouseEvent) : void {
        dispatchEvent(new SCtrlBarEvent(SCtrlBarEvent.CHANGE_MODEL));
    }

    private function __undoHandler(e : MouseEvent) : void {
        dispatchEvent(new SCtrlBarEvent(SCtrlBarEvent.UNDO));
    }

    private function __redoHandler(e : MouseEvent) : void {
        dispatchEvent(new SCtrlBarEvent(SCtrlBarEvent.REDO));
    }
}
}
