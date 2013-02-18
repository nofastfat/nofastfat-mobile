package com.xy.cmd {
import com.xy.interfaces.AbsCommand;
import com.xy.view.UILayerMediator;

import org.puremvc.as3.interfaces.INotification;

public class GameOverCmd extends AbsCommand {
	public static const NAME : String = "GameOverCmd";
	
	public function GameOverCmd() {
		super();
	}
	
	override public function execute(notification:INotification):void{
		sendNotification(UILayerMediator.SHOW_TASK_RESULT, false, null);
	}
}
}
