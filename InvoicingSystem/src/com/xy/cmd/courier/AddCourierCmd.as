package com.xy.cmd.courier {
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.CourierVo;
import com.xy.model.vo.ResultVo;
import com.xy.util.Http;
import com.xy.view.CourierMediator;
import com.xy.view.ui.MessageUI;

import org.puremvc.as3.interfaces.INotification;

public class AddCourierCmd extends AbsCommand {
    
    /**
     * 添加商品
     * vo:GoodsVo
     */
    public static const NAME : String = "AddCourierCmd";

    private var _vo : CourierVo;

    public function AddCourierCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
        _vo = notification.getBody() as CourierVo;

        var url : String = Config.makeAddCourierUrl(_vo);
        new Http(url, addRs);
    }

    private function addRs(data : String) : void {
        var vo : ResultVo = ResultVo.fromString(data);

        /* 记录数据 */
        if (vo.status) {
			_vo.id = int(vo.data);
            dataProxy.addCourier(_vo);
            MessageUI.getInstance().showMessage("快递添加成功");
        }

        /* UI显示 */
        sendNotification(CourierMediator.ADD_RESULT, vo);
    }

}
}
