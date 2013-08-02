package com.xy.view.events {
import flash.events.Event;

public class StoreListUIEvent extends Event {
	public static const QUERY : String = "QUERY";
	
    public function StoreListUIEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
    }
}
}
