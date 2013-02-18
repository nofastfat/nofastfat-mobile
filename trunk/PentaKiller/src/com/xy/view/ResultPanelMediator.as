package com.xy.view {
import com.xy.cmd.SwitchMapCmd;
import com.xy.interfaces.AbsMediator;
import com.xy.model.vo.ResultVo;
import com.xy.util.Map;
import com.xy.view.sprite.ResultPanel;
import com.xy.view.sprite.UILayer;

import flash.utils.getTimer;

import starling.core.Starling;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * 结算面板
 * @author xy
 */
public class ResultPanelMediator extends AbsMediator {
	public static const NAME : String = "ResultPanelMediator";

	/**
	 * 显示结算面板
	 * vo:ResultVo
	 */
	public static const SHOW_RESULT_PANEL : String = NAME + "SHOW_RESULT_PANEL";

	private var _resultPanel : ResultPanel;
	private var _showTime : int;

	public function ResultPanelMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}

	override public function makeNoticeMap() : Map {
		var map : Map = new Map();

		map.put(SHOW_RESULT_PANEL, showResultPanel);

		return map;
	}

	private function showResultPanel(vo : ResultVo = null) : void {
		if (_resultPanel == null) {
			_resultPanel = new ResultPanel();
		}

		_showTime = getTimer();

		if (vo != null) {
			_resultPanel.setStarLevel(vo.starLevel);
			_resultPanel.setRewards(vo.rewards);
			_resultPanel.setComplete(true);
		} else {
			_resultPanel.setStarLevel(0);
			_resultPanel.setRewards([]);
			_resultPanel.setComplete(false);
		}
		_resultPanel.showTo(ui);
		ui.addEventListener(TouchEvent.TOUCH, __touchHandler);
	}

	private function __touchHandler(e : TouchEvent) : void {
		var touch : Touch = e.touches[0];
		if (touch.phase == TouchPhase.ENDED) {
			if (getTimer() - _showTime > 500) {
				_resultPanel.hide(function() : void {
					Starling.juggler.delayCall(sendNotification, .1, SwitchMapCmd.NAME, 70001);
				});
				ui.removeEventListener(TouchEvent.TOUCH, __touchHandler);
			}
		}
	}

	public function get ui() : UILayer {
		return viewComponent as UILayer;
	}
}
}
