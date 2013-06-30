package com.xy.cmd {
import com.xy.interfaces.AbsCommand;
import com.xy.view.RightContainerMediator;

import flash.text.Font;

import org.puremvc.as3.interfaces.INotification;

public class AddFontCmd extends AbsCommand {
	
    /**
     * 添加一个文字到场景上
     * font:Font
     */
    public static const NAME : String = "AddFontCmd";

    public function AddFontCmd() {
        super();
    }
    
    override public function execute(notification : INotification) : void {
        var font : Font = notification.getBody()[0];
        var ix : Number = notification.getBody()[1];
        var iy : Number = notification.getBody()[2];

        sendNotification(RightContainerMediator.ADD_FONT, [font, ix, iy]);
    }
}
}
