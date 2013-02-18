package com.xy {
import com.xy.cmd.RegisteCmd;
import com.xy.view.MenuMediator;

import org.puremvc.as3.patterns.facade.Facade;

public class PKFacade extends Facade {
	public function PKFacade() {
		super();
	}

	public function startUp(game : Game) : void {
		sendNotification(RegisteCmd.NAME, game);

		sendNotification(MenuMediator.INIT_MAIN_MENU);
	}

	override protected function initializeController() : void {
		super.initializeController();

		registerCommand(RegisteCmd.NAME, RegisteCmd);
	}
}
}
