package com.xy.view {
import com.xy.cmd.GameStartCmd;
import com.xy.interfaces.AbsMediator;
import com.xy.model.enum.DataConfig;
import com.xy.model.vo.HeroVo;
import com.xy.util.Cache;
import com.xy.util.Map;
import com.xy.view.event.NewUserPanelEvent;
import com.xy.view.sprite.NewUserPanel;
import com.xy.view.sprite.UILayer;

import starling.core.Starling;
import starling.events.Event;

/**
 * 新用户面板
 * @author xy
 */
public class NewUserPanelMediaor extends AbsMediator {
	public static const NAME : String = "NewUserPanelMediaor";

	/**
	 * 显示新用户面板
	 */
	public static const SHOW_NEW_USER_PANEL : String = "SHOW_NEW_USER_PANEL";

	private var _panel : NewUserPanel;

	public function NewUserPanelMediaor(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}


	override public function makeNoticeMap() : Map {
		var map : Map = new Map();

		map.put(SHOW_NEW_USER_PANEL, showNewUserPanel);

		return map;
	}

	private function showNewUserPanel() : void {
		if (_panel == null) {
			_panel = new NewUserPanel();
			_panel.addEventListener(NewUserPanelEvent.CREATE, __createNewHandler);
			_panel.addEventListener(NewUserPanelEvent.CANCEL, __cancelHandler);
		}

		_panel.showTo(ui);
	}

	private function __createNewHandler(e : Event) : void {
		var vo : HeroVo = new HeroVo();
		vo.gdcode = 0;
		vo.level = 1;
		vo.moveSpeed = 2.5 * DataConfig.SCALE * 2;
		vo.name = "英雄";
		vo.attackRadius = 24 * DataConfig.SCALE;
		vo.bodyRadius = 12 * DataConfig.SCALE;
		vo.atk = 10;
		vo.gainTime = 300;
		vo.maxHp = 100;
		vo.maxSp = 20;
		vo.exp = 0;
		vo.superModelTime = 10000;
		vo.userName = e.data as String;

		dataProxy.heroVo = vo;
		Starling.juggler.delayCall(sendNotification, .1, GameStartCmd.NAME);
		Cache.write(vo);
	}

	private function __cancelHandler(e : Event) : void {
		sendNotification(MenuMediator.SHOW_MAIN_MENU);
	}

	public function get ui() : UILayer {
		return viewComponent as UILayer;
	}
}
}
