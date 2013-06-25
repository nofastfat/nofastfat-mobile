package com.xy.view.ui.events {
import flash.events.Event;

public class SSimpleColorUIEvent extends Event {
    public static const CHOOSE_COLOR : String = "CHOOSE_COLOR";

    public var color : uint;

    public function SSimpleColorUIEvent(type : String, color : uint, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.color = color;
    }
}
}
