package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.util.Map;
import com.xy.view.sprite.TalkPanel;
import com.xy.view.sprite.UILayer;

import flash.utils.getTimer;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * 对话面板
 * @author xy
 */
public class TalkMediator extends AbsMediator {
	public static const NAME : String = "TalkMediator";

	/**
	 * 对话内容
	 * 显示对话面板
	 */
	public static const SHOW_TALK_PANEL : String = "SHOW_TALK_PANEL";

	/**
	 * 是否初始化
	 */
	private var _isInit : Boolean;

	/**
	 * 面板
	 */
	private var _talkPanel : TalkPanel;

	private var _showTime : int;

	public function TalkMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}

	override public function makeNoticeMap() : Map {
		var map : Map = new Map();

		map.put(SHOW_TALK_PANEL, showTalkPanel);

		return map;
	}

	/**
	 * 初始化UI
	 */
	private function initUI() : void {
		_talkPanel = new TalkPanel();
		_isInit = true;
	}

	/**
	 * 显示对话面板
	 */
	private function showTalkPanel(word : String) : void {
		if (!_isInit) {
			initUI();
		}

		_showTime = getTimer();
		_talkPanel.setTxt(word);
		_talkPanel.showTo(ui);
		ui.addEventListener(TouchEvent.TOUCH, __touchHandler);
	}

	private function __touchHandler(e : TouchEvent) : void {
		var touch : Touch = e.touches[0];
		if (touch.phase == TouchPhase.ENDED) {
			if (getTimer() - _showTime > 500) {
				_talkPanel.hide();
				ui.removeEventListener(TouchEvent.TOUCH, __touchHandler);
			}
		}
	}

	public function get ui() : UILayer {
		return viewComponent as UILayer;
	}
}
}
