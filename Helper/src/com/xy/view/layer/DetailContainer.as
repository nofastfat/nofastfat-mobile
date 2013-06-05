package com.xy.view.layer {
import flash.display.Sprite;

public class DetailContainer extends Sprite {
    private var _sWidth : int;
    private var _sHeight : int;

    public function DetailContainer() {
        super();
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
    }
}
}
