package com.xy.view {
import com.xy.cmd.store.QuerySoldLogCmd;
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.Purview;
import com.xy.model.enum.InvoicingDataNotice;
import com.xy.view.ui.ProgressUI;
import com.xy.view.ui.StorgeUI;
import com.xy.view.ui.panels.SoldLogUI;

public class SoldLogMediator extends AbsMediator {
    public static const NAME : String = "SoldLogMediator";
    /**
     * ui:StorgeUI
     */
    public static const SHOW : String = NAME + "SHOW";

    private var _panel : SoldLogUI;

    public function SoldLogMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(SHOW, show);
        map.put(InvoicingDataNotice.SOLD_LOG_UPDATE, soldLogUpdate);
        return map;
    }

    private function show(parent : StorgeUI) : void {
        if (_panel == null) {
            _panel = new SoldLogUI();
        }

        parent.setContent(_panel);

        if (dataProxy.soldLogs == null) {
            ProgressUI.show();
            sendNotification(QuerySoldLogCmd.NAME);
        } else {
            _panel.setData(dataProxy.soldLogs, Purview.canSeeRetailPrice(dataProxy.type));
        }
    }

    private function soldLogUpdate() : void {
        _panel.setData(dataProxy.soldLogs, Purview.canSeeRetailPrice(dataProxy.type));
    }

}
}
