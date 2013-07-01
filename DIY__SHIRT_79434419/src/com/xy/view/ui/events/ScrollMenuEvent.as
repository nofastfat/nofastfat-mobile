package com.xy.view.ui.events {
import flash.events.Event;

public class ScrollMenuEvent extends Event {
    public static const CHOOSE_VALUE : String = "CHOOSE_VALUE";

    public var value : String;

    public function ScrollMenuEvent(type : String, value : String, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.value = value;
    }
}
}
