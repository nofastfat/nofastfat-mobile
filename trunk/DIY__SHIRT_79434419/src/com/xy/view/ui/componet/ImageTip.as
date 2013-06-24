package com.xy.view.ui.componet {
import com.xy.component.toolTip.interfaces.ITipViewContent;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.GlowFilter;

public class ImageTip extends Sprite implements ITipViewContent {
    private static var _imageTip : ImageTip = new ImageTip();

    public static function getInstance() : ImageTip {
        return _imageTip;
    }

    private var _bmp : Bitmap
    private var _bg : Shape;

    public function ImageTip() {
        _bg = new Shape();
        addChild(_bg);
		_bg.filters = [new GlowFilter(0xb8b8b8)];

        _bmp = new Bitmap();
        addChild(_bmp);
        _bmp.x = _bmp.y = 10;

    }

    public function setData(data : *) : void {
        _bmp.bitmapData = data as BitmapData;
        _bg.graphics.clear();
        _bg.graphics.lineStyle(1, 0xb8b8b8);
		_bg.graphics.beginFill(0xFFFFFF);
        _bg.graphics.drawRect(0, 0, _bmp.width + 20, _bmp.height + 20);
		_bg.graphics.endFill();
    }

    public function destroy() : void {
    }
}
}
