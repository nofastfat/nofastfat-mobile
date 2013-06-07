package com.xy.view.event {
import com.xy.model.vo.TaskVo;

import flash.events.Event;

public class STaskCardEvent extends Event {
    public static const SHOW_DETAIL : String = "SHOW_DETAIL";

    public var vo : TaskVo;
    
    public var selected : Boolean;

    public function STaskCardEvent(type : String, vo : TaskVo, selected:Boolean, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.vo = vo;
        this.selected = selected;
    }

}
}
