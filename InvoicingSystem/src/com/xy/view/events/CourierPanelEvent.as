package com.xy.view.events {
import com.xy.model.vo.CourierVo;

import flash.events.Event;

public class CourierPanelEvent extends Event {
    public static const ADD_SUBMIT : String = "ADD_SUBMIT";

    public static const MODIFY_SUBMIT : String = "MODIFY_SUBMIT";

	public var vo : CourierVo;

    public function CourierPanelEvent(type : String, vo : CourierVo, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
		this.vo = vo;
    }

}
}
