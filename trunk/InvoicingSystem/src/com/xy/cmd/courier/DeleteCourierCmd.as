package com.xy.cmd.courier {
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.CourierVo;
import com.xy.model.vo.ResultVo;
import com.xy.util.Http;
import com.xy.view.ui.MessageUI;

import org.puremvc.as3.interfaces.INotification;

public class DeleteCourierCmd extends AbsCommand {

    /**
     * 修改商品
     * vo : CourierVo
     */
    public static const NAME : String = "DeleteCourierCmd";

    private var _vo : CourierVo;

    public function DeleteCourierCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
        _vo = notification.getBody() as CourierVo;
        var url : String = Config.makeDeleteCourierUrl(_vo);
        new Http(url, deleteRs);
    }

    private function deleteRs(data : String) : void {
        var vo : ResultVo = ResultVo.fromString(data);

        /* 记录数据 */
        if (vo.status) {
            dataProxy.deleteCourier(_vo);
            MessageUI.getInstance().showMessage(vo.data);
        } else {
            MessageUI.getInstance().showMessage(vo.data);
        }
    }

}
}
