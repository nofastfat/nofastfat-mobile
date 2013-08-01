package com.xy.cmd.user {
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.ResultVo;
import com.xy.util.Http;
import com.xy.view.ui.MessageUI;
import com.xy.view.ui.ProgressUI;

import org.puremvc.as3.interfaces.INotification;

public class QueryUsersCmd extends AbsCommand {
    /**
     * 查询商品
     */
    public static const NAME : String = "QueryUsersCmd";

    public function QueryUsersCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
        var url : String = Config.makeQueryUserUrl();
        new Http(url, queryRs);
    }

    private function queryRs(data : String) : void {
        var vo : ResultVo = ResultVo.fromString(data);

        /* 记录数据 */
        if (vo.status) {
            dataProxy.initUsers(vo.data);
        } else {
            MessageUI.getInstance().showMessage(vo.data);
        }
        ProgressUI.hide();
    }
}
}
