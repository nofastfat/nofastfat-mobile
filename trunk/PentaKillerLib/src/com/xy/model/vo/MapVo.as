package com.xy.model.vo {

/**
 * 地图数据
 * @author xy
 */
public class MapVo {
	public var id : int;
	public var name : String;

	/**
	 * 底层贴图数据
	 */
	public var underMapData : Array;

	/**
	 * 装饰层贴图数据
	 * [{gdcode:int,px:int,py:int}, {gdcode:int,px:int,py:int}, ...]
	 */
	public var mapDeckMapData : Array;

	/**
	 * 场景障碍数据
	 * [{gdcode:int,px:int,py:int}, {gdcode:int,px:int,py:int}, ...]
	 */
	public var baffleMapData : Array;

	/**
	 * NPC数据
	 * [{gdcode:int,px:int,py:int}, {gdcode:int,px:int,py:int}, ...]
	 */
	public var npcs : Array;

	/**
	 * 怪物刷新数据
	 * {atcode:count, atcode:count,... }
	 */
	public var monsters : Array;

	/**
	 * 奖励数组
	 * [RewardVo, RewardVo,...]
	 */
	public var rewards : Array;
	
	public var bgSoundName : String;


	public var width : int;
	public var height : int;
}
}
