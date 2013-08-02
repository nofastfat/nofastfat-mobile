package com.xy.cmd.user {
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.AccountVo;
import com.xy.model.vo.ResultVo;
import com.xy.util.Http;
import com.xy.view.ui.MessageUI;

import org.puremvc.as3.interfaces.INotification;

public class DeleteUserCmd extends AbsCommand {
	
	/**
	 * 修改商品
	 * vo : GoodsVo
	 */
	public static const NAME : String = "DeleteUserCmd";
	
	private var _vo : AccountVo;
	
	public function DeleteUserCmd() {
		super();
	}
	
	override public function execute(notification : INotification) : void {
		_vo = notification.getBody() as AccountVo;
		var url : String = Config.makeDeleteUserUrl(_vo);
		new Http(url, deleteRs);
	}
	
	private function deleteRs(data : String) : void {
		var vo : ResultVo = ResultVo.fromString(data);
		
		/* 记录数据 */
		if (vo.status) {
			dataProxy.deleteUser(_vo.id);
		}
		
		MessageUI.getInstance().showMessage(vo.data);
	}
}
}
