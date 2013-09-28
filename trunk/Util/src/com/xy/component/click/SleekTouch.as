package com.xy.component.click {
import com.xy.util.EnterFrameCall;

import flash.display.InteractiveObject;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.system.Capabilities;

/**
 * 移动版的滑动事件
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-9-12 下午12:15:41
 **/
public class SleekTouch {
	private static const PC_DPI : int = 72;
	private static const SLEEK_JUGDE : int = 100;

	private static var _maps : Array = [];

	private static var _isInit : Boolean = false;

	private static var _currentObj : *;

	/**
	 * 绑定一个点击事件
	 * @param source 事件源
	 * @param call function(source : InteractiveObject):void{}
	 */
	public static function bindTouch(source : InteractiveObject, call : Function, leftToRight : Boolean = true) : void {
		var obj : * = getInMap(source);
		if (obj != null) {
			var index:int =obj.calls.indexOf(call); 
			if (index == -1) {
				obj.calls.push(call);
				obj.leftToRight.push(leftToRight);
			}else{
				
				obj.calls[index] = call;
				obj.leftToRight[index] = leftToRight;
			}
		} else {
			_maps.push({source: source, calls: [call], leftToRight: [leftToRight]});
			source.addEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
		}


		if (!_isInit) {
			_isInit = true;
			EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_UP, __upHandler, false, -1);
		}
	}

	private static function __downHandler(e : MouseEvent) : void {
		var stage : Stage = EnterFrameCall.getStage();
		var obj : * = getInMap(e.currentTarget as InteractiveObject);
		_currentObj = {source: e.currentTarget, pt: new Point(stage.mouseX, stage.mouseY), leftToRight: obj.leftToRight};
	}

	private static function __upHandler(e : MouseEvent) : void {
		if (_currentObj == null) {
			return;
		}
		var stage : Stage = EnterFrameCall.getStage();
		var pt : Point = new Point(stage.mouseX, stage.mouseY);
		var len : int;
		var leftToRightMatch : Boolean = (pt.x - _currentObj.pt.x) >= SLEEK_JUGDE;
		var rightToLeftMatch : Boolean = (_currentObj.pt.x - pt.x) >= SLEEK_JUGDE;
		if (leftToRightMatch || rightToLeftMatch) {
			var obj : * = getInMap(_currentObj.source);
			for(var i : int = 0; i < obj.calls.length; i++){
				var callFun : Function = obj.calls[i];
				var leftToRight :Boolean= obj.leftToRight[i];
				if((leftToRight && leftToRightMatch) || (!leftToRight && rightToLeftMatch)){
					callFun(_currentObj.source);
				}
			}
		}

		_currentObj = null;
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
				} else {
					var index : int = obj.calls.indexOf(call);
					if (index != -1) {
						obj.calls.splice(index, 1);
					}

					if (obj.calls.length == 0) {
						source.removeEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
						_maps.splice(i, 1);
					}
				}
			}
		}
	}
}
}
