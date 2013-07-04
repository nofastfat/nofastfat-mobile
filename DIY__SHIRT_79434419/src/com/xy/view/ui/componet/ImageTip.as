package com.xy.view.ui.componet {
import com.xy.component.toolTip.interfaces.ITipViewContent;
import com.xy.util.STool;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;

public class ImageTip extends Sprite implements ITipViewContent {
    private static var _imageTip : ImageTip = new ImageTip();

    public static function getInstance() : ImageTip {
        return _imageTip;
    }

    private var _bmp : Bitmap;
    private var _bg : Shape;
    private var _bgBmp : Bitmap;

    public function ImageTip() {
        _bg = new Shape();
        addChild(_bg);
        _bg.filters = [new GlowFilter(0xb8b8b8)];

        _bmp = new Bitmap();
        addChild(_bmp);
        _bmp.x = _bmp.y = 10;

        _bgBmp = new Bitmap();
    }

    public function setData(rest : *) : void {

        _bmp.bitmapData = rest[0] as BitmapData;
        _bg.graphics.clear();
        _bg.graphics.lineStyle(1, 0xb8b8b8);
        _bg.graphics.beginFill(0xFFFFFF);
        _bg.graphics.drawRect(0, 0, _bmp.width + 20, _bmp.height + 20);
        _bg.graphics.endFill();

        if (rest.length > 1) {
            var bgBmd : BitmapData = rest[1];
            var rect : Rectangle = rest[2];
            _bgBmp.bitmapData = bgBmd;
            _bgBmp.x = 10 + rect.x;
            _bgBmp.y = 10 + rect.y;
            _bgBmp.width = rect.width;
            _bgBmp.height = rect.height;
			addChildAt(_bgBmp, 1);

        } else {
            STool.remove(_bgBmp);
        }

    }

    public function destroy() : void {
    }
}
}
