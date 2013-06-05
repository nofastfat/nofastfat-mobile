package com.xy {
import com.xy.cmd.RegistCmd;

import org.puremvc.as3.patterns.facade.Facade;

public class HelperFacade extends Facade {
    public function HelperFacade() {
        super();
    }

    override protected function initializeView() : void {
        super.initializeView();

        registerCommand(RegistCmd.NAME, RegistCmd);
    }

    public function startUp(root : Helper) : void {
		sendNotification(RegistCmd.NAME, root);
    }
}
}
