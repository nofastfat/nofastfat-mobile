package com.xy.view.ui.events {
import flash.events.Event;

public class ChooseBackgroundPanelEvent extends Event {
	public static const BACKGROUND_STATUS : String = "BACKGROUND_STATUS";
	
    public function ChooseBackgroundPanelEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
    }
}
}
