package com.xy.view {
import com.xy.cmd.commodity.AddCommodityCmd;
import com.xy.cmd.commodity.DeleteCommodityCmd;
import com.xy.cmd.commodity.ModifyCommodityCmd;
import com.xy.cmd.commodity.QueryCommodityCmd;
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.enum.InvoicingDataNotice;
import com.xy.model.vo.ResultVo;
import com.xy.view.events.GoodsManageUIEvent;
import com.xy.view.ui.ProgressUI;
import com.xy.view.ui.StorgeUI;
import com.xy.view.ui.panels.GoodsManageUI;

public class GoodManageMediator extends AbsMediator {
    public static const NAME : String = "GoodManageMediator";

    /**
     * ui:StorgeUI
     */
    public static const SHOW : String = NAME + "SHOW";

    /**
     * vo:ResultVo
     */
    public static const ADD_RESULT : String = NAME + "ADD_RESULT";

    private var _panel : GoodsManageUI;

    public function GoodManageMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(SHOW, show);
        map.put(ADD_RESULT, addResult);
        map.put(InvoicingDataNotice.GOODS_LIST_UPDATE, goodsListUpdate);
        return map;
    }

    private function show(parent : StorgeUI) : void {
        if (_panel == null) {
            _panel = new GoodsManageUI();
            _panel.addEventListener(GoodsManageUIEvent.ADD_GOODS, __addGoodsHandler);
            _panel.addEventListener(GoodsManageUIEvent.QUERY, __queryHandler);
            _panel.addEventListener(GoodsManageUIEvent.DELETE_GOODS, __deleteHandler);
            _panel.addEventListener(GoodsManageUIEvent.MODIFY_GOODS, __modifyHandler);
        }
        parent.setContent(_panel);
        _panel.setDatas(dataProxy.goods, dataProxy.getGoodsTypes());

        if (dataProxy.goods == null) {
            ProgressUI.show();
            __queryHandler(null);
        }

    }

    private function __addGoodsHandler(e : GoodsManageUIEvent) : void {
        sendNotification(AddCommodityCmd.NAME, e.vo);
    }

    private function __queryHandler(e : GoodsManageUIEvent) : void {
        sendNotification(QueryCommodityCmd.NAME);
    }

    private function __deleteHandler(e : GoodsManageUIEvent) : void {
        sendNotification(DeleteCommodityCmd.NAME, e.vo);
    }

    private function __modifyHandler(e : GoodsManageUIEvent) : void {
        sendNotification(ModifyCommodityCmd.NAME, e.vo);
    }

    private function addResult(vo : ResultVo) : void {

        if (_panel != null && _panel.stage != null) {
            _panel.addResult(vo);
        }
    }

    private function goodsListUpdate(keyGoodsId : int = -1) : void {
        if (_panel != null && _panel.stage != null) {
            _panel.setDatas(dataProxy.goods, dataProxy.getGoodsTypes(), keyGoodsId);
        }
    }

    public function get ui() : InvoicingSystem {
        return viewComponent as InvoicingSystem;
    }
}
}
