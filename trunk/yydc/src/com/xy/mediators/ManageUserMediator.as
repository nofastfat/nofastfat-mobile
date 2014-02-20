package com.xy.mediators {
import com.xy.comunication.Protocal;
import com.xy.comunication.SAMFHttp;
import com.xy.model.Global;
import com.xy.model.UserDTO;
import com.xy.ui.views.admin.AddUser;
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
 * 创建时间：2014-2-19 下午6:08:32
 **/
public class ManageUserMediator extends Mediator {
	public static const NAME : String = "ManageUserMediator";
	public static const SHOW : String = NAME + "SHOW";

	private var _ui : AdminUsers;

	public function ManageUserMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}


	override public function listNotificationInterests() : Array {
		return [
			SHOW,
			Global.EVENT_USER_UPDATE
			];
	}

	override public function handleNotification(notification : INotification) : void {
		switch (notification.getName()) {
			case SHOW:
				show();
				break;
			
			case Global.EVENT_USER_UPDATE:
				if(_ui != null && _ui.stage != null){
					_ui.setData(Global.users);
				}
				break;
		}
	}

	private function show() : void {
		if(_ui == null){
			_ui = new AdminUsers();
			_ui.initialize();
			_ui.addUsers.addEventListener(MouseEvent.CLICK, __addUserHandler);
		}
		
		container.removeAllElements();
		container.addElement(_ui);
		Global.refreshUserList();
	}

	private function __addUserHandler(e : MouseEvent):void{
		AddUser.getInstance().show(function(name : String, tel : String, sex:int):void{
			new SAMFHttp(Protocal.ADMIN_USER_ADD, function(rs:UserDTO):void{
				if(rs == null){
					Alert.show("网络异常，添加用户失败", "-_-#");
				}else{
					Alert.show(name +"已经成功添加！", "嘎嘎");
					Global.refreshUserList();
				}
			}, [name, tel, sex]);
		});
	}
	
	public function get container() : Group {
		return viewComponent as Group;
	}
}
}
