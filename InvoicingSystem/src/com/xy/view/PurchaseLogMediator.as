package com.xy.view {
import com.xy.cmd.store.QueryPurchaseLogCmd;
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.Purview;
import com.xy.model.enum.InvoicingDataNotice;
import com.xy.view.ui.ProgressUI;
import com.xy.view.ui.StorgeUI;
import com.xy.view.ui.panels.PurchaseLogUI;
import com.xy.view.ui.panels.SoldLogUI;

public class PurchaseLogMediator extends AbsMediator {
    public static const NAME : String = "PurchaseLogMediator";
    /**
     * ui:StorgeUI
     */
    public static const SHOW : String = NAME + "SHOW";

    private var _panel : PurchaseLogUI;

    public function PurchaseLogMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(SHOW, show);
        map.put(InvoicingDataNotice.PURCHASE_LOG_UPDATE, soldLogUpdate);
        return map;
    }

    private function show(parent : StorgeUI) : void {
        if (_panel == null) {
            _panel = new PurchaseLogUI();
        }

        parent.setContent(_panel);

        if (dataProxy.purchaseLogs == null) {
            ProgressUI.show();
            sendNotification(QueryPurchaseLogCmd.NAME);
        } else {
            _panel.setData(dataProxy.purchaseLogs, Purview.canSeeRetailPrice(dataProxy.type));
        }
    }

    private function soldLogUpdate() : void {
        _panel.setData(dataProxy.purchaseLogs, Purview.canSeeRetailPrice(dataProxy.type));
    }

}
}
