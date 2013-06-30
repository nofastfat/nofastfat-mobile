package com.xy.component.menu {

import com.xy.util.STool;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

/**
 * 弹出式菜单
 * @author xy
 */
public class Menu {

	/**
	 * stage
	 */
	private static var _parent : DisplayObjectContainer;

	/**
	 * 是否已经初始化
	 */
	private static var _hasInit : Boolean;

	/**
	 * 显示内容
	 */
	private static var _content : Sprite;

	/**
	 * 背景
	 */
	private static var _bg : DisplayObject;

	/**
	 * 内容
	 */
	private static var _contentList : Array = [];

	/**
	 * 回调
	 */
	private static var _callBack : Function;

	/**
	 * 初始化
	 * @param stage
	 */
	public static function initParent(parent : DisplayObjectContainer, bg : DisplayObject = null) : void {
		if (!_hasInit) {
			_parent = parent;
			_hasInit = true;
			_content = new Sprite();
			_bg = bg;
		}
	}

	public static function dispose() : void {
		__hideHandler();
		_parent.removeEventListener(MouseEvent.CLICK, __hideHandler);
		_parent = null;
		_bg = null;
		_content = null;
		_hasInit = false;
	}

	public static function isShowed():Boolean{
		return _content.stage != null;
	}

	/**
	 * 显示菜单
	 * @param location 位置
	 * @param contentList 内容数组[DisplayObject, DisplayObject, ...]
	 * @param callback 点击后的回调,callback(DisplayObject.name)
	 * @param margins [Number, Number, Number, Number]分别表示上下左右的margin值
	 */
	public static function show(location : Point, contentList : Array, callback : Function, margins : Array = null) : void {
		if (!_hasInit) {
			throw new Error("Menu未初始化");
			return;
		}

		STool.clear(_content);
		_content.addChild(_bg);

		var maxWith : Number = 0;
		for each (var dis : DisplayObject in contentList) {
			_content.addChild(dis);
			dis.addEventListener(MouseEvent.CLICK, __clickHandler);

			maxWith = dis.width > maxWith ? dis.width : maxWith;
		}

		var marginTop : Number = 0;
		var marginBottom : Number = 0;
		var marginLeft : Number = 0;
		var marginRight : Number = 0;
		if (margins != null) {
			if (margins.length > 0) {
				marginTop = margins[0];
			}
			if (margins.length > 1) {
				marginBottom = margins[1];
			}
			if (margins.length > 2) {
				marginLeft = margins[2];
			}
			if (margins.length > 3) {
				marginRight = margins[3];
			}
		}
		maxWith += marginLeft + marginRight;

		var lastHeight : Number = marginTop;
		for each (dis in contentList) {
			dis.x = (maxWith - dis.width) / 2;
			dis.y = lastHeight;
			lastHeight += dis.height;
		}
		_bg.width = maxWith;
		_bg.height = lastHeight + marginBottom;

		_parent.addChild(_content);
		locationCheck(location);
		_callBack = callback;

		_parent.addEventListener(MouseEvent.CLICK, __hideHandler);

	}

	public static function hide():void{
		__hideHandler(null);
	}
	
	/**
	 * 位置检查，避免跑到屏幕外面
	 */
	private static function locationCheck(location : Point) : void {

		if (location.x + _content.width + 10 > 960) {
			location.x -= _content.width;
		}

		if (location.y + _content.height + 10 > 560) {
			location.y -= _content.height;
		}

		_content.x = location.x;
		_content.y = location.y;
	}

	private static function __clickHandler(e : MouseEvent) : void {
		if (_callBack != null) {
			_callBack(e.currentTarget.name);
		}
	}

	private static function __hideHandler(e : MouseEvent = null) : void {
		STool.remove(_content);

		STool.clear(_content);
		for each (var dis : DisplayObject in _contentList) {
			dis.removeEventListener(MouseEvent.CLICK, __clickHandler);
		}
		_callBack = null;
		_contentList = [];

		_parent.removeEventListener(MouseEvent.CLICK, __hideHandler);
	}
}
}
