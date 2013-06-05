package com.xy.component.buttons.event {
import flash.events.Event;

public class ToggleButtonEvent extends Event {
	public static const STATE_CHANGE : String = "STATE_CHANGE";
	
	public var selected : Boolean;
	
	public function ToggleButtonEvent(type : String, selected : Boolean, bubbles : Boolean = false, cancelable : Boolean = false) {
		super(type, bubbles, cancelable);
		this.selected = selected;
	}
}
}
