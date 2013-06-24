package com.xy.view.ui.events {
import flash.events.Event;

public class SImageSizeUIEvent extends Event {
    public static const STATUS_CHANGE : String = "STATUS_CHANGE";
    
    public var selected : int;

    public function SImageSizeUIEvent(type : String, selected : int,bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.selected = selected;
    }

}
}
