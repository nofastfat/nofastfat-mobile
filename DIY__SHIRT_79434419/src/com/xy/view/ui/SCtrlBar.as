package com.xy.view.ui {
import com.xy.component.toolTip.ToolTip;
import com.xy.component.toolTip.enum.ToolTipMode;
import com.xy.ui.CtrlBar;
import com.xy.util.EnterFrameCall;
import com.xy.util.GrayColor;
import com.xy.util.STool;
import com.xy.view.ui.events.SCtrlBarEvent;

import flash.events.MouseEvent;

public class SCtrlBar extends CtrlBar {
    public function SCtrlBar() {
        super();
        changeModelBtn.addEventListener(MouseEvent.CLICK, __changeModelHandler);
        undoBtn.addEventListener(MouseEvent.CLICK, __undoHandler);
        redoBrn.addEventListener(MouseEvent.CLICK, __redoHandler);
//		mergeBtn.addEventListener(MouseEvent.CLICK, __groupHandler);
//		unmergeBtn.addEventListener(MouseEvent.CLICK, __ungroupHandler);

        ToolTip.setSimpleYellowTip(undoBtn, "Ctrl+Z", ToolTipMode.RIGHT_BOTTOM_CENTER);
        ToolTip.setSimpleYellowTip(redoBrn, "Ctrl+Y", ToolTipMode.RIGHT_BOTTOM_CENTER);
//        ToolTip.setSimpleYellowTip(mergeBtn, "Ctrl+G", ToolTipMode.RIGHT_BOTTOM_CENTER);
//        ToolTip.setSimpleYellowTip(unmergeBtn, "Ctrl+Shift+G", ToolTipMode.RIGHT_BOTTOM_CENTER);
		
		updateGroup(false, false);

    }

    public function updateData(historys : Array, historyIndex : int) : void {

        if (historyIndex >= 0) {
            undoBtn.alpha = 1;
        } else {
            undoBtn.alpha = 0.5;
        }
        STool.setButtonEnable(undoBtn, historyIndex >= 0);


        if (historyIndex + 1 < historys.length) {
            redoBrn.alpha = 1;
            redoBrn.filters = [];
        } else {
            redoBrn.alpha = 0.5;
            redoBrn.filters = GrayColor.value;
        }
        STool.setButtonEnable(redoBrn, historyIndex + 1 < historys.length);
    }

    public function updateGroup(canGroup : Boolean, canUnGroup : Boolean) : void {
//        if (canGroup) {
//            mergeBtn.alpha = 1;
//        } else {
//            mergeBtn.alpha = 0.5;
//        }
//        STool.setButtonEnable(mergeBtn, canGroup);
//
//        if (canUnGroup) {
//            unmergeBtn.alpha = 1;
//        } else {
//            unmergeBtn.alpha = 0.5;
//        }
//        STool.setButtonEnable(unmergeBtn, canUnGroup);
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
	private function __groupHandler(e : MouseEvent) : void {
		dispatchEvent(new SCtrlBarEvent(SCtrlBarEvent.GROUP));
	}
	private function __ungroupHandler(e : MouseEvent) : void {
		dispatchEvent(new SCtrlBarEvent(SCtrlBarEvent.UNGROUP));
	}
	
}
}
