package com.xy.view.ui.events {
import flash.events.Event;

public class EditTextPanelEvent extends Event {
    public static const EDIT : String = "EDIT";

    public var text : String;

    public function EditTextPanelEvent(type : String, text : String, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.text = text;
    }
}
}
