package com.xy.view {
import com.xy.cmd.user.AddNewUserCmd;
import com.xy.cmd.user.QueryUsersCmd;
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.enum.AccountType;
import com.xy.model.enum.InvoicingDataNotice;
import com.xy.model.vo.ResultVo;
import com.xy.view.events.AccountUIEvent;
import com.xy.view.events.AddAccountPanelEvent;
import com.xy.view.ui.AccountUI;
import com.xy.view.ui.ProgressUI;
import com.xy.view.ui.panels.AddAccountPanel;

import mx.managers.PopUpManager;

/**
 * 账户
 * @author xy
 */
public class AccountMediator extends AbsMediator {
    public static const NAME : String = "AccountMediator";

    public static const SHOW : String = NAME + "SHOW";

    public static const ADD_RESULT : String = NAME + "ADD_RESULT";

    private var _panel : AccountUI;

    private var _addPanel : AddAccountPanel;

    public function AccountMediator(root : InvoicingSystem) {
        super(NAME, root);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(SHOW, show);
        map.put(ADD_RESULT, addResult);
        map.put(InvoicingDataNotice.USER_LIST_UPDATE, userListUpdate);
        return map;
    }

    private function show() : void {
        if (_panel == null) {
            _panel = new AccountUI();
            _panel.addEventListener(AccountUIEvent.SHOW_ADD_USER, __showAddPanelHandler);
            _panel.addEventListener(AccountUIEvent.SHOW_MODIDY_PWD, __showModifyPanelHandler);
        }
		var canShowMore : Boolean = dataProxy.type <= AccountType.SECOND_ADMIN;

        ui.setContent(_panel);
		
		_panel.contents.visible = canShowMore;
		_panel.addBtn.visible = canShowMore;

        if (dataProxy.users == null && canShowMore) {
            ProgressUI.show();
            sendNotification(QueryUsersCmd.NAME);
            return;
        }
    }

    private function addResult(vo : ResultVo) : void {
        if (vo.status) {
            PopUpManager.removePopUp(_addPanel);
        } else {
            _addPanel.addResult(vo);
        }
    }

    private function userListUpdate() : void {
        if (_panel != null) {
            _panel.updateData(dataProxy.users);
        }
    }

    private function __showAddPanelHandler(e : AccountUIEvent) : void {
        if (_addPanel == null) {
            _addPanel = new AddAccountPanel();
            _addPanel.addEventListener(AddAccountPanelEvent.ADD_USER, __addHandler);
        }

        PopUpManager.addPopUp(_addPanel, ui, true);
        PopUpManager.centerPopUp(_addPanel);
        _addPanel.initShow(dataProxy.getAccountTypes());
    }

    private function __addHandler(e : AddAccountPanelEvent) : void {
        sendNotification(AddNewUserCmd.NAME, e.vo);
    }

    private function __showModifyPanelHandler(e : AccountUIEvent) : void {

    }

    public function get ui() : InvoicingSystem {
        return viewComponent as InvoicingSystem;
    }
}
}
