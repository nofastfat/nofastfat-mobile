package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.enum.DiyDataNotice;
import com.xy.model.enum.SourceType;
import com.xy.util.PopUpManager;
import com.xy.view.ui.ctrls.BackgroundContainer;
import com.xy.view.ui.ctrls.DecorateContainer;
import com.xy.view.ui.events.BackgroundContainerEvent;
import com.xy.view.ui.events.ChooseBackgroundPanelEvent;
import com.xy.view.ui.panels.ChooseBackgroundPanel;

import flash.events.Event;

public class DecorateMediator extends AbsMediator {
    public static const NAME : String = "DecorateMediator";

    private var _panel : ChooseBackgroundPanel;

    public function DecorateMediator(viewComponent : Object = null) {
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
        map.put(DiyDataNotice.DECORATE_UPDATE, backgroundUpdate);
        return map;
    }

    private function __showPanelHandler(e : BackgroundContainerEvent) : void {
        if (_panel == null) {
            _panel = new ChooseBackgroundPanel(SourceType.DECORATE, 720, 520, "添加装饰");
			_panel.addEventListener(ChooseBackgroundPanelEvent.BACKGROUND_STATUS, __bgStatusHandler);
        }
        PopUpManager.getInstance().showPanel(_panel);
        _panel.setData(dataProxy.decorates)
    }

    private function __hideHandler(e : BackgroundContainerEvent) : void {
		ui.setData(dataProxy.getShowableDecorate());
    }

	private function __bgStatusHandler(e : ChooseBackgroundPanelEvent):void{
		ui.setData(dataProxy.getShowableDecorate());
	}
	
    private function __updateHandler(e : BackgroundContainerEvent) : void {
    }

    private function backgroundUpdate() : void {
        ui.setData(dataProxy.getShowableDecorate());
    }

    private function resize() : void {
        if (_panel != null && _panel.stage != null) {
            _panel.resize();
        }
    }

    public function get ui() : DecorateContainer {
        return viewComponent as DecorateContainer;
    }
}
}
