package com.xy.view.layer {
import com.xy.util.EnterFrameCall;

import flash.display.Shape;
import flash.display.Sprite;

public class RightContainer extends Sprite {
	private var _bg : Shape;
    public function RightContainer() {
        super();
		_bg = new Shape();
		_bg.graphics.beginFill(0xd9d9d9,1);
		_bg.graphics.drawRect(0, 0, 1, 1);
		_bg.graphics.endFill();
		addChild(_bg);
    }
	
	public function resize():void{
		_bg.width = EnterFrameCall.getStage().stageWidth-200;
		_bg.height = EnterFrameCall.getStage().stageHeight;
	}
}
}
