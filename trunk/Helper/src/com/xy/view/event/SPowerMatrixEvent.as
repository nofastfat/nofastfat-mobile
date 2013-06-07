package com.xy.view.event {
import flash.events.Event;

public class SPowerMatrixEvent extends Event {
	public static const CLOSE : String = "CLOSE";
	
    public function SPowerMatrixEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
    }

}
}
