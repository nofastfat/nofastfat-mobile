package com.xy.view.events {
import com.xy.model.vo.GoodsVo;

import flash.events.Event;

public class GoodsManageUIEvent extends Event {
    public static const ADD_GOODS : String = "ADD_GOODS";
	public static const DELETE_GOODS : String = "DELETE_GOODS";
	public static const MODIFY_GOODS : String = "MODIFY_GOODS";
	
	public static const QUERY : String = "QUERY";

    public var vo : GoodsVo;

    public function GoodsManageUIEvent(type : String, vo : GoodsVo, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.vo = vo;
    }
}
}
