package com.xy.view.sprite {

import com.xy.view.event.CtrlBarEvent;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;

/**
 * 控制面板
 * @author xy
 */
public class CtrlBar extends Sprite {
	private var _menuBtn : Button;

	public function CtrlBar() {
		super();

		_menuBtn = Assets.makeBtnUI("menuBtn");
		addChild(_menuBtn);
		
		_menuBtn.addEventListener(Event.TRIGGERED, __clickMenuHandler);
	}
	
	private function __clickMenuHandler(e : Event) : void {
		dispatchEventWith(CtrlBarEvent.SHOW_GAMING_MENU);
	}
}
}
