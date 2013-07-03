package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.util.EnterFrameCall;

import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

public class KeyboardMediator extends AbsMediator {
    public static const NAME : String = "KeyboardMediator";

    public function KeyboardMediator() {
        super(NAME);
    }

    override public function onRegister() : void {
        EnterFrameCall.getStage().addEventListener(KeyboardEvent.KEY_DOWN, __keyDownHandler);
    }

    private function __keyDownHandler(e : KeyboardEvent) : void {
        switch (e.keyCode) {
			case Keyboard.BACKSPACE:
			case Keyboard.DELETE:
				sendNotification(RightContainerMediator.KEY_DELETE);
                break;

            case "z".charCodeAt(0):
            case "Z".charCodeAt(0):
				if(e.ctrlKey){
					dataProxy.undo();
				}
                break;

            case "y".charCodeAt(0):
            case "Y".charCodeAt(0):
				if(e.ctrlKey){
					dataProxy.redo();
				}
                break;

            case "g".charCodeAt(0):
            case "G".charCodeAt(0):
                break;

        }
    }

}
}
