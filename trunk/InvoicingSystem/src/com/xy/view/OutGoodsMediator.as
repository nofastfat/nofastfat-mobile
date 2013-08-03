package com.xy.view {
import com.xy.cmd.courier.AddCourierCmd;
import com.xy.cmd.courier.QueryCourierCmd;
import com.xy.cmd.store.QueryStoreCmd;
import com.xy.cmd.store.SoldCmd;
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.enum.InvoicingDataNotice;
import com.xy.model.vo.ResultVo;
import com.xy.view.events.AddFromStorePanelEvent;
import com.xy.view.events.CourierPanelEvent;
import com.xy.view.events.OutGoodUIEvent;
import com.xy.view.ui.OutGoodUI;
import com.xy.view.ui.ProgressUI;
import com.xy.view.ui.panels.AddFromStorePanel;
import com.xy.view.ui.panels.CourierPanel;

import flash.events.Event;

import mx.managers.PopUpManager;

/**
 * 出货
 * @author xy
 */
public class OutGoodsMediator extends AbsMediator {
    public static const NAME : String = "OutGoodsMediator";

    public static const SHOW : String = NAME + "SHOW";

    /**
     * vo:ResultVo
     */
    public static const ADD_RESULT : String = CourierMediator.NAME + "ADD_RESULT";

    private var _panel : OutGoodUI;

    private var _addFtomStorePanel : AddFromStorePanel;

    private var _addCourierPanel : CourierPanel;

    public function OutGoodsMediator(root : InvoicingSystem) {
        super(NAME, root);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(SHOW, show);
        map.put(ADD_RESULT, addResult);
        map.put(InvoicingDataNotice.COURIER_LIST_UPDATE, courierListUpdate);
        map.put(InvoicingDataNotice.STORE_LIST_UPDATE, storeListUpdate);
        return map;
    }

    private function show() : void {
        if (_panel == null) {
            _panel = new OutGoodUI();
            _panel.addEventListener(OutGoodUIEvent.SHOW_CHOOSE_STROE_PANEL, __showAddPanelHandler);
            _panel.addEventListener(OutGoodUIEvent.SHOW_ADD_COURIER_PANEL, __showAddCourierHandler);
            _panel.addEventListener(OutGoodUIEvent.SUBMIT, __submitHandler);
        }
        ui.setContent(_panel);
        if (dataProxy.couriers == null) {
            ProgressUI.show();
            sendNotification(QueryCourierCmd.NAME);
        } else {
            _panel.initShow(dataProxy.couriers);
        }
    }

    private function addResult(vo : ResultVo) : void {
        if (_addCourierPanel != null) {
            if (vo.status) {
                PopUpManager.removePopUp(_addCourierPanel);
            } else {
                _addCourierPanel.setShowType(_addCourierPanel.isCreate, _addCourierPanel.initData);
                _addCourierPanel.msgTf.text = vo.data;
            }
        }
    }

    private function courierListUpdate(... rest) : void {
        if (_panel != null) {
            _panel.initShow(dataProxy.couriers);
        }
    }

    private function storeListUpdate(... rest) : void {
        if (_addFtomStorePanel != null && _addFtomStorePanel.stage != null) {
            _addFtomStorePanel.initShow(dataProxy.stores);
        }
    }

    private function __showAddPanelHandler(e : Event) : void {
        if (_addFtomStorePanel == null) {
            _addFtomStorePanel = new AddFromStorePanel();
            _addFtomStorePanel.addEventListener(AddFromStorePanelEvent.SUBMIT, __addStoreSubmitHandler);
        }
        PopUpManager.addPopUp(_addFtomStorePanel, ui, true);
        PopUpManager.centerPopUp(_addFtomStorePanel);

        if (dataProxy.stores == null) {
            ProgressUI.show();
            sendNotification(QueryStoreCmd.NAME);
        } else {
            _addFtomStorePanel.initShow(dataProxy.stores);
        }
    }

    private function __showAddCourierHandler(e : Event) : void {
        if (_addCourierPanel == null) {
            _addCourierPanel = new CourierPanel();
            _addCourierPanel.addEventListener(CourierPanelEvent.ADD_SUBMIT, __addCourierHander);
        }
        PopUpManager.addPopUp(_addCourierPanel, ui, true);
        PopUpManager.centerPopUp(_addCourierPanel);
        _addCourierPanel.setShowType(true);
    }
    
    private function __submitHandler(e : OutGoodUIEvent):void{
    	sendNotification(SoldCmd.NAME, e.vo);
    }

    private function __addCourierHander(e : CourierPanelEvent) : void {
        sendNotification(AddCourierCmd.NAME, e.vo);
    }

    private function __addStoreSubmitHandler(e : AddFromStorePanelEvent) : void {
        _panel.setSelectedStores(e.arr);
    }

    public function get ui() : InvoicingSystem {
        return viewComponent as InvoicingSystem;
    }
}
}
