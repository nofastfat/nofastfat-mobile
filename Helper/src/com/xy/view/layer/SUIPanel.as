package com.xy.view.layer {
import com.xy.ui.UIPanel;

import flash.display.Sprite;

public class SUIPanel extends UIPanel {
	private var _bg : Sprite;
	
    public function SUIPanel() {
        super();
        
        _bg = new Sprite();
        _bg.graphics.beginFill(0xFFFFFF);
        _bg.graphics.drawRect(0, 0, width, height);
        _bg.graphics.endFill();
        
        addChildAt(_bg, 0);
    }

}
}
