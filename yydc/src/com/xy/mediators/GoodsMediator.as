package com.xy.mediators {
import com.xy.ui.views.GoodsListUI;

import flash.utils.setTimeout;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;

import spark.components.Group;
import spark.events.IndexChangeEvent;


/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-18 下午4:07:42
 **/
public class GoodsMediator extends Mediator {
	public static const NAME : String = "GoodsMediator";
	public static const SHOW : String = NAME + "SHOW";
	
	private var _ui:GoodsListUI;
	
	public function GoodsMediator( viewComponent : Object = null) {
		super(NAME, viewComponent);
	}
	
	
	override public function listNotificationInterests():Array{
		return [
			SHOW
		];
	}
	
	override public function handleNotification(notification:INotification):void{
		switch(notification.getName()){
			case SHOW:
				show();
				break;
		}
	}
	
	private function show():void{
		if(_ui == null){
			_ui = new GoodsListUI();
			_ui.shops.addEventListener(IndexChangeEvent.CHANGE, __changeShopHandler);
		}
		
		var oldSelect : int = _ui.shops.selectedIndex;
		_ui.setShop(["小五", "老五"]);
		container.removeAllElements();
		container.addElement(_ui);
		
		if(oldSelect == -1){
			_ui.callLater(__changeShopHandler, null);
		}
	}
	
	private function __changeShopHandler(e : IndexChangeEvent = null):void{
		_ui.setGoods([]);
	}
	
	public function get container():Group{
		return viewComponent as Group;
	}
}
}
