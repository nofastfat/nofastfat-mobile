package com.xy.cmd.user {
import com.adobe.crypto.MD5;
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.ResultVo;
import com.xy.util.Http;
import com.xy.view.AccountMediator;
import com.xy.view.ui.MessageUI;

import org.puremvc.as3.interfaces.INotification;

public class ChangePwdCmd extends AbsCommand {

    /**
     * 修改商品
     * vo : GoodsVo
     */
    public static const NAME : String = "ChangePwdCmd";

    private var _oldPwd : String;
	private var _newPwd : String;

    public function ChangePwdCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
		_oldPwd = notification.getBody()[0];
		_newPwd = notification.getBody()[1];
		
		_oldPwd = MD5.hash(_oldPwd);
		_newPwd = MD5.hash(_newPwd);
        var url : String = Config.makeModifyPwdUrl(_oldPwd, _newPwd);
        new Http(url, modifyRs);
    }

    private function modifyRs(data : String) : void {
        var vo : ResultVo = ResultVo.fromString(data);

        /* 记录数据 */
        if (vo.status) {
            dataProxy.changePwd(_newPwd);
        }
		MessageUI.getInstance().showMessage(vo.data);
		
        sendNotification(AccountMediator.MODIFY_RESULT, vo);
    }
}
}
