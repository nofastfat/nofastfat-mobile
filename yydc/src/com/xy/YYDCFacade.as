package com.xy {
import com.xy.mediators.LoginMediator;

import org.puremvc.as3.patterns.facade.Facade;

public class YYDCFacade extends Facade {
	public function YYDCFacade() {
		super();
	}
	
	override protected function initializeController():void{
		super.initializeController();
		
		registerCommand(InitCmd.NAME, InitCmd);
	}
	
	public function startUp(root:yydc):void{
		sendNotification(InitCmd.NAME, root);
		
		sendNotification(LoginMediator.SHOW);
	}

}
}
