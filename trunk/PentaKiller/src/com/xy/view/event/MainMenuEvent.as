package com.xy.view.event {
import starling.events.Event;

public class MainMenuEvent extends Event {
	public static const CONTINUE_GAME : String = "CONTINUE_GAME";
	public static const NEW_GAME : String = "NEW_GAME";
	public static const SETTING : String = "SETTING";
	
	public function MainMenuEvent(type : String, bubbles : Boolean = false, data : Object = null) {
		super(type, bubbles, data);
	}
}
}
