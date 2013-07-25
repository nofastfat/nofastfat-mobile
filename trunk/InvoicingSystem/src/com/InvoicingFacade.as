package com {
import com.xy.cmd.RegisterCmd;
import com.xy.view.LoginUIMediator;

import org.puremvc.as3.patterns.facade.Facade;

public class InvoicingFacade extends Facade {
    public function InvoicingFacade() {
        super();
    }

    override protected function initializeController() : void {
        super.initializeController();
        registerCommand(RegisterCmd.NAME, RegisterCmd);
    }

    public function startUp(root : InvoicingSystem) : void {
        sendNotification(RegisterCmd.NAME, root);

        sendNotification(LoginUIMediator.SHOW_PANEL);
    }
}
}
