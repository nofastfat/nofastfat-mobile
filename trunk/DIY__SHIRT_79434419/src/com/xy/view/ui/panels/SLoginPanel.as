package com.xy.view.ui.panels {
import com.adobe.crypto.MD5;
import com.adobe.utils.StringUtil;
import com.xy.model.URLConfig;
import com.xy.ui.BlueButton;
import com.xy.ui.LoginPanel;
import com.xy.util.STool;
import com.xy.util.Tools;
import com.xy.view.ui.events.SLoginPanelEvent;

import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;

public class SLoginPanel extends AbsPanel {
    private var _panel : LoginPanel;

    private var _loginBtn : BlueButton;
    private var _regBtn : BlueButton;

    public function SLoginPanel(w : int = 350, h : int = 200, title : String = "登录") {
        super(w, h, title);

        _panel = new LoginPanel();
        _loginBtn = Tools.makeBlueButton("登录");
        _regBtn = Tools.makeBlueButton("注册");

        container.addChild(_panel);
        container.addChild(_loginBtn);
        container.addChild(_regBtn);

        _loginBtn.y = _regBtn.y = _panel.height + 25;

        _loginBtn.x = 60;
        _regBtn.x = 160;
        
        _panel.error.text = "";

        _panel.regTf.htmlText = STool.makeLink2("立即注册", URLConfig.REGISTER_PAGE);
        _panel.losePwdTf.htmlText = STool.makeLink2("忘记密码?", URLConfig.FOGOT_PASSWORD);

        _loginBtn.addEventListener(MouseEvent.CLICK, __loginHandler);
        _regBtn.addEventListener(MouseEvent.CLICK, __regHandler);
    }

	public function setPwdNull():void{
		_panel.pwdTf.text = "";
		_panel.error.text = "";
	}

    private function __loginHandler(e : MouseEvent) : void {
    	var uName : String = _panel.nameTf.text;
    	uName = StringUtil.trim(uName);
    	
    	var pwd : String = _panel.pwdTf.text;
    	
    	if(uName.length == 0 || pwd.length == 0){
    		_panel.error.text = "帐号或者密码都不能为空";
    		return;
    	}else{
    		_panel.error.text = "";
    	}
    	
    	pwd = StringUtil.trim(pwd);
    	//pwd = MD5.hash(pwd);
    	
    	close();
    	
    	dispatchEvent(new SLoginPanelEvent(SLoginPanelEvent.LOGIN, uName, pwd));
    }

    private function __regHandler(e : MouseEvent) : void {
        navigateToURL(new URLRequest(URLConfig.REGISTER_PAGE), "_blank");
    }

}
}
