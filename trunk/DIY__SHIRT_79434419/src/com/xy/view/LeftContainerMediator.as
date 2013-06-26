package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.enum.DiyDataNotice;
import com.xy.model.enum.SourceType;
import com.xy.util.MulityLoad;
import com.xy.view.layer.LeftContainer;
import com.xy.view.ui.LeftCtrl;
import com.xy.view.ui.ctrls.FontContainer;
import com.xy.view.ui.ctrls.ImageContainer;
import com.xy.view.ui.events.ImageContainerEvent;
import com.xy.view.ui.events.LeftCtrlEvent;

import flash.events.Event;
import flash.utils.setTimeout;

public class LeftContainerMediator extends AbsMediator {
    public static const NAME : String = "LeftContainerMediator";

    private var _leftCtrl : LeftCtrl;

    public function LeftContainerMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(Event.RESIZE, resize);
        return map;
    }

    override public function onRegister() : void {
        _leftCtrl = new LeftCtrl();
        ui.addChild(_leftCtrl);
        _leftCtrl.addEventListener(LeftCtrlEvent.INIT, __initHandler);
    }

    private function __initHandler(e : LeftCtrlEvent) : void {
        switch (e.index) {
            case 1:
                (_leftCtrl.getContainer(1) as FontContainer).setData(dataProxy.userableFonts);
                break;
            case 2:
                MulityLoad.getInstance().load(dataProxy.getShowableBg(), function() : void {
                    setTimeout(sendNotification, 100, DiyDataNotice.BACKGROUND_UPDATE);
                }, SourceType.BACKGROUND);
                break;
            case 3:
                MulityLoad.getInstance().load(dataProxy.getShowableDecorate(), function() : void {
                    setTimeout(sendNotification, 100, DiyDataNotice.DECORATE_UPDATE);
                }, SourceType.DECORATE);
                break;
            case 4:
                MulityLoad.getInstance().load(dataProxy.getShowableFrame(), function() : void {
                    setTimeout(sendNotification, 100, DiyDataNotice.FRAME_UPDATE);
                }, SourceType.FRAME);
                break;
        }
    }

    private function resize() : void {
        if (_leftCtrl != null) {
            _leftCtrl.resize();
        }
    }

    public function get ui() : LeftContainer {
        return viewComponent as LeftContainer;
    }

    public function get leftCtrl() : LeftCtrl {
        return _leftCtrl;
    }
}
}
