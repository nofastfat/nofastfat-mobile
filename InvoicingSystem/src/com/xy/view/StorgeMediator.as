package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.view.events.StorgeUIEvent;
import com.xy.view.ui.StorgeUI;

import flash.events.Event;

/**
 * 库存
 * @author xy
 */
public class StorgeMediator extends AbsMediator {
    public static const NAME : String = "StorgeMediator";

    public static const SHOW : String = NAME + "SHOW";

    private var _panel : StorgeUI;

    public function StorgeMediator(root : InvoicingSystem) {
        super(NAME, root);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(SHOW, show);
        return map;
    }

    private function show() : void {
        if (_panel == null) {
            _panel = new StorgeUI();
			_panel.addEventListener(StorgeUIEvent.SHOW_STORE_SEARCH, __showStoreSearchHandler);
			_panel.addEventListener(StorgeUIEvent.SHOW_COURIER_MANAGE, __showCourierHandler);
            _panel.addEventListener(StorgeUIEvent.SHOW_GOODS_MANAGE, __showGoodsManageHandler);
            _panel.addEventListener(StorgeUIEvent.SHOW_IN_GOODS_LOG, __showInGoodsHandler);
            _panel.addEventListener(StorgeUIEvent.SHOW_OUT_GOODS_LOG, __showOutGoodsHandler);
        }
        ui.setContent(_panel);

    }

	private function __showStoreSearchHandler(e : Event):void{
		
		sendNotification(StoreListMediator.SHOW, _panel);
	}
	
    private function __showCourierHandler(e : Event) : void {
        sendNotification(CourierMediator.SHOW, _panel);
    }

    private function __showGoodsManageHandler(e : Event) : void {
        sendNotification(GoodManageMediator.SHOW, _panel);
    }

    private function __showInGoodsHandler(e : Event) : void {
    	sendNotification(PurchaseLogMediator.SHOW, _panel);
    }

    private function __showOutGoodsHandler(e : Event) : void {
    	sendNotification(SoldLogMediator.SHOW, _panel);
    }

    public function get ui() : InvoicingSystem {
        return viewComponent as InvoicingSystem;
    }
}
}
