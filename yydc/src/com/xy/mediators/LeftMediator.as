package com.xy.mediators {
import com.xy.ui.views.LeftUI;

import flash.events.MouseEvent;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;


/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-18 下午4:03:12
 **/
public class LeftMediator extends Mediator {
	public static const NAME : String = "LeftMediator";

	public static const INIT : String = NAME + "INIT";

	public function LeftMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
		ui.cpBtn.addEventListener(MouseEvent.CLICK, __cpHandler);
		ui.hzBtn.addEventListener(MouseEvent.CLICK, __hzHandler);
		ui.lsBtn.addEventListener(MouseEvent.CLICK, __lsHandler);
		ui.manageUser.addEventListener(MouseEvent.CLICK, __userHandler);
		ui.manageGoods.addEventListener(MouseEvent.CLICK, __goodsHandler);
	}

	override public function listNotificationInterests() : Array {
		return [
			INIT
			];
	}

	override public function handleNotification(notification : INotification) : void {
		switch (notification.getName()) {
			case INIT:
				ui.init();
				
				break;
		}
	}

	private function __cpHandler(e : MouseEvent) : void {
		sendNotification(GoodsMediator.SHOW);
	}

	private function __hzHandler(e : MouseEvent) : void {
		sendNotification(GatherMediator.SHOW);
	}

	private function __lsHandler(e : MouseEvent) : void {
	}

	private function __userHandler(e : MouseEvent) : void {
		sendNotification(ManageUserMediator.SHOW);
	}

	private function __goodsHandler(e : MouseEvent) : void {
		sendNotification(ManageGoodsMediator.SHOW);
	}

	public function get ui() : LeftUI {
		return viewComponent as LeftUI;
	}
}
}
