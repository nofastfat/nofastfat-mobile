package com.xy.component.alert {

import com.xy.component.alert.enum.AlertType;
import com.xy.component.alert.interfaces.IAlertContent;
import com.xy.util.EnterFrameCall;
import com.xy.util.STool;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.external.ExternalInterface;
import flash.ui.Keyboard;

/**
 * UI提示框
 * @author xy
 */
public class Alert {
    /**
     * 背景MC
     */
    private static var _bg : Sprite;

    /**
     * 所有支持自定义的按钮
     */
    private static var _btns : Array = [];

    /**
     * 显示的父类
     */
    private static var _parent : DisplayObjectContainer;

    /**
     * 显示的内容
     */
    private static var _content : IAlertContent;

    /**
     * 回调函数
     */
    private static var _callBack : Function;

    /**
     * 是否已经初始化,只能初始化一次
     */
    private static var _hasInit : Boolean;
	
	private static var _mask : Sprite;

	/**
	 * 初始化显示容器 
	 * @param parent
	 * @param bg
	 */	
    public static function initParent(parent : DisplayObjectContainer, bg : Sprite, useMask : Boolean = false) : void {
        if (_hasInit) {
            return;
        }
        _bg = bg;

        _parent = parent;
        _hasInit = true;
        _btns = [
			bg["okBtn"],
			bg["cancelBtn"]
            ];

        for each (var btn : SimpleButton in _btns) {
            btn.addEventListener(MouseEvent.CLICK, __btnHandler);
        }

        _bg["closeBtn"].addEventListener(MouseEvent.CLICK, __cancelHandler);

        _bg.x = (_parent.width - _bg.width) / 2;
        _bg.y = (_parent.height - _bg.height) / 2;
		
		EnterFrameCall.getStage().addEventListener(KeyboardEvent.KEY_UP, __keyHandler);
		
		if(useMask){
			_mask = new Sprite();
			_mask.graphics.beginFill(0x000000, .2);
			_mask.graphics.drawRect(0, 0, 1, 1);
			_mask.graphics.endFill();
		}
    }

    /**
     * 显示一个弹窗
     * @param alertContent
     * @param closeFun 回调形式:closeFun(type:int, value:*);
     */
    public static function show(alertContent : IAlertContent, closeFun : Function = null) : void {
        if (alertContent == null) {
            return;
        }

        if (!_hasInit || _parent == null) {
            throw new Error("Alert没有初始化parent!");
            return;
        }
		
		simpleDispose();

        _content = alertContent;
        _callBack = closeFun;
		
        _bg["bg"].addChild(alertContent as DisplayObject);
		_bg.x = _bg.y = 0;

        showBtn(alertContent.getAlertType());
		showTitle(alertContent.getTitleType());
		var ww : int = _parent.width;
		var hh:int = _parent.height;
		if(_parent.hasOwnProperty("stageWidth")){
			ww = _parent["stageWidth"];
		}
		if(_parent.hasOwnProperty("stageHeight")){
			hh = _parent["stageHeight"];
		}
		
		_bg.x = (ww - _bg.width)/2;
		_bg.y = (hh - _bg.height)/2;
		
		if(_mask != null){
			_parent.addChild(_mask);
			_mask.width = ww;
			_mask.height = hh;
		}
		
		_parent.addChild(_bg);
    }

	/**
	 * 调用系统的消息弹窗 
	 * @param txt
	 */	
	public static function showText(txt : String) :void {
		
	}
	
    /**
     * 销毁
     */
    public static function dispose() : void {
        simpleDispose();
        _hasInit = false;

        for each (var btn : SimpleButton in _btns) {
            btn.removeEventListener(MouseEvent.CLICK, __btnHandler);
        }

        _bg["closeBtn"].removeEventListener(MouseEvent.CLICK, __cancelHandler);

        _btns = [];
        _bg = null;
		STool.clear(_bg);
		STool.clear(_parent);
		_parent = null;
		
		EnterFrameCall.getStage().removeEventListener(KeyboardEvent.KEY_UP, __keyHandler);
    }

    /**
     * 显示何种按钮
     * @param alertType
     */
    private static function showBtn(alertType : int) : void {
        var arr : Array = alertType.toString(2).split("");
        arr.reverse();

        var count : int = 0;
        for each (var value : String in arr) {
            var state : int = int(value);
            if (state == 1) {
                count++;
            }
        }

        for each (var btn : SimpleButton in _btns) {
            btn.visible = false;
        }

        count = 0;
        for (var i : int = 0; i < arr.length; i++) {
            var vl : int = int(arr[i]);
            btn = _btns[i];
            if (btn != null) {
                btn.visible = vl == 1;

                if (vl == 1) {
                    //btn.x = Number(locations[count][0]);
                    count++;
                }
            }
        }
    }
	
	/**
	 * 获取弹出面板的title 
	 * @param alertTitleType
	 */	
	private static function showTitle(alertTitleType : int) : void {
		//_bg.title.gotoAndStop(alertTitleType); 
	}

    /**
     * 点击了取消按钮
     * @param e
     */
    private static function __cancelHandler(e : MouseEvent = null) : void {
		var cb : Function = _callBack;
		simpleDispose();
        if (cb != null) {
			cb(AlertType.CANCEL, null);
        }

    }

    /**
     * 点击了确认按钮
     * @param e
     */
    private static function __btnHandler(e : MouseEvent) : void {
        var rs : * = _content.getResult();
		
		var cb : Function = _callBack;
		simpleDispose();
		
        if (cb != null) {
            var btn : SimpleButton = e.currentTarget as SimpleButton;
            var index : int = _btns.indexOf(btn);
			cb(Math.pow(2, index), rs);
        }
    }

	private static function __keyHandler(e : KeyboardEvent) : void {
		if(e.keyCode == Keyboard.ESCAPE){
			__cancelHandler();
		}
	}
	
    /**
     * 关闭后的销毁
     */
    private static function simpleDispose() : void {
        _callBack = null;
        if (_bg != null && _bg["bg"] != null && _content != null) {
            _bg["bg"].removeChild(_content as DisplayObject);
        }

        if (_content != null) {
            _content.dispose();
        }
        _content = null;

        if (_parent != null && _bg != null && _parent.contains(_bg)) {
            _parent.removeChild(_bg);
        }
		STool.remove(_mask);
    }

}
}
