package com.xy.cmd.store {
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.ResultVo;
import com.xy.model.vo.StoreVo;
import com.xy.util.Http;
import com.xy.view.InGoodsMediator;
import com.xy.view.ui.ProgressUI;

import mx.controls.Alert;

import org.puremvc.as3.interfaces.INotification;

public class PurchaseCmd extends AbsCommand {

    /**
     * 入库
     * vo:StoreVo
     */
    public static const NAME : String = "PurchaseCmd";

    private var _vo : StoreVo;

    public function PurchaseCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
        _vo = notification.getBody() as StoreVo;

        var url : String = Config.makePurchaseUrl(_vo);
        new Http(url, addRs);
    }

    private function addRs(data : String) : void {
        var vo : ResultVo = ResultVo.fromString(data);

        /* 记录数据 */
        if (vo.status) {
            var newVo : StoreVo = StoreVo.fromStr(vo.data as String);
            if (newVo.name != _vo.name || newVo.madeTime != _vo.madeTime || newVo.num != _vo.num
                || newVo.retailPrice != _vo.retailPrice) {
                /* 如果是脏数据，就要清理 */
                dataProxy.clearStore();
                
				ProgressUI.show();
            } else {
                dataProxy.addStore(newVo);
            }
            Alert.show("入库成功");
            dataProxy.clearPurchaseLog();
        }

        /* UI显示 */
        sendNotification(InGoodsMediator.ADD_RESULT, vo);
    }

}
}
