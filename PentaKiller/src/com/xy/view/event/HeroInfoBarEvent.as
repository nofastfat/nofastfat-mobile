package com.xy.view.event {
import starling.events.Event;

public class HeroInfoBarEvent extends Event {
	/**
	 * 变身 
	 */	
	public static const BE_SUPER_HERO : String = "BE_SUPER_HERO";
	
	public function HeroInfoBarEvent(type : String, bubbles : Boolean = false, data : Object = null) {
		super(type, bubbles, data);
	}
}
}
