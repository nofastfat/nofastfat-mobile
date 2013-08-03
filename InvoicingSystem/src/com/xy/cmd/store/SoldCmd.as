package com.xy.cmd.store {
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.ResultVo;
import com.xy.model.vo.SoldVo;
import com.xy.util.Http;
import com.xy.view.OutGoodsMediator;
import com.xy.view.ui.ProgressUI;

import mx.controls.Alert;

import org.puremvc.as3.interfaces.INotification;

public class SoldCmd extends AbsCommand {

    /**
     * 入库
     * vo:StoreVo
     */
    public static const NAME : String = "SoldCmd";

    private var _vo : SoldVo;

    public function SoldCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
        _vo = notification.getBody() as SoldVo;

        var url : String = Config.makeSoldUrl(_vo);
        new Http(url, addRs);
    }

    private function addRs(data : String) : void {
        var vo : ResultVo = ResultVo.fromString(data);

        /* 记录数据 */
        if (vo.status) {
            dataProxy.clearStore();
        	sendNotification(OutGoodsMediator.SHOW);
        	dataProxy.clearSoldLog();
        }
        Alert.show(vo.data);
		ProgressUI.hide();
    }

}
}
