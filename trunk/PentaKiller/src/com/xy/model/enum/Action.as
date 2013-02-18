package com.xy.model.enum {
	import com.xy.util.Map;

/**
 * 动作常量
 * @author xy
 */
public class Action {
	/**
	 * 站着不动
	 */
	public static const STAND : String = "Stand";
	
	/**
	 * 走路
	 */
	public static const WALK : String = "Walk";
	
	/**
	 * 跑
	 */
	public static const RUN : String = "Run";
	
	/**
	 * 跳跃
	 */
	public static const JUMP : String = "Jump";
	
	/**
	 * 攻击1
	 */
	public static const ATTACK : String = "Attack";
	
	/**
	 * 攻击1
	 */
	public static const ATTACK1 : String = "Attack1";
	
	/**
	 * 攻击2
	 */
	public static const ATTACK2 : String = "Attack2";
	
	/**
	 * 攻击3
	 */
	public static const ATTACK3 : String = "Attack3";
	
	/**
	 * 攻击4
	 */
	public static const ATTACK4 : String = "Attack4";
	
	/**
	 * 被攻击
	 */
	public static const HIT : String = "Hit";
	
	/**
	 * 死亡
	 */
	public static const DIE : String = "Die";
	
	/**
	 * 判断动作是否需要循环播放 
	 * @param action
	 * @return 
	 */	
	public static function actionCanLoop(action : String) : Boolean{
		switch(action){
			case Action.ATTACK:
			case Action.ATTACK1:
			case Action.ATTACK2:
			case Action.ATTACK3:
			case Action.ATTACK4:
			case Action.DIE:
			case Action.HIT:
			case Action.JUMP:
				
				return false;
			case Action.RUN:
			case Action.STAND:
			case Action.WALK:
				return true;
				break;
		}
		
		return false;
	}
	
}
}
