package com.xy.view.event {
import starling.events.Event;

public class CtrlBarEvent extends Event {
	public static const SHOW_GAMING_MENU : String = "SHOW_GAMING_MENU";
	
	public function CtrlBarEvent(type : String, bubbles : Boolean = false, data : Object = null) {
		super(type, bubbles, data);
	}
}
}
