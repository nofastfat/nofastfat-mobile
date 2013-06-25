package com.xy.component.colorPicker {
import com.xy.component.colorPicker.enum.PreSwatches;
import com.xy.util.STool;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.utils.getTimer;

/**
 * 调色板
 * 
 * <br><b>Example:</b><br>
 * var piker = new ColorPicker(16, 8, new Point(11, 11), PreSwatches.PS_COLORS);<br>
 * addChild(piker);
 * 
 * @author xy
 */
[Event(name = "select_color", type = "ColorPikerEvent")]
public class ColorPicker extends Sprite {

	/**
	 * 横着放多少个
	 */
	private var _xCount : int;

	/**
	 * 竖着放多少个
	 */
	private var _yCount : int;

	/**
	 * 单个尺寸
	 */
	private var _size : Point;

	/**
	 * 预存储的颜色
	 */
	private var _colors : Array = [];
	
	/**
	 * 表示选中的东西
	 */
	private var _selectMark : Sprite;
	
	/**
	 * 表示选中的东西
	 */
	private var _selectedMark : Sprite;

	/**
	 * 创建一个PS色板
	 * @param xCount 横着放多少个
	 * @param yCount 竖着放多少个
	 * @param size 单个尺寸
	 * @param sourceColors 源色值
	 */
	public function ColorPicker(xCount : int, yCount : int, size : Point, sourceColors : Array) {
		size.x++;
		size.y++;
		_xCount = xCount;
		_yCount = yCount;
		_size = size;
		_colors = sourceColors;

		create();
		
		_selectMark = new Sprite();
		_selectMark.graphics.lineStyle(1, 0xFFFFFF);
		_selectMark.graphics.drawRect(0, 0, size.x, size.y);
		addChild(_selectMark);
		_selectMark.visible = false;
		_selectMark.mouseEnabled = false;
		_selectMark.mouseChildren = false;
		
		
		_selectedMark = new Sprite();
		_selectedMark.graphics.lineStyle(1, 0xFFFFFF);
		_selectedMark.graphics.drawRect(0, 0, size.x, size.y);
		addChild(_selectedMark);
		_selectedMark.visible = false;
		_selectedMark.mouseEnabled = false;
		_selectedMark.mouseChildren = false;

		addEventListener(MouseEvent.ROLL_OVER, __overHandler);
		addEventListener(MouseEvent.ROLL_OUT, __outHandler);
		addEventListener(MouseEvent.MOUSE_MOVE, __moveHandler);
		addEventListener(MouseEvent.CLICK, __clickHandler);
	}

	/**
	 * 设置默认颜色
	 * @param color
	 */
	public function setDefaultColor(color : uint) : void {
		var index : int = _colors.indexOf(color);
		var xIndex : int = index % _xCount;
		var yIndex : int = index / _xCount;
		
		_selectedMark.visible = true;
		_selectedMark.x = xIndex * _size.x;
		_selectedMark.y = yIndex * _size.y;
	}

	/**
	 * 开始绘制
	 */
	private function create() : void {
		this.graphics.lineStyle(1, 0x000000);
		for (var j : int = 0; j < _yCount; j++) {
			for (var i : int = 0; i < _xCount; i++) {
				var index : int = _xCount * j + i;
				if (_colors.length <= index) {
					return;
				}
				var color : uint = _colors[index];
				this.graphics.beginFill(color);
				this.graphics.drawRect(i * _size.x, j * _size.y, _size.x, _size.y);
				this.graphics.endFill();
			}
		}
	}

	private function __overHandler(e : MouseEvent) : void {
		_selectMark.visible = true;
	}

	private function __outHandler(e : MouseEvent) : void {
		_selectMark.visible = false;
	}

	/**
	 * 移动鼠标
	 * @param e
	 */
	private function __moveHandler(e : MouseEvent) : void {
		var xIndex : int = e.localX / (_size.x);
		var yIndex : int = e.localY / (_size.y);

		_selectMark.x = xIndex * _size.x;
		_selectMark.y = yIndex * _size.y;
	}

	/**
	 * 点击鼠标
	 * @param e
	 */
	private function __clickHandler(e : MouseEvent) : void {
		var xIndex : int = e.localX / (_size.x);
		var yIndex : int = e.localY / (_size.y);
		var index : int = _xCount * yIndex + xIndex;
		var color : uint = _colors[index];

		dispatchEvent(new ColorPikerEvent(ColorPikerEvent.SELECT_COLOR, color, index));
	}

	/**
	 * 销毁
	 */
	public function dispose() : void {
		removeEventListener(MouseEvent.ROLL_OVER, __overHandler);
		removeEventListener(MouseEvent.ROLL_OUT, __outHandler);
		removeEventListener(MouseEvent.MOUSE_MOVE, __moveHandler);
		removeEventListener(MouseEvent.CLICK, __clickHandler);

		STool.clear(this);
		_colors = null;
	}

}
}
