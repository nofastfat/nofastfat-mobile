package com.xy.cmd {
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.ResultVo;
import com.xy.util.Http;
import com.xy.view.LoginUIMediator;

import org.puremvc.as3.interfaces.INotification;

/**
 * 登录
 * @author xy
 */
public class LoginCmd extends AbsCommand {
    /**
     * [id:String, pwd:String]
     */
    public static const NAME : String = "LoginCmd";


    private var _uid : String;
    private var _pwd : String;

    public function LoginCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
        _uid = notification.getBody()[0];
        _pwd = notification.getBody()[1];

        var url : String = Config.makeLoginUrl(_uid, _pwd);
        new Http(url, loginRs);
    }

    private function loginRs(data : String) : void {
        var vo : ResultVo = ResultVo.fromString(data);

        /* 记录数据 */
        if (vo.status) {
            dataProxy.loginComplete(_uid, _pwd);
        }

        /* UI显示 */
        sendNotification(LoginUIMediator.LOGIN_RESULT, vo);
    }
}
}
