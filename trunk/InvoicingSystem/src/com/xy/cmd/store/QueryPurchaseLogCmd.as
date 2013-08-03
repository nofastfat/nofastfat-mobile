package com.xy.cmd.store {
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.ResultVo;
import com.xy.util.Http;
import com.xy.view.ui.ProgressUI;

import org.puremvc.as3.interfaces.INotification;

public class QueryPurchaseLogCmd extends AbsCommand {
    
	public static const NAME : String = "QueryPurchaseLogCmd";
	
	public function QueryPurchaseLogCmd() {
		super();
	}
	
	override public function execute(notification : INotification) : void {
		var url : String = Config.makeQueryPurchaseLogUrl();
		new Http(url, addRs);
	}
	
	private function addRs(data : String) : void {
		var vo : ResultVo = ResultVo.fromString(data);
		
		/* 记录数据 */
		if (vo.status) {
			dataProxy.initPurchaseLog(vo.data);
		}
		
		ProgressUI.hide();
	}

}
}
