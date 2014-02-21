package com.xy.mediators {
import com.xy.comunication.Protocal;
import com.xy.comunication.SAMFHttp;
import com.xy.model.Global;
import com.xy.ui.views.TopUI;

import flash.events.MouseEvent;

import mx.controls.Alert;

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
		ui.redng.addEventListener(MouseEvent.CLICK, __regHandler);
	}

	override public function listNotificationInterests():Array{
		return [
			INIT,
			Global.EVENT_MY_GOODS_UPDATE
		];
	}
	
	override public function handleNotification(notification:INotification):void{
		switch(notification.getName()){
			case INIT:
				init();
				break;
			
			case Global.EVENT_MY_GOODS_UPDATE:
				ui.setName(Global.userName);
				break;
		}
	}
	
	private function init():void{
		ui.setName(Global.userName);
	}
	
	private function __logoutHandler(e : MouseEvent):void{
		sendNotification(LoginMediator.SHOW);
	}
	
	private function __regHandler(e : MouseEvent):void{
		new SAMFHttp(Protocal.DETAIL_CANCEL, function(rs : int):void{
			if(rs == 0){
				Alert.show("不知道为虾米，退订失败鸟", "退订失败");
			}else{
				Alert.show("退订成功", "嘎嘎");
			}
			Global.refreshMyGoods();
		}, [Global.myGoods.reservationDTO.id]);
	}
	
	public function get ui() : TopUI {
		return viewComponent as TopUI;
	}
}
}
