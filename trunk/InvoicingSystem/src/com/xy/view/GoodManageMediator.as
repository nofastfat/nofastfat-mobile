package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.view.ui.panels.GoodsManageUI;

import mx.managers.PopUpManager;

public class GoodManageMediator extends AbsMediator {
    public static const NAME : String = "GoodManageMediator";
	public static const SHOW : String = NAME + "SHOW";
	
    private var _panel : GoodsManageUI;

    public function GoodManageMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(SHOW, show);
        return map;
    }

    private function show() : void {
        if (_panel == null) {
            _panel = new GoodsManageUI();
        }
        PopUpManager.addPopUp(_panel, ui, true);
		PopUpManager.centerPopUp(_panel);

    }

    public function get ui() : InvoicingSystem {
        return viewComponent as InvoicingSystem;
    }
}
}
