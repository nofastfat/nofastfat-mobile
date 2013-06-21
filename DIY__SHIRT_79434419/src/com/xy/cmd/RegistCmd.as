package com.xy.cmd {
import com.xy.interfaces.AbsCommand;
import com.xy.model.DiyDataProxy;
import com.xy.view.LeftContainerMediator;
import com.xy.view.RightContainerMediator;

import org.puremvc.as3.interfaces.INotification;

public class RegistCmd extends AbsCommand {
    public static const NAME : String = "RegistCmd";

    public function RegistCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
        var root : DIY__SHIRT_79434419 = notification.getBody() as DIY__SHIRT_79434419;

        facade.registerProxy(new DiyDataProxy());
		
		facade.registerMediator(new LeftContainerMediator(root.left));
		facade.registerMediator(new RightContainerMediator(root.right));

    }
}
}
