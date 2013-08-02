package com.xy.view.events {
import flash.events.Event;

public class ModifyPwdPanelEvent extends Event {
    public static const MODIFY_PWD : String = "MODIFY_PWD";

    public var oldPwd : String;
    public var newPwd : String;

    public function ModifyPwdPanelEvent(type : String, oldPwd : String, newPwd : String, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);

        this.oldPwd = oldPwd;
        this.newPwd = newPwd;
    }
}
}
