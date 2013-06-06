package com.xy.view.layer {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

public class DetailContainer extends Sprite {
    private var _sWidth : int;
    private var _sHeight : int;
	
	private var _bg : Sprite;
    public function DetailContainer() {
        super();
		
		_bg = new Sprite();
		_bg.graphics.beginFill(0xFFFFFF);
		_bg.graphics.drawRect(0, 0, 1, 1);
		_bg.graphics.endFill();
		addChild(_bg);
        
    }

    /**
     * 舞台上允许显示的最大高
     * @return
     */
    public function get sHeight() : int {
        return _sHeight;
    }

    /**
     * 舞台上允许显示的最大宽
     * @return
     */
    public function get sWidth() : int {
        return _sWidth;
    }

    public function resize(newW : int, newH : int) : void {
        _sWidth = newW;
        _sHeight = newH;
		
		_bg.width = _sWidth;
		_bg.height = _sHeight;
    }
}
}
