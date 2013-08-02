package com.xy.view {
import com.xy.cmd.courier.AddCourierCmd;
import com.xy.cmd.courier.DeleteCourierCmd;
import com.xy.cmd.courier.ModifyCourierCmd;
import com.xy.cmd.courier.QueryCourierCmd;
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.Purview;
import com.xy.model.enum.InvoicingDataNotice;
import com.xy.model.vo.ResultVo;
import com.xy.view.events.CourierUIEvent;
import com.xy.view.ui.ProgressUI;
import com.xy.view.ui.StorgeUI;
import com.xy.view.ui.panels.CourierUI;

public class CourierMediator extends AbsMediator {

    public static const NAME : String = "CourierMediator";

    /**
     * ui:StorgeUI
     */
    public static const SHOW : String = NAME + "SHOW";

    /**
     * vo:ResultVo
     */
    public static const ADD_RESULT : String = NAME + "ADD_RESULT";

    private var _panel : CourierUI;

    public function CourierMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(SHOW, show);
        map.put(ADD_RESULT, addResult);
        map.put(InvoicingDataNotice.COURIER_LIST_UPDATE, courierListUpdate);
        return map;
    }

    private function show(parent : StorgeUI) : void {
        if (_panel == null) {
            _panel = new CourierUI();
            _panel.addEventListener(CourierUIEvent.ADD_COURIER, __addCourierHandler);
            _panel.addEventListener(CourierUIEvent.QUERY, __queryHandler);
            _panel.addEventListener(CourierUIEvent.DELETE_COURIER, __deleteHandler);
            _panel.addEventListener(CourierUIEvent.MODIFY_COURIER, __modifyHandler);
        }
        parent.setContent(_panel);

        if (dataProxy.couriers == null) {
            ProgressUI.show();
            __queryHandler(null);
        }
    }

    private function __addCourierHandler(e : CourierUIEvent) : void {
        sendNotification(AddCourierCmd.NAME, e.vo);
    }

    private function __queryHandler(e : CourierUIEvent) : void {
        sendNotification(QueryCourierCmd.NAME);
    }

    private function __deleteHandler(e : CourierUIEvent) : void {
        sendNotification(DeleteCourierCmd.NAME, e.vo);
    }

    private function __modifyHandler(e : CourierUIEvent) : void {
        sendNotification(ModifyCourierCmd.NAME, e.vo);
    }

    private function addResult(vo : ResultVo) : void {
        _panel.addResult(vo);
    }

    private function courierListUpdate(keyGoodsId : int = -1) : void {
        _panel.setDatas(dataProxy.couriers, Purview.canAddCourier(dataProxy.type), keyGoodsId);
    }

}
}
