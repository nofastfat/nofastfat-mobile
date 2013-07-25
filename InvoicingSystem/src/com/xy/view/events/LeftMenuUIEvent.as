package com.xy.view.events {
import flash.events.Event;

public class LeftMenuUIEvent extends Event {
    public static const SHOW_IN_GOODS : String = "SHOW_IN_GOODS";
    public static const SHOW_OUT_GOODS : String = "SHOW_OUT_GOODS";
    public static const SHOW_STORGE : String = "SHOW_STORGE";
    public static const SHOW_FINANCE : String = "SHOW_FINANCE";
    public static const SHOW_ACCOUNT : String = "SHOW_ACCOUNT";

    public function LeftMenuUIEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
    }
}
}
