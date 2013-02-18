package com.xy.view.sprite {
import com.greensock.TweenMax;
import com.xy.model.enum.DataConfig;
import com.xy.view.event.GamingMenuEvent;

import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

/**
 * 游戏中菜单
 * @author xy
 */
public class GamingMenu extends Sprite {
	private var _goonBtn : Button;
	private var _backBtn : Button;
	private var _soundImg : Image;
	private var _soundSliderBg : Image;
	private var _soundSliderBtn : Image;

	private var _container : Sprite;

	public function GamingMenu() {
		super();
		_container = new Sprite();
		addChild(_container);

		_goonBtn = Assets.makeBtnUI("goonBtn", 1.5);
		_backBtn = Assets.makeBtnUI("backBtn", 1.5);
		_soundImg = Assets.makeUI("soundImg", 1.5);
		_soundSliderBg = Assets.makeUI("soundSliderBg", 1.5);
		_soundSliderBtn = Assets.makeUI("soundSliderBtn", 1.5);

		_container.addChild(_goonBtn);
		_container.addChild(_backBtn);
		_container.addChild(_soundImg);
		_container.addChild(_soundSliderBg);
		_container.addChild(_soundSliderBtn);

		_backBtn.y = 80;

		_soundImg.y = 160;

		_soundSliderBg.y = 160 + (_soundImg.height - _soundSliderBg.height) / 2;
		_soundSliderBg.x = _soundImg.width + 20;

		_soundSliderBtn.y = 160 + (_soundImg.height - _soundSliderBtn.height) / 2;
		_soundSliderBtn.x = _soundSliderBg.x + _soundSliderBg.width - _soundSliderBtn.width;


		_goonBtn.addEventListener(Event.TRIGGERED, __goonHandler);
		_backBtn.addEventListener(Event.TRIGGERED, __saveHandler);
	}

	private function __goonHandler(e : Event) : void {
		hide();
	}

	private function __saveHandler(e : Event) : void {
		hide(function() : void {
			dispatchEventWith(GamingMenuEvent.SAVE_EXIT);
		});
	}

	public function showTo(parent : Sprite) : void {
		_container.y = 200;
		_container.x = (DataConfig.WIDTH - _container.width) >> 1;
		addChildAt(Assets.mask4, 0);
		parent.addChild(this);
		_container.alpha = 1;
		TweenMax.from(_container, 0.3, {y: _container.y + 150, alpha: .1});
		
		PentaKiller.pause();
		
		SoundManager.play("panel");
	}

	public function hide(call : Function = null) : void {
		SoundManager.play("panel");
		TweenMax.to(_container, 0.2, {y: _container.y - 150, alpha: .1, onComplete: function() : void {
			removeFromParent();
			PentaKiller.run();
			if (call != null) {
				call();
			}
		}});
	}
}
}
