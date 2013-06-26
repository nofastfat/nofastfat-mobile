package com.xy.view.ui.events {
import flash.events.Event;

public class LeftCtrlEvent extends Event {
    public static const INIT : String = "INIT";

    public var index : int;

    public function LeftCtrlEvent(type : String, index : int, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
		this.index = index;
    }
}
}
