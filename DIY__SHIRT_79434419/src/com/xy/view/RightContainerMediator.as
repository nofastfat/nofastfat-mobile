package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.view.layer.RightContainer;
import com.xy.view.ui.SCtrlBar;

import flash.events.Event;

public class RightContainerMediator extends AbsMediator {
    public static const NAME : String = "RightContainerMediator";
	
	private var _ctrlBar : SCtrlBar;

    public function RightContainerMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);
    }
	
	override public function makeNoticeMap():Map{
		var map : Map = new Map();
		map.put(Event.RESIZE, resize);
		return map;
	}
	
	override public function onRegister():void{
		_ctrlBar = new SCtrlBar();
		ui.addChild(_ctrlBar);
		_ctrlBar.x = _ctrlBar.y = 10;
	}

	private function resize():void{
		if(_ctrlBar != null){
			_ctrlBar.resize();
		}
	}
	
    public function get ui() : RightContainer {
        return viewComponent as RightContainer;
    }
}
}
