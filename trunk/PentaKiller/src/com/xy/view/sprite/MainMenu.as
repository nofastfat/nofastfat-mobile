package com.xy.view.sprite {
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.xy.view.event.MainMenuEvent;

import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

/**
 * 主菜单
 * @author xy
 */
public class MainMenu extends Sprite {
	private var _newGameBtn : Button;
	private var _continueGameBtn : Button;
	private var _settingBtn : Button;
	private var _bg : Image;

	private var _lastCtrl : Button;

	public function MainMenu() {
		super();
		_newGameBtn = Assets.makeBtnUI("newBtn");
		_continueGameBtn = Assets.makeBtnUI("loadBtn");
		_settingBtn = Assets.makeBtnUI("setBtn");
		_bg = Assets.makeUI("menuBg");

		addChild(_bg);
		addChild(_newGameBtn);
		addChild(_continueGameBtn);
		addChild(_settingBtn);

		_continueGameBtn.x = 27 * 2;
		_continueGameBtn.y = 169 * 2;
		_newGameBtn.x = 27 * 2;
		_newGameBtn.y = 218 * 2;
		_settingBtn.x = 27 * 2;
		_settingBtn.y = 265 * 2;

		_continueGameBtn.addEventListener(Event.TRIGGERED, __touchHandler);
		_newGameBtn.addEventListener(Event.TRIGGERED, __touchHandler);
		//_settingBtn.addEventListener(Event.TRIGGERED, __touchHandler);
	}

	/**
	 * 显示
	 */
	public function show() : void {
		_continueGameBtn.x = 27 * 2;
		_continueGameBtn.y = 169 * 2;
		_newGameBtn.x = 27 * 2;
		_newGameBtn.y = 218 * 2;
		_settingBtn.x = 27 * 2;
		_settingBtn.y = 265 * 2;

		var time : Number = 0.5;
		TweenMax.from(_continueGameBtn, time, {x: -_continueGameBtn.x - _continueGameBtn.width, ease: Back.easeOut});
		TweenMax.from(_newGameBtn, time, {delay: time * 0.3, x: -_newGameBtn.x - _newGameBtn.width, ease: Back.easeOut});
		TweenMax.from(_settingBtn, time, {delay: time * 0.6, x: -_settingBtn.x - _settingBtn.width, ease: Back.easeOut});
		
		SoundManager.play("mainMenu");
	}
	
	/**
	 * 是否有旧数据 
	 * @param hasOldUser
	 */	
	public function setOldUserState(hasOldUser : Boolean):void{
		_continueGameBtn.enabled = hasOldUser;
	}

	/**
	 * 隐藏
	 */
	public function hide() : void {
		var time : Number = 0.5;
		
		TweenMax.to(_continueGameBtn, time, {x: -_continueGameBtn.x - _continueGameBtn.width});
		TweenMax.to(_newGameBtn, time, {delay: time * 0.3, x: -_newGameBtn.x - _newGameBtn.width, onComplete: function() : void {
			removeFromParent();
			SoundManager.stop("mainMenu");
			switch (_lastCtrl) {
				case _continueGameBtn:
					dispatchEventWith(MainMenuEvent.CONTINUE_GAME);
					break;
				case _newGameBtn:
					dispatchEventWith(MainMenuEvent.NEW_GAME);
					break;
				case _settingBtn:
					dispatchEventWith(MainMenuEvent.SETTING);
					break;
			}
		}});
		TweenMax.to(_settingBtn, time, {delay: time * 0.6, x: -_settingBtn.x - _settingBtn.width});
	}

	/**
	 * 点击
	 * @param e
	 */
	private function __touchHandler(e : Event) : void {
		_lastCtrl = e.currentTarget as Button;
		hide();
		SoundManager.play("button");
	}
}
}
