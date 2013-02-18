package com.xy.view.event {
import starling.events.Event;

/**
 * 角色事件 
 * @author xy
 */
public class RoleEvent extends Event {
	/**
	 * 攻击动作 
	 */	
	public static const ATTACK_ACTION : String = "ATTACK_ACTION";
	
	/**
	 * 对话操作
	 * 参数: npc:Npc 
	 */	
	public static const TALK_ACTION : String = "TALK_ACTION";
	
	public static const CLICK_MONSTER : String = "CLICK_MONSTER";
	
	
	/**
	 * 死亡 
	 */	
	public static const DEAD : String = "DEAD";
	
	public function RoleEvent(type : String, bubbles : Boolean = false, data : Object = null) {
		super(type, bubbles, data);
	}
}
}
