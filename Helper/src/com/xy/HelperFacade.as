package com.xy {
import com.xy.cmd.RegistCmd;
import com.xy.model.HelperDataProxy;
import com.xy.view.InfoTreeContainerMediator;

import org.puremvc.as3.patterns.facade.Facade;

public class HelperFacade extends Facade {
    public function HelperFacade() {
        super();
    }

    override protected function initializeView() : void {
        super.initializeView();

        registerCommand(RegistCmd.NAME, RegistCmd);
    }

    public function startUp(root : Helper, initData : String) : void {
        sendNotification(RegistCmd.NAME, root);
		
		dataProxy.initData(initData);
		
		sendNotification(InfoTreeContainerMediator.INIT_SHOW);
    }


    public function get dataProxy() : HelperDataProxy {
        return retrieveProxy(HelperDataProxy.NAME) as HelperDataProxy;
    }
}
}
