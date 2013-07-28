package com.xy.view.events {
import com.xy.model.vo.GoodsVo;
import com.xy.model.vo.StoreVo;

import flash.events.Event;

public class InGoodsUIEvent extends Event {
    /**
     * 添加商品
     */
    public static const ADD_GOODS : String = "ADD_GOODS";
    
    /**
     * 入库
     */
    public static const ADD_STORE : String = "ADD_STORE";

    public var goods : GoodsVo;
    public var store : StoreVo;

    public function InGoodsUIEvent(type : String, store : StoreVo= null,goods : GoodsVo = null, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.store = store;
        this.goods = goods;
    }

}
}
