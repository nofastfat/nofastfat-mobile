package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.util.PopUpManager;
import com.xy.view.ui.ctrls.BackgroundContainer;
import com.xy.view.ui.events.BackgroundContainerEvent;
import com.xy.view.ui.panels.ChooseBackgroundPanel;

import flash.events.Event;

public class BackgroundMediator extends AbsMediator {
    public static const NAME : String = "BackgroundMediator";
	
	private var _panel : ChooseBackgroundPanel;

    public function BackgroundMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);
    }

	override public function onRegister():void{
		ui.setData(dataProxy.backgrounds.values);
		ui.addEventListener(BackgroundContainerEvent.SHOW_MORE_PANEL, __showPanelHandler);
	}
	
	private function __showPanelHandler(e : Event):void{
		if(_panel == null){
			_panel = new ChooseBackgroundPanel();
		}
		PopUpManager.getInstance().showPanel(_panel);
		_panel.setData(dataProxy.backgrounds)
	}
	
    public function get ui() : BackgroundContainer {
        return viewComponent as BackgroundContainer;
    }
}
}
