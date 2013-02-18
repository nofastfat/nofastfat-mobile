package com.xy.view {
import com.xy.cmd.SwitchMapCmd;
import com.xy.interfaces.AbsMediator;
import com.xy.model.vo.MapVo;
import com.xy.util.EnterFrameCall;
import com.xy.util.Map;
import com.xy.view.event.PortalEvent;
import com.xy.view.roles.Hero;
import com.xy.view.sprite.MapThumb;
import com.xy.view.sprite.PortalPanel;
import com.xy.view.sprite.UILayer;

import starling.events.Event;

/**
 * 传送门 面板
 * @author xy
 */
public class PortalMediator extends AbsMediator {
	public static const NAME : String = "PortalMediator";
	
	public static const INTI_PORTAL : String = NAME + "INTI_PORTAL";
	public static const CLEAR_PORTAL : String = NAME + "CLEAR_PORTAL";

	/**
	 * 是否初始化
	 */
	private var _isInit : Boolean;

	private var _panel : PortalPanel;

	private var _enterFrameCount : int = 0;

	/**
	 * 是否可以触发面板的标识
	 */
	private var _hasLeftPortalRect : Boolean = true;

	public function PortalMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}

	private function hitTest() : void {
		/*是否踩到传送门*/
		if (_enterFrameCount % 10 == 0) {
			var hero : Hero = dataProxy.hero;
			var hitPortal : Boolean = dataProxy.portalRect.intersects(hero.bodyRect);
			if (hitPortal) {
				if (_hasLeftPortalRect) {
					showPortalPanel();
					_hasLeftPortalRect = false;
				}
			} else {
				_hasLeftPortalRect = true;
			}
		}

		_enterFrameCount++;
	}

	override public function makeNoticeMap() : Map {
		var map : Map = new Map();
		
		map.put(INTI_PORTAL, initPortal);
		map.put(CLEAR_PORTAL, clearPortal);
		
		return map;
	}

	private function initPortal() : void {
		if (dataProxy.portalRect != null) {
			EnterFrameCall.add(hitTest);
		}
	}
	
	private function clearPortal() : void {
		dataProxy.portalRect = null;
		EnterFrameCall.del(hitTest);
	}

	private function showPortalPanel() : void {
		if (!_isInit) {
			initUI();
		}
		_panel.setTxt("选择一个副本");

		var conts : Array = [];
		for each(var vo : MapVo in dataProxy.mapList){
			var thumb : MapThumb = new MapThumb(vo);
			conts.push(thumb);
		}
		_panel.addContent(conts);
		_panel.showTo(ui);

	}

	/**
	 * 初始化UI
	 */
	private function initUI() : void {
		_panel = new PortalPanel();
		_isInit = true;
		_panel.addEventListener(PortalEvent.CHOOSE_MAP, __chooseHandler);
	}
	
	private function __chooseHandler(e : Event) : void {
		var vo : MapVo = e.data as MapVo;
		sendNotification(SwitchMapCmd.NAME, vo.id);
	}

	public function get ui() : UILayer {
		return viewComponent as UILayer;
	}
}
}
