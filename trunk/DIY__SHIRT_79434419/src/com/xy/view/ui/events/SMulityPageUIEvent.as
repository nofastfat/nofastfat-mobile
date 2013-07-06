package com.xy.view.ui.events {
import com.xy.model.vo.ExportVo;

import flash.events.Event;

public class SMulityPageUIEvent extends Event {
    public static const SELECT_ONE : String = "SELECT_ONE";

    public var vo : ExportVo;

    public function SMulityPageUIEvent(type : String, vo : ExportVo, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.vo = vo;
    }

}
}
