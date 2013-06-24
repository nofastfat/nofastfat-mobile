package com.xy.view.ui.events {
import flash.events.Event;

public class SImageThumbUIEvent extends Event {
    public static const STATUS_CHANGE : String = "STATUS_CHANGE";

    public var selected : Boolean;

    public function SImageThumbUIEvent(type : String, selected : Boolean, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.selected = selected;
    }
}
}
