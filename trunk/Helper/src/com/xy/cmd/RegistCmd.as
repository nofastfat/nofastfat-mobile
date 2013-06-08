package com.xy.cmd {
import com.xy.interfaces.AbsCommand;
import com.xy.model.HelperDataProxy;
import com.xy.view.DetailContainerMediator;
import com.xy.view.InfoTreeContainerMediator;
import com.xy.view.SUIPanelMediator;
import com.xy.view.TaskTreeContainerMediator;

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
        facade.registerMediator(new InfoTreeContainerMediator(root.treeContainer));
        facade.registerMediator(new TaskTreeContainerMediator(root.treeContainer));
        facade.registerMediator(new SUIPanelMediator(root.ctrlUI));

        facade.registerCommand(GetOrganizedStructCmd.NAME, GetOrganizedStructCmd);
        facade.registerCommand(GetPersonInfoCmd.NAME, GetPersonInfoCmd);
        facade.registerCommand(GetTaskCmd.NAME, GetTaskCmd);
        facade.registerCommand(GetTaskCmd2.NAME, GetTaskCmd2);
    }
}
}
