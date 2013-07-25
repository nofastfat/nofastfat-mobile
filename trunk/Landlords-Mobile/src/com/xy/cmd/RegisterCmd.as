package com.xy.cmd {
import com.xy.interfaces.AbsCommand;
import com.xy.model.LandlordsDataProxy;
import com.xy.view.GameHallMediator;
import com.xy.view.GameRoomMediator;
import com.xy.view.LoginMediator;
import com.xy.view.RegisteMediator;

import org.puremvc.as3.interfaces.INotification;


/**
 * 注册 
 * @author xy
 */
public class RegisterCmd extends AbsCommand {
	public static const NAME : String = "RegisterCmd";
	
	public function RegisterCmd() {
		super();
	}
	
	override public function execute(notification:INotification):void{
		var root : Main = notification.getBody() as Main;
		
		/* model */
		facade.registerProxy(new LandlordsDataProxy());
		
		/* view */
		facade.registerMediator(new LoginMediator(root));
		facade.registerMediator(new RegisteMediator(root));
		facade.registerMediator(new GameHallMediator(root));
		facade.registerMediator(new GameRoomMediator(root));
	}
}
}
