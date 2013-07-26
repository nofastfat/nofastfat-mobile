package com.xy.cmd {
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.GoodsVo;
import com.xy.model.vo.ResultVo;
import com.xy.util.Http;
import com.xy.view.GoodManageMediator;
import com.xy.view.ui.MessageUI;
import com.xy.view.ui.ProgressUI;

import org.puremvc.as3.interfaces.INotification;

public class ModifyCommodityCmd extends AbsCommand {

    /**
     * 修改商品
     * vo : GoodsVo
     */
    public static const NAME : String = "ModifyCommodityCmd";

    private var _vo : GoodsVo;

    public function ModifyCommodityCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
        _vo = notification.getBody() as GoodsVo;
        var url : String = Config.makeModifyCommodityUrl(_vo);
        new Http(url, modifyRs);
    }

    private function modifyRs(data : String) : void {
        var vo : ResultVo = ResultVo.fromString(data);

        /* 记录数据 */
        if (vo.status) {
            dataProxy.updateGoods(_vo);
            MessageUI.getInstance().showMessage(vo.data);
        }
		sendNotification(GoodManageMediator.ADD_RESULT, vo);
        ProgressUI.hide();
    }
}
}
