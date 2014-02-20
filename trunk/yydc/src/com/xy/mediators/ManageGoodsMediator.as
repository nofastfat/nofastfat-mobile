package com.xy.mediators {
import com.xy.comunication.Protocal;
import com.xy.comunication.SAMFHttp;
import com.xy.model.Global;
import com.xy.ui.views.admin.AddShop;
import com.xy.ui.views.admin.AdminGoods;
import com.xy.ui.views.admin.AdminUsers;

import flash.events.MouseEvent;

import mx.controls.Alert;

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
			SHOW,
			Global.EVENT_SHOP_UPDATE
			];
	}

	override public function handleNotification(notification : INotification) : void {
		switch (notification.getName()) {
			case SHOW:
				show();
				break;
			
			case Global.EVENT_SHOP_UPDATE:
				if(_ui != null && _ui.stage != null){
					_ui.setDatas(Global.shops);
				}
				break;
		}
	}

	private function show() : void {
		if (_ui == null) {
			_ui = new AdminGoods();
			_ui.initialize();
			_ui.addShopBtn.addEventListener(MouseEvent.CLICK, __addShopHandler);
		}
		Global.refreshShop();
		container.removeAllElements();
		container.addElement(_ui);
	}
	
	private function __addShopHandler(e : MouseEvent):void{
		AddShop.getInstance().show(function(name : String, tel : String, address:String):void{
			new SAMFHttp(Protocal.ADMIN_RESTAURANT_ADD, function(rs:int):void{
				  if(rs == 0){
					  Alert.show("网络异常，添加饭馆失败", "-_-#");
				  }else{
					  Alert.show("网络异常，添加饭馆成功", "嘎嘎");
					  Global.refreshShop();
				  }
			}, [name, tel, address]);
		});
	}

	public function get container() : Group {
		return viewComponent as Group;
	}
}
}
