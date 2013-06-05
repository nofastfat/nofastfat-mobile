package com.xy.component {
import com.xy.util.STool;

import flash.display.Shape;

/**
 * 血条
 * @author xy
 */
public class SHpBar extends Shape {
	private var _maxHp : int;
	private var _hp : int;

	private var _w : int;
	private var _h : int;
	private var _border : Boolean;

	public function SHpBar(hp : int, maxHp : int, width : int = 100, height : int = 4, border : Boolean = true) {
		super();
		_w = width;
		_h = height;
		_border = border;
		_maxHp = maxHp;
		this.hp = hp;
	}

	/**
	 * 设置血量百分比
	 * @param per 0.8表示80%
	 */
	public function setPercent(per : Number) : void {
		if (per > 1) {
			per = 1;
		}

		if (per < 0) {
			per = 0
		}
		var color : uint = STool.makeColor(255 * (1 - per), 255 * per, 0);
		graphics.clear();
		graphics.beginFill(color);
		graphics.drawRect(1, 1, _w * per - 1, _h - 1);
		graphics.endFill();
		graphics.lineStyle(1, 0x1c1c1c);
		graphics.drawRect(0, 0, _w, _h);

	}
	
	public function setHp(hp : int, maxHp : int) : void {
		_hp = hp;
		_maxHp = maxHp;
		setPercent(_hp / _maxHp);
	}

	public function setWidth(width:int):void{
		_w = width;
		setPercent(_hp / _maxHp);
	}
	
	public function get hp() : int {
		return _hp;
	}

	public function set hp(value : int) : void {
		_hp = value;
		if(_maxHp == 0){
			_maxHp = 1;
		}
		setPercent(_hp / _maxHp);
	}

	public function get maxHp() : int {
		return _maxHp;
	}

	public function set maxHp(value : int) : void {
		_maxHp = value;
		setPercent(_hp / _maxHp);
	}


}
}
