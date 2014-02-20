package com.xy.mediators {
import com.xy.model.Global;
import com.xy.ui.views.TopUI;

import flash.events.MouseEvent;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;


/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-18 下午3:46:13
 **/
public class TopMediator extends Mediator {
	public static const NAME : String = "TopMediator";

	public static const INIT : String = NAME + "INIT";

	public function TopMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
		
		ui.logoutTf.addEventListener(MouseEvent.CLICK, __logoutHandler);
	}

	override public function listNotificationInterests():Array{
		return [INIT];
	}
	
	override public function handleNotification(notification:INotification):void{
		switch(notification.getName()){
			case INIT:
				init();
				break;
		}
	}
	
	private function init():void{
		ui.setName(Global.userName);
	}
	
	private function __logoutHandler(e : MouseEvent):void{
		sendNotification(LoginMediator.SHOW);
	}
	
	public function get ui() : TopUI {
		return viewComponent as TopUI;
	}
}
}
