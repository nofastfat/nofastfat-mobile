package com.xy.view.ui.events {
import flash.events.Event;

public class ImageContainerEvent extends Event {
	public static const UPLOAD_IMAGE : String = "UPLOAD_IMAGE";
	
	public static const UPDATE_SELECT : String = "UPDATE_SELECT";
	
    public function ImageContainerEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
    }
}
}
