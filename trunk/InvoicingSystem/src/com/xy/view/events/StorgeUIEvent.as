package com.xy.view.events {
import com.xy.view.ui.StorgeUI;

import flash.events.Event;

public class StorgeUIEvent extends Event {
    public static const SHOW_STORE_SEARCH : String = "SHOW_STORE_SEARCH";
    public static const SHOW_GOODS_MANAGE : String = "SHOW_GOODS_MANAGE";
    public static const SHOW_COURIER_MANAGE : String = "SHOW_COURIER_MANAGE";
    public static const SHOW_IN_GOODS_LOG : String = "SHOW_IN_GOODS_LOG";
    public static const SHOW_OUT_GOODS_LOG : String = "SHOW_OUT_GOODS_LOG";

    public var storgeUI : StorgeUI;

    public function StorgeUIEvent(type : String, storgeUI : StorgeUI, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.storgeUI = storgeUI;
    }
}
}
