package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.enum.DiyDataNotice;
import com.xy.view.layer.LeftContainer;
import com.xy.view.ui.LeftCtrl;
import com.xy.view.ui.ctrls.FontContainer;
import com.xy.view.ui.ctrls.ImageContainer;
import com.xy.view.ui.events.ImageContainerEvent;

import flash.events.Event;

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
		
		(_leftCtrl.getContainer(1) as FontContainer).setData(dataProxy.userableFonts);
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
