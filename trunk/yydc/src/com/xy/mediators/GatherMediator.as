package com.xy.mediators {
import com.xy.comunication.Protocal;
import com.xy.comunication.SAMFHttp;
import com.xy.model.DishDTO;
import com.xy.model.Global;
import com.xy.model.ReservationDTO;
import com.xy.model.ReservationDetailDTO;
import com.xy.model.RestaurantDTO;
import com.xy.ui.views.Gather;
import com.xy.ui.views.NoneOrder;
import com.xy.ui.views.OrderCtrl;
import com.xy.util.STool;

import flash.events.MouseEvent;
import flash.utils.Dictionary;

import mx.containers.Canvas;
import mx.controls.Alert;

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

	private var _orderUI : OrderCtrl;
	private var _noneDian : NoneOrder;

	private var _orders : Dictionary = new Dictionary();
	
	private var _now : ReservationDTO;
	private var _dianList : Array = [];

	public function GatherMediator(viewComponent : Object = null) {
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
		if (_orderUI == null) {
			_orderUI = new OrderCtrl();
			_orderUI.lockBtn.addEventListener(MouseEvent.CLICK, __lockHandler);
		}
		
		if(_noneDian == null){
			_noneDian = new NoneOrder();
		}

		new SAMFHttp(Protocal.ADMIN_RESERVATION_REPORT, function(rs : Array) : void {
			if(rs == null){
				return;
			}
			_orders = new Dictionary();
			_now = rs[0];
			_dianList = rs[1];

			for each (var dto : ReservationDetailDTO in rs[1]) {
				var shop : RestaurantDTO = getShopByDish(dto.dishDTO);
				if (shop != null) {
					if (!_orders.hasOwnProperty(shop.id)) {
						_orders[shop.id] = {
								shop: shop,
								goods: new Dictionary(),
								infos: []
							};
					}

					if (!_orders[shop.id].goods.hasOwnProperty(dto.dishDTO.id)) {
						_orders[shop.id].goods[dto.dishDTO.id] = {
								goods: dto.dishDTO,
								users: []
							};
					}
					_orders[shop.id].goods[dto.dishDTO.id].users.push(dto.userDTO.name);
					if (dto.comment != "") {
						_orders[shop.id].infos.push(dto.dishDTO.name + "("+dto.userDTO.name+"):"+dto.comment);
					}

				}
			}
			updateShow();
		});
	}
	
	private function __lockHandler(e : MouseEvent):void{
		new SAMFHttp(Protocal.ADMIN_RESERVATION_COMMIT, function(rs :int):void{
			if(rs == 0){
				Alert.show("网络异常，锁定失败", "-_-#");
			}else{
				Alert.show("锁定成功", "嘎嘎");
			}
		},[_now.id]);
	}

	private function getShopByDish(dishDto : DishDTO) : RestaurantDTO {
		for each (var dto : RestaurantDTO in Global.shops) {
			for each (var dd : DishDTO in dto.dishDTOs) {
				if (dd.id == dishDto.id) {
					return dto;
				}
			}
		}

		return null;
	}

	private function updateShow() : void {
		container.removeAllElements();

		if (Global.isAdmin) {
			container.addElement(_orderUI);
			_orderUI.updateLeft(_dianList);
		}

		var i : int = 0;
		for (var key : String in _orders) {
			var ga : Gather;

			if (i < _gatherUIs.length) {
				ga = _gatherUIs[i];
			} else {
				ga = new Gather();
				ga.initialize();
				_gatherUIs.push(ga);
			}
			ga.setData(_orders[key]);
			container.addElement(ga);
			i++;
		}
		
		if(i == 0){
			container.addElement(_noneDian);
			
			if(_orderUI.stage != null && _orderUI.visible == true){
				_noneDian.y = _orderUI.height;
			}else{
				_noneDian.y = 0;
			}
		}

		if (ga != null) {
			ga.callLater(function() : void {

				var offsetY : int = 10;
				if (Global.isAdmin) {
					offsetY += _orderUI.height;
				}
				for (var j : int = 0; j < i; j++) {
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

	public function get container() : Canvas {
		return viewComponent as Canvas;
	}
}
}
