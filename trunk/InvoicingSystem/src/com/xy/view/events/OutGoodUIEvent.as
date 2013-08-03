package com.xy.view.events {
import com.xy.model.vo.SoldVo;

import flash.events.Event;

public class OutGoodUIEvent extends Event {
    public static const SHOW_CHOOSE_STROE_PANEL : String = "SHOW_CHOOSE_STROE_PANEL";

    public static const SHOW_ADD_COURIER_PANEL : String = "SHOW_ADD_COURIER_PANEL";

    public static const SUBMIT : String = "SUBMIT";

    public var vo : SoldVo;

    public function OutGoodUIEvent(type : String, vo : SoldVo = null, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.vo = vo;
    }

}
}
