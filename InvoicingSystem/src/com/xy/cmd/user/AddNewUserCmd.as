package com.xy.cmd.user {
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.AccountVo;
import com.xy.model.vo.ResultVo;
import com.xy.util.Http;
import com.xy.view.AccountMediator;
import com.xy.view.ui.MessageUI;
import com.xy.view.ui.panels.AddAccountPanel;

import org.puremvc.as3.interfaces.INotification;

public class AddNewUserCmd extends AbsCommand {
	
	/**
	 * 添加账户
	 * vo:GoodsVo
	 */
	public static const NAME : String = "AddNewUserCmd";
	
	private var _vo : AccountVo;
	
	public function AddNewUserCmd() {
		super();
	}
	
	override public function execute(notification : INotification) : void {
		_vo = notification.getBody() as AccountVo;
		
		var url : String = Config.makeAddUserUrl(_vo);
		new Http(url, addRs);
	}
	
	private function addRs(data : String) : void {
		var vo : ResultVo = ResultVo.fromString(data);
		
		/* 记录数据 */
		if (vo.status) {
			
			dataProxy.addUser(_vo);
		}
		
		MessageUI.getInstance().showMessage(vo.data as String);
		
		/* UI显示 */
		sendNotification(AccountMediator.ADD_RESULT, vo);
	}
}
}
