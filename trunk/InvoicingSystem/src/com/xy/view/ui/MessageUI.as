package com.xy.view.ui {
import com.greensock.TweenLite;
import com.xy.util.EnterFrameCall;
import com.xy.util.STool;

import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

public class MessageUI extends Sprite {
    [Embed(source = '../../../../../assets/tip.png')]
    private static const IMAGE : Class;

    private static var _instance : MessageUI;

    public static function getInstance() : MessageUI {
        if (_instance == null) {
            _instance = new MessageUI();
        }

        return _instance;
    }

    private var _img : Bitmap;
    private var _tf : TextField;
    private var _bg : Shape;

    public function MessageUI() {
        super();

        _img = new IMAGE();

        _bg = new Shape();
        addChild(_bg);
        addChild(_img);
        _tf = new TextField();
        _img.x = 10;
        _img.y = 10;
        addChild(_tf);
        _tf.defaultTextFormat = new TextFormat("宋体", 14, 0xFFFF00, true);
        _tf.x = _img.x + _img.width + 10;
        _tf.height = 24;
        _tf.y = 10;
    }

    public function showMessage(msg : String) : void {
        _tf.text = msg;

        var w : int = _tf.x + _tf.textWidth + 10;

        _bg.graphics.clear();
        _bg.graphics.beginFill(0x000000, 0.6);
        _bg.graphics.drawRoundRect(0, 0, w, _img.y + _img.height + 10., 10, 10);
        _bg.graphics.endFill();

        EnterFrameCall.getStage().addChild(this);
        this.y = -1;
        this.x = (EnterFrameCall.getStage().stageWidth - this.width) / 2;

        TweenLite.from(_instance, 0.3, {y: -_instance.height, overwrite: true, onComplete: function() : void {
            TweenLite.to(_instance, 0.3, {delay: 3, y: -_instance.height, overwrite: true, onComplete: function() : void {
                STool.remove(_instance);
            }});
        }});
    }
}
}
