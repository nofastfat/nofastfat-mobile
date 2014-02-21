package com.xy.mediators {
import com.greensock.TweenLite;
import com.greensock.TweenMax;
import com.xy.comunication.Protocal;
import com.xy.comunication.SAMFHttp;
import com.xy.model.Global;
import com.xy.model.UserDTO;
import com.xy.ui.views.LoginUI;
import com.xy.ui.views.PopUpManagerProxy;
import com.xy.ui.views.TopUI;
import com.xy.ui.views.admin.AddGoods;
import com.xy.ui.views.admin.AdminLoginUI;
import com.xy.util.AmfHttp;
import com.xy.util.Base64;

import flash.events.MouseEvent;
import flash.net.SharedObject;

import mx.controls.Alert;
import mx.managers.PopUpManager;
import mx.utils.Base64Encoder;
import mx.validators.Validator;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;


/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-18 下午3:29:45
 **/
public class LoginMediator extends Mediator {
	public static const NAME : String = "LoginMediator";

	public static const SHOW : String = NAME + "SHOW";

	private var _ui : LoginUI;

	private var _adminUI : AdminLoginUI;

	public function LoginMediator() {
		super(NAME);
	}

	override public function listNotificationInterests() : Array {
		return [SHOW];
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
			_ui = new LoginUI();
			_ui.initialize();
			_ui.loginBtn.addEventListener(MouseEvent.CLICK, __loginHandler);
			_ui.toAdminLogin.addEventListener(MouseEvent.CLICK, __toAdminLoginHandler);
		}

		if (_adminUI == null) {
			_adminUI = new AdminLoginUI();
			_adminUI.initialize();
			_adminUI.loginBtn.addEventListener(MouseEvent.CLICK, __adminLoginHandler);
			_adminUI.cancelBtn.addEventListener(MouseEvent.CLICK, __toNormalLoginHandler);
		}
		_ui.setOldList(getUserList());
		_ui.nameTf.selectedIndex = 0;
		
		_adminUI.idTf.text = getAdmin();

		if(Global.isAdmin){
			PopUpManagerProxy.addPopUp(_adminUI, Global.root);
			PopUpManager.centerPopUp(_adminUI);
		}else{
			PopUpManagerProxy.addPopUp(_ui, Global.root);
			PopUpManager.centerPopUp(_ui);
		}
	}

	private function getUserList() : Array {
		var so : SharedObject = SharedObject.getLocal("userNames");
		var arr : Array = so.data.records;
		if (arr == null) {
			arr = [];
		}
		arr = arr.reverse();
		return arr;
	}

	public function addUsers(uName : String) : void {
		var so : SharedObject = SharedObject.getLocal("userNames");
		if (so.data.records == null) {
			so.data.records = [];
		}
		if (so.data.records.indexOf(uName) != -1) {
			so.data.records.splice(so.data.records.indexOf(uName), 1);
		}
		so.data.records.push(uName);
		so.flush();
	}

	public function getAdmin() : String {
		var so : SharedObject = SharedObject.getLocal("userNames");
		var str : String = so.data.admin;
		if (str == null) {
			str = "";
		}
		return str;
	}

	public function recordAdmin(admin : String) : void {
		var so : SharedObject = SharedObject.getLocal("userNames");
		so.data.admin = admin;
		so.flush();
	}

	private function __loginHandler(e : MouseEvent) : void {
		if(_ui.nameTf.textInput.text == ""){
			return;
		}
		
		new SAMFHttp(Protocal.LOGIN, function(obj:UserDTO):void{
//			obj = new UserDTO();
//			obj.name="123";
			
			if(obj != null){
				Global.me = obj;
				Global.isAdmin = false;
				addUsers(Global.userName);
				
				PopUpManagerProxy.removePopUp(_ui); 
				
				sendNotification(TopMediator.INIT);
				sendNotification(LeftMediator.INIT);
				Global.root.container.removeAllElements();
				Global.refreshUserList();
				sendNotification(GoodsMediator.SHOW);
				
				if(!Global.isAdmin){
					Global.refreshMyGoods();
				}
			}else{
				Alert.show("登陆失败!\n1.检查哈子用户名有冒空格\n2.再检查哈子网络OK否", "Error");
			}
		}, [Global.base64(_ui.nameTf.textInput.text)]);
		
		//<mx:StringValidator id="nameVl" source="{nameTf}" required="true" requiredFieldError="姓名不能空" property="text" />
	}

	private function __adminLoginHandler(e : MouseEvent) : void {
		if(Validator.validateAll([_adminUI.nameVl, _adminUI.pwdVl]).length != 0){
			return;
		}
		
		if(_adminUI.idTf.text != "admin" || _adminUI.pwdTf.text != "admin"){
			Alert.show("管理员登陆失败!\n1.检查哈子用户名有冒空格\n2.再检查哈子网络OK否", "Error");
			return;
		}
		
		Global.me = new UserDTO();
		Global.me.name = _adminUI.idTf.text;
		Global.isAdmin = true;
		recordAdmin(Global.userName);
		
		Global.refreshShop();

		PopUpManagerProxy.removePopUp(_adminUI);
		sendNotification(TopMediator.INIT);
		sendNotification(LeftMediator.INIT);
		Global.root.container.removeAllElements();
	}

	private function __toAdminLoginHandler(e : MouseEvent) : void {
		TweenLite.to(_ui, 0.3, {overwrite: true, scaleX: 0, x: _ui.x + _ui.width / 2, onComplete: function() : void
		{
			PopUpManagerProxy.removePopUp(_ui);
			_ui.scaleX = 1;

			PopUpManagerProxy.addPopUp(_adminUI, Global.root);
			_adminUI.scaleX = 1;
			PopUpManager.centerPopUp(_adminUI);

			TweenLite.from(_adminUI, 0.3, {overwrite: true, scaleX: 0, x: _adminUI.x + _adminUI.width / 2});
		}});
	}



	private function __toNormalLoginHandler(e : MouseEvent) : void {
		TweenLite.to(_adminUI, 0.3, {overwrite: true, scaleX: 0, x: _adminUI.x + _adminUI.width / 2, onComplete: function() : void
		{
			PopUpManagerProxy.removePopUp(_adminUI);
			_adminUI.scaleX = 1;

			PopUpManagerProxy.addPopUp(_ui, Global.root);
			_ui.scaleX = 1;
			PopUpManager.centerPopUp(_ui);

			TweenLite.from(_ui, 0.3, {overwrite: true, scaleX: 0, x: _ui.x + _ui.width / 2});
		}});
	}

}
}
