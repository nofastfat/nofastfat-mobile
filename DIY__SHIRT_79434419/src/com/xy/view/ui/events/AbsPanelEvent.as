package com.xy.view.ui.events {
import flash.events.Event;

public class AbsPanelEvent extends Event {
    public static const CLOSE : String = "CLOSE";

    public function AbsPanelEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
    }
}
}
