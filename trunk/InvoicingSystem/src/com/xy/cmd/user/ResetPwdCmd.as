package com.xy.cmd.user {
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.AccountVo;
import com.xy.model.vo.ResultVo;
import com.xy.util.Http;
import com.xy.view.ui.MessageUI;

import org.puremvc.as3.interfaces.INotification;

public class ResetPwdCmd extends AbsCommand {
	/**
	 * 重置密码
	 * vo : AccountVo
	 */
	public static const NAME : String = "ResetPwdCmd";
	
	private var _vo : AccountVo;
	
	public function ResetPwdCmd() {
		super();
	}
	
	override public function execute(notification : INotification) : void {
		_vo = notification.getBody() as AccountVo;
		var url : String = Config.makeResetPwdUrl(_vo);
		new Http(url, modifyRs);
	}
	
	private function modifyRs(data : String) : void {
		var vo : ResultVo = ResultVo.fromString(data);
		
		MessageUI.getInstance().showMessage(vo.data);
	}
}
}
