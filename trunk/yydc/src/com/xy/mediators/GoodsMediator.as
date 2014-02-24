package com.xy.mediators {
import com.xy.model.Global;
import com.xy.model.RestaurantDTO;
import com.xy.ui.views.GoodsListUI;

import flash.events.Event;
import flash.utils.setTimeout;

import mx.containers.Canvas;

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
		container.stage.addEventListener(Event.RESIZE, __resizeHandler);
	}
	
	
	override public function listNotificationInterests():Array{
		return [
			SHOW,
			Global.EVENT_SHOP_UPDATE
		];
	}
	
	override public function handleNotification(notification:INotification):void{
		switch(notification.getName()){
			case SHOW:
				show();
				break;
			
			case Global.EVENT_SHOP_UPDATE:
				if(_ui != null && _ui.stage != null){
					
					var oldSelect : int = _ui.shops.selectedIndex;
					_ui.setShop(Global.shops);
					__changeShopHandler();
				}
				break;
		}
	}
	
	private function __resizeHandler(e : Event):void{
		if(_ui != null && _ui.stage != null){
			_ui.resized();
		}
	}
	
	private function show():void{
		if(_ui == null){
			_ui = new GoodsListUI();
			_ui.shops.addEventListener(IndexChangeEvent.CHANGE, __changeShopHandler);
		}
		
		container.removeAllElements();
		container.addElement(_ui);
		
		Global.refreshShop();
	}
	
	private function __changeShopHandler(e : IndexChangeEvent = null):void{
		var dto : RestaurantDTO = _ui.shops.selectedItem;
		if(dto != null){
			_ui.setGoods(dto.dishDTOs);
		}else{
			_ui.setGoods([]);
		}
	}
	
	public function get container():Canvas{
		return viewComponent as Canvas;
	}
}
}
