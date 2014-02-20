package com.xy.ui.views {
	import com.xy.model.Global;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;

/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-20 下午3:42:12
 **/
public class PopUpManagerProxy {
	
	private static var _lastWin : IFlexDisplayObject;
	
	private static var _isInit : Boolean = false;
	
	public static function addPopUp(window:IFlexDisplayObject, parent:DisplayObject):void{
		Mask.show();
		PopUpManager.addPopUp(window, parent);
		_lastWin = window;
		
		if(!_isInit){
			Global.root.stage.addEventListener(Event.RESIZE, __resizeHandler);
			_isInit = true;
		}
	}
	
	private static function __resizeHandler(e : Event):void{
		if(_lastWin != null){
			PopUpManager.centerPopUp(_lastWin);
		}
	}
	
	public static function removePopUp(window:IFlexDisplayObject):void{
		PopUpManager.removePopUp(window);
		Mask.hide();
		_lastWin = null;
	}
}
}
