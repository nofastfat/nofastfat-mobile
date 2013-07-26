package com.xy.view.events {
import com.xy.model.vo.GoodsVo;

import flash.events.Event;

public class GoodsPanelEvent extends Event {
    public static const ADD_SUBMIT : String = "ADD_SUBMIT";

    public static const MODIFY_SUBMIT : String = "MODIFY_SUBMIT";

	public var vo : GoodsVo;

    public function GoodsPanelEvent(type : String, vo : GoodsVo, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
		this.vo = vo;
    }
}
}
