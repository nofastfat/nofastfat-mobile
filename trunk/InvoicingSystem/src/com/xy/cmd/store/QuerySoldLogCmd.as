package com.xy.cmd.store {
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.ResultVo;
import com.xy.util.Http;
import com.xy.view.ui.ProgressUI;

import org.puremvc.as3.interfaces.INotification;

public class QuerySoldLogCmd extends AbsCommand {
    
	/**
	 * 查询库存
	 */
	public static const NAME : String = "QuerySoldLogCmd";
	
	public function QuerySoldLogCmd() {
		super();
	}
	
	override public function execute(notification : INotification) : void {
		var url : String = Config.makeQuerySoldLogUrl();
		new Http(url, addRs);
	}
	
	private function addRs(data : String) : void {
		var vo : ResultVo = ResultVo.fromString(data);
		
		/* 记录数据 */
		if (vo.status) {
			dataProxy.initSoldLog(vo.data);
		}
		
		ProgressUI.hide();
	}

}
}
