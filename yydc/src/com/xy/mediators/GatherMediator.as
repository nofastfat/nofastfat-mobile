package com.xy.mediators {
import com.xy.comunication.Protocal;
import com.xy.comunication.SAMFHttp;
import com.xy.model.DishDTO;
import com.xy.model.Global;
import com.xy.model.ReservationDetailDTO;
import com.xy.model.RestaurantDTO;
import com.xy.ui.views.Gather;
import com.xy.util.STool;

import flash.utils.Dictionary;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;

import spark.components.Group;


/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-18 下午6:15:29
 **/
public class GatherMediator extends Mediator {
	public static const NAME : String = "GatherMediator";
	
	public static const SHOW : String = NAME + "SHOW";
	
	private var _gatherUIs : Array = [];
	
	private var _orders : Dictionary = new Dictionary();
	
	public function GatherMediator(viewComponent : Object = null) {
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
		new SAMFHttp(Protocal.ADMIN_RESERVATION_REPORT, function(rs : Array):void{
			_orders = new Dictionary();
			
			//TODO ReservationDetailDTO少了备注
			for each(var dto : ReservationDetailDTO in rs[1]){
				var shop : RestaurantDTO = getShopByDish(dto.dishDTO);
				if(shop != null){
					if(!_orders.hasOwnProperty(shop.id)){
						_orders[shop.id] = {
							shop:shop,
							goods:new Dictionary()
						};
					}
					
					if(!_orders[shop.id].goods.hasOwnProperty(dto.dishDTO.id)){
						_orders[shop.id].goods[dto.dishDTO.id] = {
							goods:dto.dishDTO,
							users:[]
						};
					}
					_orders[shop.id].goods[dto.dishDTO.id].users.push(dto.userDTO.name);
					
				}
			}
			updateShow();
		});
	}
	
	private function getShopByDish(dishDto : DishDTO) : RestaurantDTO{
		for each(var dto : RestaurantDTO in Global.shops){
			for each(var dd : DishDTO in dto.dishDTOs){
				if(dd.id == dishDto.id){
					return dto;
				}
			}
		}
		
		return null;
	}
	
	private function updateShow():void{
		container.removeAllElements();
		
		var i : int = 0;
		for(var key :String in _orders){
			var ga : Gather;
			
			if(i < _gatherUIs.length){
				ga = _gatherUIs[i];
			}else{
				ga = new Gather();
				ga.initialize();
				_gatherUIs.push(ga);
			}
			ga.setData(_orders[key]);
			container.addElement(ga);
			i++;
		}
		
		if(ga != null){
			ga.callLater(function():void{
				var offsetY : int = 10;
				for(var j : int = 0 ;j < i; j++){
					var ga : Gather;
					
					ga = _gatherUIs[j];
					ga.y = offsetY;
					ga.x = 10;
					offsetY += ga.height + 10;
				}
				Global.root.callLayer(offsetY);
			});
		}
	}
	
	public function get container():Group{
		return viewComponent as Group;
	}
}
}
