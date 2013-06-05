package com.xy.cmd {
import com.xy.interfaces.AbsCommand;

import org.puremvc.as3.interfaces.INotification;

public class RegistCmd extends AbsCommand {
    public static const NAME : String = "RegistCmd";

    public function RegistCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
        var root : Helper = notification.getBody() as Helper;
    }
}
}
