package com.xy.view.ui.events {
import flash.events.Event;

public class SCtrlBarEvent extends Event {
	public static const CHANGE_MODEL : String = "CHANGE_MODEL";
	public static const UNDO : String = "UNDO";
	public static const REDO : String = "REDO";

    public function SCtrlBarEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
    }

}
}
