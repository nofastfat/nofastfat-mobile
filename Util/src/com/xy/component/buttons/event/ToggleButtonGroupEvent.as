package com.xy.component.buttons.event {
import flash.events.Event;

public class ToggleButtonGroupEvent extends Event {
	public static const STATE_CHANGE : String = "STATE_CHANGE";

	public var selectedIndex : int;

	public function ToggleButtonGroupEvent(type : String, selectedIndex : int, bubbles : Boolean = false, cancelable : Boolean = false) {
		super(type, bubbles, cancelable);
		this.selectedIndex = selectedIndex;
	}
}
}
