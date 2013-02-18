package com.xy.model.vo {
import flash.geom.Point;
import flash.net.registerClassAlias;
import flash.utils.ByteArray;

public class MonsterVo extends BaseVo {
	/**
	 * 怪物的经验值 
	 */	
	public var worthExp :int;
	
	/**
	 * 怪物属性编号
	 */
	public var atcode : int;

	/**
	 * 自由巡逻半径，0表示不自动巡逻
	 */
	public var roamRadius : int;

	/**
	 * 警戒攻击范围
	 * 玩家进入该范围，则进入战斗状态
	 */
	public var warnAttackRadius : int;

	/**
	 * 怪物追击范围，
	 * 这个值应该大于  怪物警戒范围
	 * 怪物离开该范围，则脱离战斗状态
	 */
	public var pursueAttackRadius : int;

	/**
	 * 群落警戒范围
	 * 该范围内的友军被攻击，则进入战斗状态
	 */
	public var friendWarnRadius : int;

	/**
	 * 自由巡逻时的移动速度
	 */
	public var roamSpeed : int;

	/**
	 * 出生点的位置
	 */
	public var birthLocation : Point;

	public function MonsterVo() {
		super();
	}

	public function clone() : MonsterVo {
		registerClassAlias("MonsterVo", MonsterVo);
		var ba : ByteArray = new ByteArray();
		ba.writeObject(this);
		ba.position = 0;
		var vo : MonsterVo = ba.readObject();

		return vo;
	}
}
}
