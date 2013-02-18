package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.ISimpleMediator;
import com.xy.model.ConfigXml;
import com.xy.model.enum.Action;
import com.xy.model.enum.DataConfig;
import com.xy.model.vo.MonsterVo;
import com.xy.util.Map;
import com.xy.util.Tools;
import com.xy.view.event.RoleEvent;
import com.xy.view.roles.Monster;
import com.xy.view.sprite.HpBar;
import com.xy.view.sprite.RoleLayer;

import flash.geom.Point;

import starling.events.Event;

/**
 * 怪物资源管理器<br>
 * 处理怪物的 添加、删除、移动
 * @author xy
 */
public class MonsterMediator extends AbsMediator implements ISimpleMediator {
	public static const NAME : String = "MonsterMediator";

	/**
	 * 添加一个怪物<br>
	 */
	public static const INIT_MONSTERS : String = NAME + "INIT_MONSTERS";

	/**
	 * 清空场景上的怪物
	 */
	public static const CLEAR_MONSTERS : String = NAME + "CLEAR_MONSTERS";

	public function MonsterMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);

	}

	override public function onRegister() : void {
	}

	override public function makeNoticeMap() : Map {
		var map : Map = new Map();
		map.put(INIT_MONSTERS, initMonsters);
		map.put(CLEAR_MONSTERS, clearMonsters);

		return map;
	}

	/**
	 * 初始化怪物
	 */
	private function initMonsters() : void {
		var mons : Array = dataProxy.currentMap.monsters;
		var monsterId : int = -1;
		for (var atcode : int in mons) {
			var vo : MonsterVo = ConfigXml.getMonster(atcode);
			var count : int = mons[atcode];
			for (var i : int = 0; i < count; i++) {
				var cloneVo : MonsterVo = vo.clone();
				var location : Point = new Point(
					Tools.random(100, dataProxy.currentMap.width - 100), 
					Tools.random(100, dataProxy.currentMap.height - 100)
				);
				cloneVo.birthLocation = location;
				addMonster(cloneVo, monsterId);
				monsterId--;
			}
		}
	}

	/**
	 * 添加一个怪物
	 * @param vo
	 */
	private function addMonster(vo : MonsterVo, id : int) : void {
		var monster : Monster = new Monster(vo, id);
		ui.addChild(monster);
		monster.x = vo.birthLocation.x;
		monster.y = vo.birthLocation.y;
		dataProxy.addMonster(monster);
		monster.addEventListener(RoleEvent.CLICK_MONSTER, __clickHandler);
		monster.addEventListener(Action.ATTACK, __attackHandler);
		monster.addEventListener(RoleEvent.DEAD, __deadHandler);
	}

	private function clearMonsters() : void {
		for each (var monster : Monster in dataProxy.liveMonsters) {
			monster.dispose();
		}
		dataProxy.liveMonsters = [];
	}

	private function __clickHandler(e : Event) : void {
		var monster : Monster = e.currentTarget as Monster;
		sendNotification(HeroMediator.LOCK_MONSTER, monster);
	}

	/**
	 * 怪物攻击人
	 * @param e
	 */
	private function __attackHandler(e : Event) : void {
		var monster : Monster = e.currentTarget as Monster;
		sendNotification(JudgeMediator.MONSTER_ATTACK, monster);
	}

	/**
	 * 这个怪物死了
	 * @param e
	 */
	private function __deadHandler(e : Event) : void {
		var monster : Monster = e.currentTarget as Monster;
		
		dataProxy.delMonster(monster.id);
		
		sendNotification(JudgeMediator.MONSTER_DEAD, monster);
		
		monster.removeEventListener(RoleEvent.CLICK_MONSTER, __clickHandler);
		monster.removeEventListener(Action.ATTACK, __attackHandler);
		monster.removeEventListener(RoleEvent.DEAD, __deadHandler);
		monster.dispose();
	}

	public function get ui() : RoleLayer {
		return viewComponent as RoleLayer;
	}
}
}
