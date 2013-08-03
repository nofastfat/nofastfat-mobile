package com.xy.view.events {
import flash.events.Event;

public class AddFromStorePanelEvent extends Event {
	public static const SUBMIT : String = "SUBMIT";
	
	public var arr : Array;
	
    public function AddFromStorePanelEvent(type : String, arr : Array,bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.arr = arr;
    }

}
}
