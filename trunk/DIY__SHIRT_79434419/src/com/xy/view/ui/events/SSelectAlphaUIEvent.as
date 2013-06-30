package com.xy.view.ui.events {
import flash.events.Event;

public class SSelectAlphaUIEvent extends Event {
    public static const ALPHA_CHANGE : String = "ALPHA_CHANGE";

    public var alpha : Number;

    public function SSelectAlphaUIEvent(type : String, alpha : Number, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.alpha = alpha;
    }

}
}
