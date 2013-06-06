package com.xy.view.event {
import flash.events.Event;

public class TreeContainerEvent extends Event {
    public static const LOCATION_MOVE : String = "LOCATION_MOVE";

    public var offsetX : Number;
    public var offsetY : Number;

    public function TreeContainerEvent(type : String, offsetX : Number, offsetY : Number, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.offsetX = offsetX;
        this.offsetY = offsetY;
    }
}
}
