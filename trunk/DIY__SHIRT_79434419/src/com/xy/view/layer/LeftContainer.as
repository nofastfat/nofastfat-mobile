package com.xy.view.layer {
import com.xy.util.EnterFrameCall;

import flash.display.Shape;
import flash.display.Sprite;

public class LeftContainer extends Sprite {
    private var _bg : Shape;

    public function LeftContainer() {
        super();
        _bg = new Shape();
        _bg.graphics.beginFill(0xFFFFFF, 1);
        _bg.graphics.drawRect(0, 0, 1, 1);
        _bg.graphics.endFill();
        addChild(_bg);
    }

    public function resize() : void {
        _bg.width = 200;
        _bg.height = EnterFrameCall.getStage().stageHeight;
    }
}
}
