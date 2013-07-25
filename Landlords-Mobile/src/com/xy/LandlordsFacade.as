package com.xy {
import com.xy.cmd.RegisterCmd;

import org.puremvc.as3.patterns.facade.Facade;

public class LandlordsFacade extends Facade {
	public function LandlordsFacade() {
		super();
	}
	
	/**
	 * 启动 
	 * @param root
	 */	
	public function startUp(root : Main):void{
		sendNotification(RegisterCmd.NAME, root);
	}
	
	override protected function initializeController():void{
		super.initializeController();
		
		registerCommand(RegisterCmd.NAME, RegisterCmd);
	}
}
}
