package com.xy.view {
import com.xy.cmd.GameStartCmd;
import com.xy.interfaces.AbsMediator;
import com.xy.model.vo.HeroVo;
import com.xy.util.Cache;
import com.xy.util.Map;
import com.xy.view.event.MainMenuEvent;
import com.xy.view.sprite.MainMenu;
import com.xy.view.sprite.UILayer;

import flash.utils.getTimer;

import starling.events.Event;

/**
 * MENU
 * @author xy
 */
public class MenuMediator extends AbsMediator {
	public static const NAME : String = "MenuMediator";

	public static const INIT_MAIN_MENU : String = NAME + "INIT_MAIN_MENU";
	public static const SHOW_MAIN_MENU : String = NAME + "SHOW_MAIN_MENU";

	private var _menu : MainMenu;

	private var _lastCtrlTime : int;

	public function MenuMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}

	override public function makeNoticeMap() : Map {
		var map : Map = new Map();

		map.put(INIT_MAIN_MENU, initMainMenu);
		map.put(SHOW_MAIN_MENU, showMainMenu);

		return map;
	}

	public function initMainMenu() : void {
		_menu = new MainMenu();
		_menu.addEventListener(MainMenuEvent.CONTINUE_GAME, __continueGameHandler);
		_menu.addEventListener(MainMenuEvent.NEW_GAME, __newGameHandler);
		_menu.addEventListener(MainMenuEvent.SETTING, __settingHandler);
	}

	private function showMainMenu() : void {
		var vo : HeroVo = Cache.read() as HeroVo;
		dataProxy.heroVo = vo;
		_menu.setOldUserState(vo != null);
		
		ui.addChild(_menu);
		_menu.show();
	}

	private function __continueGameHandler(e : Event) : void {
		if (getTimer() - _lastCtrlTime > 1000) {
			sendNotification(GameStartCmd.NAME);
			_lastCtrlTime = getTimer();
		}
	}

	private function __newGameHandler(e : Event) : void {
		if (getTimer() - _lastCtrlTime > 1000) {
			if(dataProxy.heroVo == null){
				sendNotification(NewUserPanelMediaor.SHOW_NEW_USER_PANEL);
			}else{
				sendNotification(NewUserPanelMediaor.SHOW_NEW_USER_PANEL);
			}
			_lastCtrlTime = getTimer();
		}
	}

	private function __settingHandler(e : Event) : void {
		if (getTimer() - _lastCtrlTime > 1000) {
			sendNotification(GameStartCmd.NAME);
			_lastCtrlTime = getTimer();
		}
	}

	public function get ui() : UILayer {
		return viewComponent as UILayer;
	}
}
}
