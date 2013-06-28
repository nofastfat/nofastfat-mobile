package com.xy.cmd {
import com.xy.interfaces.AbsCommand;
import com.xy.util.EnterFrameCall;
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
        var font : Font = notification.getBody() as Font;
		var stageX : Number = EnterFrameCall.getStage().mouseX;
		var stageY : Number = EnterFrameCall.getStage().mouseY;
		
		sendNotification(RightContainerMediator.ADD_FONT, [font, stageX, stageY]);
    }
}
}
