package com.xy {
import com.xy.mediators.GatherMediator;
import com.xy.mediators.GoodsMediator;
import com.xy.mediators.LeftMediator;
import com.xy.mediators.LoginMediator;
import com.xy.mediators.ManageGoodsMediator;
import com.xy.mediators.ManageUserMediator;
import com.xy.mediators.TopMediator;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;


/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-18 下午3:31:33
 **/
public class InitCmd extends SimpleCommand {
	public static const NAME : String = "InitCmd";
	
	public function InitCmd() {
		super();
	}
	
	override public function execute(notification:INotification):void{
		var root : yydc = notification.getBody() as yydc;
		
		facade.registerMediator(new LoginMediator());
		facade.registerMediator(new TopMediator(root.topUI));
		facade.registerMediator(new LeftMediator(root.leftUI));
		facade.registerMediator(new GoodsMediator(root.container));
		facade.registerMediator(new GatherMediator(root.container));
		facade.registerMediator(new ManageGoodsMediator(root.container));
		facade.registerMediator(new ManageUserMediator(root.container));
	}
}
}
