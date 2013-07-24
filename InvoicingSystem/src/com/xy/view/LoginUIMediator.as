package com.xy.view {
import com.xy.cmd.LoginCmd;
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.vo.ResultVo;
import com.xy.view.events.LoginUIEvent;
import com.xy.view.ui.LoginUI;

import flash.events.InvokeEvent;
import flash.events.MouseEvent;

import mx.managers.PopUpManager;

/**
 * 登录
 * @author xy
 */
public class LoginUIMediator extends AbsMediator {
    public static const NAME : String = "LoginUIMediator";

    /**
     * 显示登录面板
     */
    public static const SHOW_PANEL : String = NAME + "SHOW_PANEL";

    /**
     * 登录结果
     * vo:ResultVo
     */
    public static const LOGIN_RESULT : String = NAME + "LOGIN_RESULT";


    private var _panel : LoginUI;

    public function LoginUIMediator(root : InvoicingSystem) {
        super(NAME, root);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(SHOW_PANEL, showPanel);
        map.put(LOGIN_RESULT, loginResult);
        return map;
    }

    /**
     * 显示登录
     */
    private function showPanel() : void {
        if (_panel == null) {
            _panel = new LoginUI();
            _panel.addEventListener(LoginUIEvent.SUBMIT, __submitHandlder);
        }

        PopUpManager.addPopUp(_panel, ui, true);
        PopUpManager.centerPopUp(_panel);

        _panel.init();
    }

    private function loginResult(vo : ResultVo) : void {
        if (vo.status) {
            PopUpManager.removePopUp(_panel);
        } else {
            _panel.showFaild(vo.data as String);
        }
    }

    private function __submitHandlder(e : LoginUIEvent) : void {
        sendNotification(LoginCmd.NAME, [e.uName, e.uPwd]);
    }

    public function get ui() : InvoicingSystem {
        return viewComponent as InvoicingSystem;
    }
}
}
