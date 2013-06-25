package com.xy.view.ui.events {
import flash.events.Event;

public class BackgroundContainerEvent extends Event {
    public static const SHOW_MORE_PANEL : String = "SHOW_MORE_PANEL";
    public static const UPDATE_BACKGROUND : String = "UPDATE_BACKGROUND";
    public static const HIDE_BACKGROUND : String = "HIDE_BACKGROUND";

    public var color : uint;
    public var hideId : String;

    public function BackgroundContainerEvent(type : String, hideId : String = null, color : uint = 0, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.color = color;
        this.hideId = hideId;
    }
}
}
