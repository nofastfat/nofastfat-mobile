package com.xy.view.event {
import starling.events.Event;

public class GamingMenuEvent extends Event {
	public static const SAVE_EXIT : String = "SAVE_EXIT";
	
	public function GamingMenuEvent(type : String, bubbles : Boolean = false, data : Object = null) {
		super(type, bubbles, data);
	}
}
}
