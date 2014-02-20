package com.xy.ui.views {
import com.xy.model.Global;
import com.xy.util.STool;

import flash.display.Sprite;
import flash.events.Event;

/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-20 下午3:37:47
 **/
public class Mask {
	private static var _isInit : Boolean = false;
	private static var _mask : Sprite;

	public static function show() : void {
		if (!_isInit) {
			_mask = new Sprite();
			_mask.graphics.beginFill(0x000000, 0.2);
			_mask.graphics.drawRect(0, 0, 1, 1);
			_mask.graphics.endFill();
			Global.root.stage.addEventListener(Event.RESIZE, __resizeHandler);
			_isInit = true;
		}
		_mask.width = _mask.height = 1;
		
		Global.root.alertC.addChild(_mask);
		__resizeHandler(null);
	}
	
	public static function hide():void{
		STool.remove(_mask);
	}
	
	private static function __resizeHandler(e : Event):void{
		if(_mask.stage != null){
			_mask.width = Global.root.stage.stageWidth;
			_mask.height = Global.root.stage.stageHeight;
		}
	}
}
}
