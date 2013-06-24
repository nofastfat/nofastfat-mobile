package com.xy.view.ui.ctrls {
import com.xy.component.buttons.ToggleButton;
import com.xy.component.buttons.ToggleButtonGroup;
import com.xy.component.buttons.event.ToggleButtonGroupEvent;
import com.xy.ui.ImageSizeUI;
import com.xy.view.ui.events.SImageSizeUIEvent;

public class SImageSizeUI extends ImageSizeUI {
	private var _togGroup : ToggleButtonGroup;
	
    public function SImageSizeUI() {
        super();
        
        _togGroup = new ToggleButtonGroup();
        _togGroup.setToggleButtons([
        	new ToggleButton(size0),
        	new ToggleButton(size1)
        ]);
        
        _togGroup.addEventListener(ToggleButtonGroupEvent.STATE_CHANGE, __changeHandler);
    }
    
    private function __changeHandler(e : ToggleButtonGroupEvent) : void {
    	dispatchEvent(new SImageSizeUIEvent(SImageSizeUIEvent.STATUS_CHANGE, _togGroup.selectIndex));
    }
}
}
