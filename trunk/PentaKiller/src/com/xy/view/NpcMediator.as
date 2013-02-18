package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.model.ConfigXml;
import com.xy.model.enum.DataConfig;
import com.xy.model.vo.NpcVo;
import com.xy.util.Map;
import com.xy.view.roles.Npc;
import com.xy.view.sprite.RoleLayer;

import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/**
 * NPC
 * @author xy
 */
public class NpcMediator extends AbsMediator {
	public static const NAME : String = "NpcMediator";

	/**
	 * 初始化NPC
	 */
	public static const INIT_NPC : String = NAME + "INIT_NPC";

	public static const CLEAR_NPC : String = NAME + "CLEAR_NPC";

	public function NpcMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}

	override public function makeNoticeMap() : Map {
		var map : Map = new Map();

		map.put(INIT_NPC, initNpc);
		map.put(CLEAR_NPC, clearNpc);

		return map;
	}

	private function clearNpc() : void {
		for each (var npc : Npc in dataProxy.npcs) {
			npc.removeFromParent();
			npc.dispose();
		}

		dataProxy.npcs = [];
	}

	private function initNpc() : void {
		clearNpc();

		for each (var npcData : * in dataProxy.currentMap.npcs) {
			var vo : NpcVo = ConfigXml.getNpc(npcData.gdcode);
			vo.bodyRadius = 12 * DataConfig.SCALE;
			var npc : Npc = new Npc(vo);
			dataProxy.npcs.push(npc);
			ui.addChild(npc);
			npc.x = npcData.px;
			npc.y = npcData.py;

			npc.addEventListener(TouchEvent.TOUCH, __touchHandler);
		}

		if (npc != null) {
			npc.showNewTask();
		}
	}

	private function __touchHandler(e : TouchEvent) : void {
		var touch : Touch = e.touches[0];
		if (touch.phase == TouchPhase.MOVED || touch.phase == TouchPhase.ENDED) {
			var npc : Npc = e.currentTarget as Npc;
			sendNotification(HeroMediator.LOCK_NPC, npc);
		}
	}

	public function get ui() : RoleLayer {
		return viewComponent as RoleLayer;
	}
}
}
