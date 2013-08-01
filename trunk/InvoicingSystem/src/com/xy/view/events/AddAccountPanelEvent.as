package com.xy.view.events {
import com.xy.model.vo.AccountVo;

import flash.events.Event;

public class AddAccountPanelEvent extends Event {
    public static const ADD_USER : String = "ADD_USER";

    public var vo : AccountVo;

    public function AddAccountPanelEvent(type : String, vo : AccountVo, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.vo = vo;
    }
}
}
