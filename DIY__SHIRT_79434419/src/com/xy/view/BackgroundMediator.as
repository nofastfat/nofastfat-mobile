package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.enum.DiyDataNotice;
import com.xy.model.enum.SourceType;
import com.xy.util.PopUpManager;
import com.xy.view.ui.ctrls.BackgroundContainer;
import com.xy.view.ui.events.BackgroundContainerEvent;
import com.xy.view.ui.events.ChooseBackgroundPanelEvent;
import com.xy.view.ui.panels.ChooseBackgroundPanel;

import flash.events.Event;

public class BackgroundMediator extends AbsMediator {
    public static const NAME : String = "BackgroundMediator";

    private var _panel : ChooseBackgroundPanel;

    public function BackgroundMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);
    }

    override public function onRegister() : void {
        ui.setData([]);
        ui.addEventListener(BackgroundContainerEvent.SHOW_MORE_PANEL, __showPanelHandler);
        ui.addEventListener(BackgroundContainerEvent.HIDE_BACKGROUND, __hideHandler);
        ui.addEventListener(BackgroundContainerEvent.UPDATE_BACKGROUND, __updateHandler);
    }


    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(Event.RESIZE, resize);
        map.put(DiyDataNotice.BACKGROUND_UPDATE, backgroundUpdate);
        return map;
    }

    private function __showPanelHandler(e : BackgroundContainerEvent) : void {
        if (_panel == null) {
            _panel = new ChooseBackgroundPanel(SourceType.BACKGROUND);
			_panel.addEventListener(ChooseBackgroundPanelEvent.BACKGROUND_STATUS, __bgStatusHandler);
        }
        PopUpManager.getInstance().showPanel(_panel);
        _panel.setData(dataProxy.backgrounds)
    }

    private function __hideHandler(e : BackgroundContainerEvent) : void {
		ui.setData(dataProxy.getShowableBg());
    }

	private function __bgStatusHandler(e : ChooseBackgroundPanelEvent):void{
		ui.setData(dataProxy.getShowableBg());
	}
	
    private function __updateHandler(e : BackgroundContainerEvent) : void {
    }

    private function backgroundUpdate() : void {
        ui.setData(dataProxy.getShowableBg());
    }

    private function resize() : void {
        if (_panel != null && _panel.stage != null) {
            _panel.resize();
        }
    }

    public function get ui() : BackgroundContainer {
        return viewComponent as BackgroundContainer;
    }
}
}
