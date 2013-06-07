package com.xy.view.event {
import com.xy.model.vo.SimpleTaskVo;

import flash.events.Event;

public class SSimpleInfoCardEvent extends Event {
    public static const CLOSE : String = "CLOSE";

    public static const SHOW_TASK_CHILD : String = "SHOW_TASK_CHILD";

    public var currentVo : SimpleTaskVo;
    public var siblingVos : Array;
    public var index : int;

    public function SSimpleInfoCardEvent(type : String, currentVo : SimpleTaskVo = null, siblingVos : Array = null, index : int = 0, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.currentVo = currentVo;
        this.siblingVos = siblingVos;
        this.index = index;
    }

}
}
