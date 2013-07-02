package com.xy.view.layer {
import com.xy.util.EnterFrameCall;

import flash.display.Shape;
import flash.display.Sprite;

public class RightContainer extends Sprite {
    private var _bg : Sprite;
    private var _selectUI : Shape;
    private var _container : Sprite;

    public function RightContainer() {
        super();
        _bg = new Sprite();
        _bg.graphics.beginFill(0xd9d9d9, 1);
        _bg.graphics.drawRect(0, 0, 1, 1);
        _bg.graphics.endFill();

        _selectUI = new Shape();
        _container = new Sprite();
		_container.mouseEnabled = false;
        addChild(_bg);
        addChild(_container);
        addChild(_selectUI);
    }

    public function get container() : Sprite {
        return _container;
    }

    public function get selectUI() : Shape {
        return _selectUI;
    }

    public function resize() : void {
        _bg.width = EnterFrameCall.getStage().stageWidth - 200;
        _bg.height = EnterFrameCall.getStage().stageHeight;
    }

    public function get bg() : Sprite {
        return _bg;
    }
}
}
