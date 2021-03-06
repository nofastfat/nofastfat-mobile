package com.xy.component.click {
import com.xy.util.EnterFrameCall;

import flash.display.InteractiveObject;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.system.Capabilities;

/**
 * 移动版的点击事件
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-9-12 下午12:15:41
 **/
public class TouchClick {
	private static const PC_DPI : int = 72; 
	private static const CLICK_JUGDE : int = 2;
	
	private static var _maps : Array = [];

	private static var _isInit : Boolean = false;

	private static var _currentObj : *;

	/**
	 * 绑定一个点击事件 
	 * @param source 事件源
	 * @param call function(source : InteractiveObject):void{}
	 */	
	public static function bindTouch(source : InteractiveObject, call : Function) : void {
		var obj : * = getInMap(source);
		if (obj != null) {
			if (obj.calls.indexOf(call) == -1) {
				obj.calls.push(call);
			}
		} else {
			_maps.push({source: source, calls: [call]});
			source.addEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
		}


		if (!_isInit) {
			_isInit = true;
			EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_UP, __upHandler, false, -1);
		}
	}

	private static function __downHandler(e : MouseEvent) : void {
		var stage : Stage = EnterFrameCall.getStage();
		_currentObj = {source: e.currentTarget, pt: new Point(stage.mouseX, stage.mouseY), clickEnable:true};
		EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_MOVE, __moveHandler);
	}

	private static function __upHandler(e : MouseEvent) : void {
		EnterFrameCall.getStage().removeEventListener(MouseEvent.MOUSE_MOVE, __moveHandler);
		if (_currentObj == null) {
			return;
		}
		if (_currentObj.clickEnable) {
			var obj : * = getInMap(_currentObj.source);
			for each (var callFun : Function in obj.calls) {
				callFun(_currentObj.source);
			}
		}

		_currentObj = null;
	}
	
	private static var _tmpPt : Point = new Point();
	
	private static function __moveHandler(e : Event):void{
		if (_currentObj == null) {
			return;
		}
		
		var stage : Stage = EnterFrameCall.getStage();
		_tmpPt.setTo(stage.mouseX, stage.mouseY);
		var len : int = _tmpPt.subtract(_currentObj.pt).length;
		if (len > CLICK_JUGDE) {
			_currentObj.clickEnable = false;
		}
	}

	private static function getInMap(source : InteractiveObject) : * {
		for each (var obj : * in _maps) {
			if (obj.source == source) {
				return obj;
			}
		}

		return null;
	}

	private static function isInMap(source : InteractiveObject) : Boolean {
		for each (var obj : * in _maps) {
			if (obj.source == source) {
				return true;
			}
		}

		return false;
	}

	/**
	 * 解除绑定 
	 * @param source
	 * @param call
	 */	
	public static function unBind(source : InteractiveObject, call : Function) : void {
		if (_currentObj != null && _currentObj.source == source) {
			_currentObj = null;
		}

		for (var i : int = 0; i < _maps.length; i++) {
			var obj : * = _maps[i];
			if (obj.source == source) {

				if (call == null) {
					source.removeEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
					_maps.splice(i, 1);
					return;
				}else{
					var index : int = obj.calls.indexOf(call);
					if(index != -1){
						obj.calls.splice(index, 1);
					}
					
					if(obj.calls.length == 0){
						source.removeEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
						_maps.splice(i, 1);
					}
				}
			}
		}
	}
}
}
