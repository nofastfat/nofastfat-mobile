package com.xy.view.events {
import flash.events.Event;

public class LoginUIEvent extends Event {
    public static const SUBMIT : String = "SUBMIT";

    public var uName : String;
    public var uPwd : String;

    public function LoginUIEvent(type : String, uName : String, uPwd : String,bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
		
		this.uName = uName;
		this.uPwd = uPwd;
    }
}
}
