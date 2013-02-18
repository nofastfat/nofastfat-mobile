package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.model.vo.ResultVo;
import com.xy.util.Map;
import com.xy.util.Tools;
import com.xy.view.roles.Hero;
import com.xy.view.roles.Monster;

import starling.core.Starling;
import starling.display.MovieClip;

/**
 * 伤害判定，计算 ，等
 * @author xy
 */
public class JudgeMediator extends AbsMediator {
	public static const NAME : String = "JudgeMediator";

	/**
	 * 玩家出攻击招数了，检查哪些怪物会被打到
	 * hero:Hero
	 */
	public static const HERO_ATTACK : String = NAME + "HERO_ATTACK";

	/**
	 * 怪物出击了
	 * monster:Monster
	 */
	public static const MONSTER_ATTACK : String = NAME + "MONSTER_ATTACK";

	/**
	 * 死一个怪物
	 * monster:Monster
	 */
	public static const MONSTER_DEAD : String = NAME + "MONSTER_DEAD";

	/**
	 * 玩家手动点击回到出生点
	 */
	public static const USER_WANT_BACK : String = NAME + "USER_WANT_BACK";

	public function JudgeMediator() {
		super(NAME);
	}

	override public function makeNoticeMap() : Map {
		var map : Map = new Map();
		map.put(HERO_ATTACK, heroAttack);
		map.put(MONSTER_ATTACK, monsterAttack);
		map.put(MONSTER_DEAD, monsterDead);
		map.put(USER_WANT_BACK, userWantBack);

		return map;
	}

	/**
	* 玩家出招了，检查哪些怪物会被打到
	* @param hero
	*/
	private function heroAttack(hero : Hero) : void {
		var attackedCount : int = 0;
		var monsters : Array = dataProxy.liveMonsters;
		
		var hasPlaySound : Boolean = false;
		for each (var monster : Monster in monsters) {
			if (Tools.ACanAttackB(hero, monster)) {
				/*显示被击动画*/
				var attackHit : Boolean = monster.underAttack(hero);
				
				/*飘被击伤害*/
				if (attackHit) {
					var hurt : int = Tools.calHurt(hero, monster);
					monster.setHurt(hurt);
					var currentMc : MovieClip = monster.currentShowMc;
					sendNotification(HurtShowMediator.SHOW_HURT, [hurt, -currentMc.width / 2 + monster.x, -currentMc.height + monster.y]);
					/*被击计数器*/
					attackedCount++;
					
					if(!hasPlaySound){
						hero.playAttackSound(true);
						hasPlaySound = true;
					}
				}
			}
		}

		if (attackedCount > 0) {
			sendNotification(GameMediator.SHAKE_STAGE);
			sendNotification(BatterMediator.HERO_ATTACK_HIT, attackedCount);
			
			/*人打怪物，增加1点SP*/
			sendNotification(HeroMediator.GET_SP, 1);
		}
		
		if(!hasPlaySound){
			hero.playAttackSound(false);
		}
	}

	/**
	 * 怪物出招
	 * @param monster
	 */
	private function monsterAttack(monster : Monster) : void {
		var hero : Hero = dataProxy.hero;
		if (Tools.ACanAttackB(monster, hero)) {
			var attackHit : Boolean = hero.underAttack(monster);
			if (attackHit) {
				SoundManager.play("heroUnderAttack1");
				var hurt : int = Tools.calHurt(monster, hero);
				hero.setHurt(hurt);
				sendNotification(UILayerMediator.HERO_INFO_UPDATE);
				var currentMc : MovieClip = hero.currentShowMc;
				sendNotification(HurtShowMediator.SHOW_HURT, [hurt, -currentMc.width / 2 + hero.x, -currentMc.height + hero.y]);
				
				/*人被打，增加2点SP*/
				sendNotification(HeroMediator.GET_SP, 2);
			}
		}
	}

	/**
	 * 死一个怪物
	 * @param monster
	 */
	private function monsterDead(monster : Monster) : void {
		sendNotification(HeroMediator.GET_EXP, monster.vO.worthExp);

		/*检查任务是否完成*/
		if (dataProxy.getMonsterCount() <= 0) {
			var vo : ResultVo = new ResultVo();
			vo.starLevel = 3;
			vo.rewards = dataProxy.currentMap.rewards;
			Starling.juggler.delayCall(sendNotification, 1, UILayerMediator.SHOW_TASK_RESULT, [true, vo]);
		}

	}

	private function userWantBack() : void {
		var isComplete : Boolean = dataProxy.getMonsterCount() <= 0;
		var vo : ResultVo;

		if (isComplete) {
			vo = new ResultVo();
			vo.starLevel = 3;
			vo.rewards = dataProxy.currentMap.rewards;
		}
		sendNotification(UILayerMediator.SHOW_TASK_RESULT, [isComplete, vo]);
	}
}
}
