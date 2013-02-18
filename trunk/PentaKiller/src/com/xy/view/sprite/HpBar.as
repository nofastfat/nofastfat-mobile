package com.xy.view.sprite {
import com.xy.view.component.ScaleImage;

import starling.display.Image;
import starling.display.Sprite;

/**
 * 血条
 * @author xy
 */
public class HpBar extends Sprite {
	private var _bg : Image;
	private var _hp : ScaleImage;
	
	/**
	 * 创建一个HP条 
	 * @param width
	 * @param height
	 */	
	public function HpBar(width : int = 100, height : int = 5) {
		super();
		_bg = Assets.makeUI("hpBarBg", 1);
		_hp = Assets.makeScaleImage("hpBar", 1);
		
		_hp.x = _hp.y = 1;

		addChild(_bg);
		addChild(_hp);
		
		
		this.touchable = false;
	}

	/**
	 * 设置血量百分比
	 * @param value 0.8表示80%
	 */
	public function setPercent(value : Number) : void {
		_hp.setWidthPercent(value);
	}

	/**
	 * 设置当前HP
	 * @param currentHp
	 * @param maxHp
	 */
	public function setHp(currentHp : int, maxHp : int) : void {
		setPercent(currentHp / maxHp);
	}
}
}
