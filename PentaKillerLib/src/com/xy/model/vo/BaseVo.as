package com.xy.model.vo {

/**
 * 角色数据
 * @author xy
 */
public class BaseVo {
	
	/**
	 * 美术资源编号
	 */
	public var gdcode : int;
	
	/**
	 * 等级 
	 */	
	public var level : int;
	
	/**
	 * 名字
	 */
	public var name : String;
	
	/**
	 * 移动速度 
	 */	
	public var moveSpeed : Number;
	
	/**
	 * 攻击 半径
	 */	
	public var attackRadius : int;
	
	/**
	 * 角色身体大小半径
	 */	
	public var bodyRadius : int;
	
	/**
	 * 最大血量 
	 */	
	public var maxHp : int;
	
	/**
	 * 攻击力 
	 */	
	public var atk : int;
	
	/**
	 * 防御力 
	 */	
	public var defense : int;
	
	/**
	 * 攻击间隔，单位:ms 
	 */	
	public var attackLimitTime : int;
	
	/**
	 * 被击恢复时间 ，单位:ms 
	 */	
	public var gainTime : int;

}
}
