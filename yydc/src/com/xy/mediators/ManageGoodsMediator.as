package com.xy.mediators {
import com.xy.ui.views.admin.AddShop;
import com.xy.ui.views.admin.AdminGoods;
import com.xy.ui.views.admin.AdminUsers;

import flash.events.MouseEvent;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;

import spark.components.Group;


/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-19 下午6:08:51
 **/
public class ManageGoodsMediator extends Mediator {
	public static const NAME : String = "ManageGoodsMediator";
	public static const SHOW : String = NAME + "SHOW";

	private var _ui : AdminGoods;

	public function ManageGoodsMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}


	override public function listNotificationInterests() : Array {
		return [
			SHOW
			];
	}

	override public function handleNotification(notification : INotification) : void {
		switch (notification.getName()) {
			case SHOW:
				show();
				break;
		}
	}

	private function show() : void {
		if (_ui == null) {
			_ui = new AdminGoods();
			_ui.initialize();
			_ui.addShopBtn.addEventListener(MouseEvent.CLICK, __addShopHandler);
		}
		_ui.setDatas([]);
		container.removeAllElements();
		container.addElement(_ui);
	}
	
	private function __addShopHandler(e : MouseEvent):void{
		AddShop.getInstance().show(function(name : String, tel : String, address:String):void{
			
		});
	}

	public function get container() : Group {
		return viewComponent as Group;
	}
}
}
