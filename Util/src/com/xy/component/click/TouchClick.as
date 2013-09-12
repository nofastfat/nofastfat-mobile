package com.xy.component.click {
import com.xy.util.EnterFrameCall;

import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

/**
 * 移动版的点击事件
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-9-12 下午12:15:41
 **/
public class TouchClick {
	private static var _maps : Array = [];

	private static var _isInit : Boolean = false;

	private static var _currentObj : *;

	public static function bindTouch(source : InteractiveObject, call : Function) : void {
		if (isInMap(source)) {
			return;
		}
		_maps.push({source: source, call: call});
		source.addEventListener(MouseEvent.MOUSE_DOWN, __downHandler);


		if (!_isInit) { 
			_isInit = true;
			EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_UP, __upHandler, false, -1);
		}
	}

	private static function __downHandler(e : MouseEvent) : void {
		_currentObj = {source: e.currentTarget, pt: new Point(e.stageX, e.stageY)};
	}

	private static function __upHandler(e : MouseEvent) : void {
		if (_currentObj == null) {
			return;
		}
		var pt : Point = new Point(e.stageX, e.stageY);
		var len : int = pt.subtract(_currentObj.pt).length;
		if (len <= 2) {
			var obj : * = getInMap(_currentObj.source);
			obj.call();
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

	public static function unBind(source : InteractiveObject) : void {
		if (_currentObj != null && _currentObj.source == source) {
			_currentObj = null;
		}

		for (var i : int = 0; i < _maps.length; i++) {
			var obj : * = _maps[i];
			if (obj.source == source) {
				source.removeEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
				_maps.splice(i, 1);
				return;
			}
		}
	}
}
}
