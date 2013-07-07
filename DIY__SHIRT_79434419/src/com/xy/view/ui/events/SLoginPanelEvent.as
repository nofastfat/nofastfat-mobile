package com.xy.view.ui.events {
import flash.events.Event;

public class SLoginPanelEvent extends Event {
    public static const LOGIN : String = "LOGIN";

    public var uName : String;
    public var pwd : String

    public function SLoginPanelEvent(type : String, uName : String, pwd : String, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.uName = uName;
        this.pwd = pwd;
    }

}
}
