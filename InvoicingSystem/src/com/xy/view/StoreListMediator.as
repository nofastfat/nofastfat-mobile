package com.xy.view {
import com.xy.cmd.store.QueryStoreCmd;
import com.xy.cmd.user.QueryUsersCmd;
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.Purview;
import com.xy.model.enum.InvoicingDataNotice;
import com.xy.view.ui.ProgressUI;
import com.xy.view.ui.StorgeUI;
import com.xy.view.ui.panels.StoreListUI;

public class StoreListMediator extends AbsMediator {
    public static const NAME : String = "StoreListMediator";

    /**
     * ui:StorgeUI
     */
    public static const SHOW : String = NAME + "SHOW";

    private var _panel : StoreListUI;

    public function StoreListMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(SHOW, show);
        map.put(InvoicingDataNotice.STORE_LIST_UPDATE, storeListUpdate);
        return map;
    }

    private function show(parent : StorgeUI) : void {
        if (_panel == null) {
            _panel = new StoreListUI();
        }
        parent.setContent(_panel);

        if (dataProxy.stores == null) {
            ProgressUI.show();
            sendNotification(QueryStoreCmd.NAME);
        } else {
            _panel.setData(dataProxy.stores, Purview.canSeeRetailPrice(dataProxy.type));
        }
    }

    private function storeListUpdate(id : int = -1) : void {
        if (_panel != null) {
            _panel.setData(dataProxy.stores, Purview.canSeeRetailPrice(dataProxy.type));
        }
    }

    public function get ui() : InvoicingSystem {
        return viewComponent as InvoicingSystem;
    }
}
}
