package com.xy.view.sprite {
import com.xy.view.component.ScaleImage;
import com.xy.view.event.HeroInfoBarEvent;

import flash.events.PressAndTapGestureEvent;
import flash.geom.Rectangle;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.HAlign;
import starling.utils.VAlign;

/**
 * 玩家信息条
 * @author xy
 */
public class HeroInfoBar extends Sprite {
	private var _bg : Image;
	private var _hpBar : ScaleImage;
	private var _spBar : ScaleImage;
	private var _lvlTxt : TextField;
	private var _nameTxt : TextField;

	public function HeroInfoBar() {
		super();

		_bg = Assets.makeUI("heroInfoBar");
		_hpBar = Assets.makeScaleImage("heroHpBar");
		_spBar = Assets.makeScaleImage("heroSpBar");
		_lvlTxt = new TextField(35, 30, "", "ARKai", 20, 0xeedd00, true);
		_lvlTxt.vAlign = VAlign.TOP;
		_lvlTxt.hAlign = HAlign.CENTER;
		_nameTxt = new TextField(110, 22, "", "Verdana", 20, 0xFFFFFF, true);
		_nameTxt.vAlign = VAlign.TOP;
		_nameTxt.hAlign = HAlign.CENTER;
		_nameTxt.autoScale = true;


		addChild(_bg);
		addChild(_hpBar);
		addChild(_spBar);
		addChild(_lvlTxt);
		addChild(_nameTxt);

		_hpBar.x = 89.5;
		_hpBar.y = 39.5;
		_spBar.x = 81.5;
		_spBar.y = 55.5;
		_lvlTxt.x = 17;
		_lvlTxt.y = 58;
		_nameTxt.x = 95;
		_nameTxt.y = 18;
	}

	public function setLvl(level : int) : void {
		_lvlTxt.text = level + "";
	}

	public function setHp(percent : Number) : void {
		_hpBar.setWidthPercent(percent);

	}

	public function setName(name : String) : void {
		_nameTxt.text = name;
	}

	public function setSp(percent : Number) : void {
		_spBar.setWidthPercent(percent);


		if (percent == 1) {
			addEventListener(TouchEvent.TOUCH, __touchHandler);
		} else {
			removeEventListener(TouchEvent.TOUCH, __touchHandler);
		}
	}

	private function __touchHandler(e : TouchEvent) : void {
		var touch : Touch = e.touches[0];
		if (touch.phase == TouchPhase.ENDED) {
			dispatchEventWith(HeroInfoBarEvent.BE_SUPER_HERO);
			removeEventListener(TouchEvent.TOUCH, __touchHandler);
		}
	}
}
}
