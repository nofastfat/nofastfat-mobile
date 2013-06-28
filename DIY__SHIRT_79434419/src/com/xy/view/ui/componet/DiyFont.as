package com.xy.view.ui.componet {
import flash.text.Font;
import flash.text.TextField;

/**
 * 文字
 * @author xy
 */
public class DiyFont extends DiyBase {
    private var _tf : TextField;
    private var _font : Font;

    public function DiyFont(font : Font) {
        super();

        _tf = new TextField();
        _tf.htmlText = "<font face='" + font.fontName + "'>双击输入文字</font>";

        _tf.width = _tf.textWidth + 10;
        _tf.height = _tf.textHeight + 2;
        addChild(_tf);
		mouseChildren = false;
		
		_realW = width;
		_realH = height;
    }
}
}
