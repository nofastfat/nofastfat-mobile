package com.xy.cmd.courier {
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.CourierVo;
import com.xy.model.vo.ResultVo;
import com.xy.util.Http;
import com.xy.view.CourierMediator;
import com.xy.view.ui.MessageUI;
import com.xy.view.ui.ProgressUI;

import org.puremvc.as3.interfaces.INotification;

public class ModifyCourierCmd extends AbsCommand {
    
    /**
     * 修改商品
     * vo : GoodsVo
     */
    public static const NAME : String = "ModifyCourierCmd";

    private var _vo : CourierVo;

    public function ModifyCourierCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
        _vo = notification.getBody() as CourierVo;
        var url : String = Config.makeModifyCourierUrl(_vo);
        new Http(url, modifyRs);
    }

    private function modifyRs(data : String) : void {
        var vo : ResultVo = ResultVo.fromString(data);

        /* 记录数据 */
        if (vo.status) {
            dataProxy.updateCourier(_vo);
            MessageUI.getInstance().showMessage(vo.data);
        }
		sendNotification(CourierMediator.ADD_RESULT, vo);
        ProgressUI.hide();
    }

}
}
