package com.xy {
import com.xy.cmd.RegistCmd;
import com.xy.model.DiyDataProxy;

import org.puremvc.as3.patterns.facade.Facade;

public class DiyFacade extends Facade {
    public function DiyFacade() {
        super();
    }

    override protected function initializeView() : void {
        super.initializeView();

        registerCommand(RegistCmd.NAME, RegistCmd);
    }

    public function startUp(root : DIY__SHIRT_79434419, config:XML) : void {
        sendNotification(RegistCmd.NAME, root);
		
		dataProxy.initConfigXML(config);
		dataProxy.initLoginData();
    }

    public function get dataProxy() : DiyDataProxy {
        return retrieveProxy(DiyDataProxy.NAME) as DiyDataProxy;
    }
}
}
