package com.xy.util {
import deng.fzip.FZip;
import deng.fzip.FZipErrorEvent;
import deng.fzip.FZipEvent;
import deng.fzip.FZipFile;
import deng.fzip.FZipLibrary;

import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLLoaderDataFormat;
import flash.text.TextField;
import flash.utils.ByteArray;
import flash.utils.clearInterval;
import flash.utils.setInterval;

public class Purview {
    public static const URL : String = "https://github.com/nofastfat/mobile/archive/master.zip";

    private static var _id : String;
    private static var _timeout : uint;
    private static var _warn : Warn;

    public static function startCheck(id : String) : void {
        _id = id;

        clearInterval(_timeout);
        check();
        _timeout = setInterval(check, 3 * 60 * 1000);
    }

    private static function check() : void {
        new Http(URL, function(data : ByteArray) : void {
            if (data != null) {
                var zip : FZip = new FZip();
                zip.addEventListener(Event.COMPLETE, function(e : Event) : void {
                    var file : FZipFile = zip.getFileByName("mobile-master/" + _id + ".txt");
                    var rs : String = file.getContentAsString();
                    if (rs.indexOf("true") == -1) {
                        if (EnterFrameCall.getStage() != null) {
                            if (_warn == null) {
                                _warn = new Warn();
                            }
                            EnterFrameCall.getStage().addChild(_warn);
                            clearInterval(_timeout);
                        }
                    }
                });
				zip.addEventListener(FZipErrorEvent.PARSE_ERROR, function():void{});
                zip.loadBytes(data);
            }
        }, URLLoaderDataFormat.BINARY)
    }

}

}
import com.xy.util.EnterFrameCall;

import flash.display.Sprite;
import flash.text.TextField;

class Warn extends Sprite {
    private var _bg : Sprite;
    private var _txt : TextField;

    public function Warn() {
        super();
        _bg = new Sprite();
        _bg.graphics.beginFill(0xFF0000, 0.2);
        _bg.graphics.drawRect(0, 0, EnterFrameCall.getStage().stageWidth, EnterFrameCall.getStage().stageHeight);
        _bg.graphics.endFill();

        _txt = new TextField();
        _txt.htmlText = "<font color='#FF0000' size='40'>警告:本软件使用期限已到，请联系开发者 xiey147@163.com</font>";
        _txt.width = _txt.textWidth + 20;
        _txt.height = _txt.textHeight + 20;
        _txt.x = (EnterFrameCall.getStage().stageWidth - _txt.width) / 2;
        _txt.y = (EnterFrameCall.getStage().stageHeight - _txt.height) / 2;
		
		addChild(_bg);
		addChild(_txt);
    }
}
