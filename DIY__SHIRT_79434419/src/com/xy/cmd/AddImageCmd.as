package com.xy.cmd {
import com.xy.interfaces.AbsCommand;
import com.xy.model.vo.BitmapDataVo;
import com.xy.util.EnterFrameCall;
import com.xy.view.RightContainerMediator;

import org.puremvc.as3.interfaces.INotification;

public class AddImageCmd extends AbsCommand {

    /**
     * 添加一个图片到场景上
     *  [vo:BitmapDataVo, ix:int, iy:int]
     */
    public static const NAME : String = "AddImageCmd";

    public function AddImageCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
        var vo : BitmapDataVo = notification.getBody()[0];
        var ix : Number = notification.getBody()[1];
        var iy : Number = notification.getBody()[2];

        sendNotification(RightContainerMediator.ADD_IMAGE, [vo, ix, iy]);
    }
}
}
