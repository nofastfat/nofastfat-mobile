package com.xy.view.events {
import com.xy.model.vo.CourierVo;

import flash.events.Event;

public class CourierUIEvent extends Event {
	
    public static const ADD_COURIER : String = "ADD_COURIER";
	public static const DELETE_COURIER : String = "DELETE_COURIER";
	public static const MODIFY_COURIER : String = "MODIFY_COURIER";
	
	public static const QUERY : String = "QUERY";

    public var vo : CourierVo;

    public function CourierUIEvent(type : String, vo : CourierVo, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.vo = vo;
    }

}
}
