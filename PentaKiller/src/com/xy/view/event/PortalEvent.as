package com.xy.view.event {
import starling.events.Event;

public class PortalEvent extends Event {
	public static const CHOOSE_MAP : String = "CHOOSE_MAP";
	
	public function PortalEvent(type : String, bubbles : Boolean = false, data : Object = null) {
		super(type, bubbles, data);
	}
}
}
