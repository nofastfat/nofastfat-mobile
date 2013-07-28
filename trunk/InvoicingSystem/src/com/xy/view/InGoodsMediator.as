package com.xy.view {
import com.xy.cmd.commodity.AddCommodityCmd;
import com.xy.cmd.commodity.QueryCommodityCmd;
import com.xy.cmd.store.PurchaseCmd;
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.enum.InvoicingDataNotice;
import com.xy.model.vo.ResultVo;
import com.xy.view.events.InGoodsUIEvent;
import com.xy.view.ui.InGoodsUI;
import com.xy.view.ui.ProgressUI;

/**
 * 进货
 * @author xy
 */
public class InGoodsMediator extends AbsMediator {
    public static const NAME : String = "InGoodsMediator";

    public static const SHOW : String = NAME + "SHOW";
    public static const ADD_RESULT : String = NAME + "ADD_RESULT";

    private var _panel : InGoodsUI;

    public function InGoodsMediator(root : InvoicingSystem) {
        super(NAME, root);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(SHOW, show);
        map.put(ADD_RESULT, addResult);
        map.put(InvoicingDataNotice.GOODS_LIST_UPDATE, goodsListUpdate);
        map.put(GoodManageMediator.ADD_RESULT, addGoodsResult);

        return map;
    }

    private function show() : void {
        if (_panel == null) {
            _panel = new InGoodsUI();
            _panel.addEventListener(InGoodsUIEvent.ADD_GOODS, __addGoodsHandler);
            _panel.addEventListener(InGoodsUIEvent.ADD_STORE, __addStoreHandler);
        }
        ui.setContent(_panel);

        if (dataProxy.goods == null) {
            ProgressUI.show();
            sendNotification(QueryCommodityCmd.NAME);
            return;
        }
        _panel.initShow(dataProxy.goods, dataProxy.getGoodsTypes());

    }
    
    private function addResult(vo : ResultVo):void{
    	_panel.addStoreResult(vo);
    }

    private function __addGoodsHandler(e : InGoodsUIEvent) : void {
        sendNotification(AddCommodityCmd.NAME, e.goods);
    }

    private function __addStoreHandler(e : InGoodsUIEvent) : void {
        sendNotification(PurchaseCmd.NAME, e.store);
    }

    private function goodsListUpdate(id : int = -1) : void {
        if (_panel != null && _panel.stage != null) {
            _panel.initShow(dataProxy.goods, dataProxy.getGoodsTypes(), id);
        }
    }

    private function addGoodsResult(vo : ResultVo) : void {
        if (_panel != null && _panel.stage != null) {
            _panel.addGoodsResult(vo);
        }
    }

    public function get ui() : InvoicingSystem {
        return viewComponent as InvoicingSystem;
    }
}
}
