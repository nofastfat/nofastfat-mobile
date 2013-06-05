package com.xy.cmd {
import com.xy.interfaces.AbsCommand;
import com.xy.model.HelperDataProxy;
import com.xy.view.DetailContainerMediator;
import com.xy.view.TreeContainerMediator;

import org.puremvc.as3.interfaces.INotification;

public class RegistCmd extends AbsCommand {
    public static const NAME : String = "RegistCmd";

    public function RegistCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
        var root : Helper = notification.getBody() as Helper;

        facade.registerProxy(new HelperDataProxy());

        facade.registerMediator(new DetailContainerMediator(root.detailContainer));
        facade.registerMediator(new TreeContainerMediator(root.treeContainer));
    }
}
}
