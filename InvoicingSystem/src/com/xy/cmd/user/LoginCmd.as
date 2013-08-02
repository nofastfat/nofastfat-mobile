package com.xy.cmd.user {
import com.adobe.crypto.MD5;
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.ResultVo;
import com.xy.util.Http;
import com.xy.view.LoginUIMediator;
import com.xy.view.WelcomeMediator;

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
		_pwd = MD5.hash(_pwd);

        var url : String = Config.makeLoginUrl(_uid, _pwd);
        new Http(url, loginRs);
    }

    private function loginRs(data : String) : void {
        var vo : ResultVo = ResultVo.fromString(data);

        /* 记录数据 */
        if (vo.status) {
            dataProxy.loginComplete(_uid, _pwd, int(vo.data));
        }

        /* UI显示 */
        sendNotification(LoginUIMediator.LOGIN_RESULT, vo);
		
		/* 欢迎界面 */
		if(vo.status){
			sendNotification(WelcomeMediator.SHOW);
		}
    }
}
}
