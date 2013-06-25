package com.xy.view.ui.ctrls {
import flash.display.Shape;
import flash.display.Sprite;

public class AbsContainer extends Sprite {
    private var _bg : Shape;

    public function AbsContainer() {
        super();
        _bg = new Shape();
        _bg.graphics.beginFill(0xFFFFFF, 1);
        _bg.graphics.drawRect(0, 0, 1, 1);
        _bg.graphics.endFill();
        addChild(_bg);
        _bg.width = 200;
    }

    public function resize(height : int) : void {
        _bg.height = height;
    }

    public function setChildVisible(visible : Boolean) : void {
    }
}
}
