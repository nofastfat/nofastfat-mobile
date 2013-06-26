package com.xy.cmd {
import com.xy.interfaces.AbsCommand;
import com.xy.model.DiyDataProxy;
import com.xy.view.BackgroundMediator;
import com.xy.view.DecorateMediator;
import com.xy.view.FrameMediator;
import com.xy.view.ImageMediator;
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

        var leftMediator : LeftContainerMediator = new LeftContainerMediator(root.left);

        facade.registerMediator(leftMediator);
        facade.registerMediator(new RightContainerMediator(root.right));
        facade.registerMediator(new ImageMediator(leftMediator.leftCtrl.getContainer(0)));
        facade.registerMediator(new BackgroundMediator(leftMediator.leftCtrl.getContainer(2)));
        facade.registerMediator(new DecorateMediator(leftMediator.leftCtrl.getContainer(3)));
        facade.registerMediator(new FrameMediator(leftMediator.leftCtrl.getContainer(4)));

    }
}
}
