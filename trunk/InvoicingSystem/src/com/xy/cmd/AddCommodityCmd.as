package com.xy.cmd {
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.GoodsVo;
import com.xy.model.vo.ResultVo;
import com.xy.util.Http;
import com.xy.view.GoodManageMediator;
import com.xy.view.ui.MessageUI;

import org.puremvc.as3.interfaces.INotification;

/**
 * 添加商品
 * @author xy
 */
public class AddCommodityCmd extends AbsCommand {

    /**
     * 添加商品
     * vo:GoodsVo
     */
    public static const NAME : String = "AddCommodityCmd";

    private var _vo : GoodsVo;

    public function AddCommodityCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
        _vo = notification.getBody() as GoodsVo;

        var url : String = Config.makeAddCommodityUrl(_vo);
        new Http(url, addRs);
    }

    private function addRs(data : String) : void {
        var vo : ResultVo = ResultVo.fromString(data);

        /* 记录数据 */
        if (vo.status) {
			_vo.id = int(vo.data);
            dataProxy.addGoods(_vo);
            MessageUI.getInstance().showMessage("商品添加成功");
        }

        /* UI显示 */
        sendNotification(GoodManageMediator.ADD_RESULT, vo);
    }
}
}
