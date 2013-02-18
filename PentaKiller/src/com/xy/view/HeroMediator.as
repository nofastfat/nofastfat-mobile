package com.xy.view {
import com.xy.cmd.GameOverCmd;
import com.xy.interfaces.AbsMediator;
import com.xy.model.enum.Action;
import com.xy.model.enum.DataConfig;
import com.xy.model.vo.HeroVo;
import com.xy.util.Map;
import com.xy.util.Tools;
import com.xy.view.event.RoleEvent;
import com.xy.view.roles.Hero;
import com.xy.view.roles.Monster;
import com.xy.view.roles.Npc;
import com.xy.view.sprite.RoleLayer;

import flash.geom.Point;

import starling.core.Starling;
import starling.events.Event;


public class HeroMediator extends AbsMediator {
	public static const NAME : String = "HeroMediator";

	public static const INIT_HERO : String = NAME + "INIT_HERO";

	/**
	 * 点击移动
	 */
	public static const MOVE_TO : String = NAME + "MOVE_TO";

	/**
	 * 执行攻击的动作
	 */
	public static const ATTACK_ACTION : String = NAME + "ATTACK_ACTION";

	/**
	 * 锁定某个怪物，开打
	 * monster:Monster
	 */
	public static const LOCK_MONSTER : String = NAME + "LOCK_MONSTER";

	/**
	 * 锁定某个NPC，交流
	 * npc:NPC
	 */
	public static const LOCK_NPC : String = NAME + "LOCK_NPC";

	public static const SHOW_HERO : String = NAME + "SHOW_HERO";

	public static const HIDE_HERO : String = NAME + "HIDE_HERO";

	/**
	 * 恢复HP
	 */
	public static const GAIN_HP : String = NAME + "GAIN_HP";

	/**
	 * 获得经验
	 * exp:int
	 */
	public static const GET_EXP : String = NAME + "GET_EXP";

	/**
	 * 获得SP
	 * sp:int
	 */
	public static const GET_SP : String = NAME + "GET_SP";

	public static const BE_SUPER_HERO : String = NAME + "BE_SUPER_HERO";

	private var _hero : Hero;

	public function HeroMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}

	override public function makeNoticeMap() : Map {
		var map : Map = new Map();
		map.put(MOVE_TO, lockPostion);
		map.put(ATTACK_ACTION, attack);
		map.put(LOCK_MONSTER, lockMonster);
		map.put(LOCK_NPC, lockNpc);
		map.put(INIT_HERO, initHero);
		map.put(SHOW_HERO, showHero);
		map.put(HIDE_HERO, hideHero);
		map.put(GAIN_HP, gainHero);
		map.put(GET_EXP, getExp);
		map.put(GET_SP, getSp);
		map.put(BE_SUPER_HERO, beSuperHero);
		return map;
	}

	public function initHero() : void {

		_hero = new Hero(dataProxy.heroVo);
		ui.addChild(_hero);
		_hero.x = 560;
		_hero.y = 390;

		sendNotification(UILayerMediator.HERO_INFO_UPDATE);

		_hero.addEventListener(Action.ATTACK1, __attackHandler);
		_hero.addEventListener(Action.ATTACK2, __attackHandler);
		_hero.addEventListener(Action.ATTACK3, __attackHandler);
		_hero.addEventListener(Action.ATTACK4, __attackHandler);
		_hero.addEventListener(RoleEvent.DEAD, __deadHandler);
		_hero.addEventListener(RoleEvent.TALK_ACTION, __talkHandler);

		dataProxy.hero = _hero;

		//test();
	}

	private function showHero() : void {
		ui.addChild(_hero);
		_hero.x = DataConfig.WIDTH >> 1;
		_hero.y = DataConfig.HEIGHT >> 1;
		_hero.reset();
	}

	private function hideHero() : void {
		if (_hero != null) {
			_hero.stopMove();
		}
		Tools.remove(ui, _hero);
	}

	/**
	 * 恢复HP
	 * -1表示全部回满
	 */
	private function gainHero(hp : int) : void {
		if (_hero == null) {
			return;
		}
		if (hp == -1) {
			_hero.currentHp = _hero.vo.maxHp;
		} else {
			_hero.currentHp += hp;
		}
	}

	/**
	 * 获得经验值
	 * @param exp
	 */
	private function getExp(exp : int) : void {
		if (_hero == null) {
			return;
		}

		_hero.VO.exp += exp;
		if (_hero.VO.exp >= 100) {
			_hero.VO.exp -= 100;
			_hero.VO.level++;
			_hero.playLevelUpMc();
			gainHero(-1);
			sendNotification(UILayerMediator.SHOW_LEVEL_TEXT);
		}

		sendNotification(UILayerMediator.HERO_INFO_UPDATE);
	}

	/**
	 * sp增加
	 * @param sp
	 */
	private function getSp(sp : int) : void {
		_hero.currentSp += sp;
		sendNotification(UILayerMediator.HERO_INFO_UPDATE);
	}

	/**
	 * 变身
	 */
	private function beSuperHero() : void {
		PentaKiller.pause();
		Loading.getInstance().showSuperHeroMc(function() : void {
			PentaKiller.run();
			_hero.superModel();
			_hero.currentSp = 0;

			Starling.juggler.delayCall(_hero.normalModel, _hero.VO.superModelTime / 1000);
		});

	}

	/**
	 * 执行移动 操作
	 * @param p
	 */
	private function lockPostion(p : Point) : void {
		_hero.lockPostion(p);
	}

	/**
	 * 执行攻击动作
	 */
	private function attack() : void {
		_hero.attack();
	}

	/**
	 * 锁定怪物
	 * @param montser
	 */
	private function lockMonster(montser : Monster) : void {
		_hero.lockRole(montser);
	}

	/**
	 * 锁定NPC
	 * @param npc
	 */
	private function lockNpc(npc : Npc) : void {
		_hero.lockRole(npc);
	}

	/**
	 * 攻击动作
	 * @param e
	 */
	private function __attackHandler(e : Event) : void {
		/*通知怪物Mediator检查*/
		sendNotification(JudgeMediator.HERO_ATTACK, _hero);
	}

	/**
	 * 死亡了
	 * @param e
	 */
	private function __deadHandler(e : Event) : void {
		sendNotification(GameOverCmd.NAME);
	}

	private function __talkHandler(e : Event) : void {
		var npc : Npc = e.data as Npc;
		npc.beenTalk(_hero);

		sendNotification(TalkMediator.SHOW_TALK_PANEL, npc.VO.name + ": " + npc.VO.word);
	}

	public function get ui() : RoleLayer {
		return viewComponent as RoleLayer;
	}
}
}
