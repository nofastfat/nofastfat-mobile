package com.xy.ui {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.system.ApplicationDomain;
import flash.utils.getDefinitionByName;


/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-11-13 上午10:19:56
 **/
public class SMenuUI extends Sprite {
	private var _iconUpClasses : Array = [];
	private var _iconDownClasses : Array = [];
	private var _texts : Array = ["菜单1", "菜单2", "菜单3"];
	private var _menus : Array = [];

	private var _sw : Number;
	private var _sh : Number;

	private var _selectIndex : int = -1;

	[Inspectable]
	public function set iconUpClasses(arr : Array) : void {
		_iconUpClasses = arr;
		initIconUp();
	}

	[Inspectable]
	public function set iconDownClasses(arr : Array) : void {
		_iconDownClasses = arr;
		initIconDown();
	}

	[Inspectable]
	public function set texts(arr : Array) : void {
		_texts = arr;
		initMenuLen();
		resized();
	}

	public function SMenuUI() {
		super();
		_menus.push(item0);
		initMenuLen();
		resized();
		selectIndex = 0;
	}

	public function resized() : void {
		_sw = width;
		_sh = height;
		scaleX = scaleY = 1;
		var subW : Number = _sw / _menus.length;
		for (var i : int = 0; i < _menus.length; i++) {
			var item : SMenuItemUI = _menus[i];
			item.width = subW;
			item.height = _sh;
			item.resized();
			item.y = 0;
			item.x = subW * i;
		}
	}

	private function initIconUp() : void {
		for (var i : int = 0; i < _menus.length; i++) {
			var item : SMenuItemUI = _menus[i];
			var className : String = _iconUpClasses[i];
			if (className != null && ApplicationDomain.currentDomain.hasDefinition(className)) {
				var clazz : Class = getDefinitionByName(className) as Class;
				var dis : * = new clazz();
				if (dis is BitmapData) {
					item.upIcon = new Bitmap(dis);
				} else {
					item.upIcon = dis;
				}
			}
		}
	}

	private function initIconDown() : void {
		for (var i : int = 0; i < _menus.length; i++) {
			var item : SMenuItemUI = _menus[i];
			var className : String = _iconDownClasses[i];
			if (className != null && ApplicationDomain.currentDomain.hasDefinition(className)) {
				var clazz : Class = getDefinitionByName(className) as Class;
				var dis : * = new clazz();
				if (dis is BitmapData) {
					item.upIcon = new Bitmap(dis);
				} else {

					item.upIcon = dis;
				}
			}
		}
	}

	protected function initMenuLen() : void {
		for (var i : int = 0; i < _texts.length; i++) {
			var item : SMenuItemUI;
			if (i >= _menus.length) {
				item = new SMenuItemUI();
				_menus.push(item);
				addChild(item);
			} else {
				item = _menus[i];
			}
			item.setLabel(_texts[i]);
			if (!item.hasEventListener(MouseEvent.CLICK)) {
				item.addEventListener(MouseEvent.CLICK, __clickHandler);
			}
		}

		var arr : Array = _menus.splice(_texts.length, _menus.length - _texts.length);
		for each (var ii : SMenuItemUI in arr) {
			if (contains(ii)) {
				removeChild(ii);
			}
			ii.addEventListener(MouseEvent.CLICK, __clickHandler);
		}
	}

	private function __clickHandler(e : MouseEvent) : void {
		var target : SMenuItemUI = e.currentTarget as SMenuItemUI;
		selectIndex = _menus.indexOf(target);
		dispatchEvent(new Event(Event.CHANGE));
	}

	public function get selectIndex() : int {
		return _selectIndex;
	}

	public function set selectIndex(value : int) : void {
		var item : SMenuItemUI;
		if (_selectIndex != -1) {
			item = _menus[_selectIndex];
			if (item != null) {
				item.selected = false;
			}
		}
		_selectIndex = value;
		item = _menus[_selectIndex];
		if (item != null) {
			item.selected = true;
		}
	}

}
}
