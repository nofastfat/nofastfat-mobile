package com.xy.util {
import com.xy.view.ui.events.AbsPanelEvent;
import com.xy.view.ui.panels.AbsPanel;

import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;

public class PopUpManager {
    private static var _intance : PopUpManager;

    public static function getInstance() : PopUpManager {
        if (_intance == null) {
            _intance = new PopUpManager();
        }

        return _intance;
    }


    private var _panel : AbsPanel;
    private var _mask : Sprite;
    private var _stage : Stage;

    public function PopUpManager() {
        _mask = new Sprite();

        _mask.graphics.beginFill(0x000000, .2);
        _mask.graphics.drawRect(0, 0, 1, 1);
        _mask.graphics.endFill();

        _stage = EnterFrameCall.getStage();
		
		_stage.addEventListener(Event.RESIZE, __resizeHandler);
    }

    public function showPanel(panel : AbsPanel) : void {
        _panel = panel;

        _stage.addChild(_mask);
        _mask.width = _stage.stageWidth;
        _mask.height = _stage.stageHeight;
		_panel.showTo(_stage);

        _panel.addEventListener(AbsPanelEvent.CLOSE, __closeHander);
    }

	public function closeAll():void{
		if(_panel != null){
			_panel.close();
		}
		STool.remove(_mask);
	}
	
    private function __closeHander(e : AbsPanelEvent) : void {
		_panel.removeEventListener(AbsPanelEvent.CLOSE, __closeHander);
        _panel = null;
        STool.remove(_mask);
    }
	
	private function __resizeHandler(e : Event):void{
		if(_mask != null && _mask.stage != null){
			_mask.width = _stage.stageWidth;
			_mask.height = _stage.stageHeight;
		}
	}
	
}
}
