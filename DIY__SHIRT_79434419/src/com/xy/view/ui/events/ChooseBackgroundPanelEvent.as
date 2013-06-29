package com.xy.view.ui.events {
import com.xy.model.vo.BitmapDataVo;

import flash.events.Event;

public class ChooseBackgroundPanelEvent extends Event {
	public static const BACKGROUND_STATUS : String = "BACKGROUND_STATUS";
	
	public var vo : BitmapDataVo;
	
    public function ChooseBackgroundPanelEvent(type : String,vo : BitmapDataVo, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        
        this.vo = vo;
    }
}
}
