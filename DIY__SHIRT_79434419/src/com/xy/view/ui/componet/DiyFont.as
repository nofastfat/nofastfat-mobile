package com.xy.view.ui.componet {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

/**
 * 文字
 * @author xy
 */
public class DiyFont extends DiyBase {
    private var _tf : TextField;
    private var _font : Font;

    private var _bmp : Bitmap;

    public function DiyFont(font : Font) {
        super();

        _editVo.text = "双击输入文字";
        _editVo.fontName = font.fontName;
        _editVo.fontSize = "12";
        _editVo.fontColor = 0xFFFFFF;
        _editVo.tfWidth = 104;
        _editVo.tfHeight = 20;
        _editVo.align = TextFormatAlign.LEFT;

        _tf = new TextField();
        _tf.multiline = true;
        _tf.wordWrap = true;

        _bmp = new Bitmap();
        addChild(_bmp);

        updateShow();
    }

    public function setText(txt : String) : void {
        _editVo.text = txt;

        updateShow();
    }

    override public function setColor(color : uint) : void {
        _editVo.fontColor = color;
        updateShow();
    }

    public function setFontFace(face : String) : void {
        _editVo.fontName = face;
        updateShow();
    }

    public function setFontSize(size : String) : void {
        _editVo.fontSize = size;
        updateShow();
    }

    public function setFontBold(isBold : Boolean) : void {
        _editVo.isBold = isBold;
        updateShow();
    }

    public function setFontAlign(align : String) : void {
        _editVo.align = align;
        updateShow();
    }

    public function updateShow() : void {

        _tf.width = _editVo.tfWidth;
        _tf.height = _editVo.tfHeight;
        _tf.text = _editVo.text;
        _tf.setTextFormat(new TextFormat(_editVo.fontName, _editVo.fontSize, _editVo.fontColor, _editVo.isBold, null, null, null, null, _editVo.align));

        var bmd : BitmapData = new BitmapData(_editVo.tfWidth, _editVo.tfHeight, true, 0x00000000);
        bmd.draw(_tf);
        _bmp.bitmapData = bmd;

        _realH = _bmp.height;
        _realW = _bmp.width;
    }


    override protected function setChild0Size(w : Number, h : Number) : void {
        _editVo.tfWidth = w;
        _editVo.tfHeight = h;
        updateShow();
    }
}
}
