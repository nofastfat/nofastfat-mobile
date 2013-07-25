package com.xy.utils {

/**
 * 牌型判断及大小判定
 * 关于赖子（百搭牌）：
 * 抽取出的百搭牌能作为2-A任何牌使用。
 * 在有百搭牌的牌型中，同时可作为两种牌型的取大的一种。
 * 例：KK66百搭，判断为KKK66。KKK6百搭，判断为KKKK6
 * 百搭牌可作为炸弹使用
 * 出单张或四张张百搭作为它本身的花色使用
 * @author xy
 */
public class PokerJudge {

	/**
	 * 识别一组牌的牌型
	 * @param pokers [PokerVo, PokerVo, ...]，待识别的多张牌
	 * @param evilPoints 当前的赖子的牌点，参考PokerPoints
	 * @return 可能的牌型数组[PokerGroupType, PokerGroupType, ...],不能识别则返回null
	 * @see PokerVo
	 * @see PokerPoints
	 * @see PokerGroupType
	 */
	public static function distinguishGroupType(pokers : Array, evilPoints : int) : Array {
		//TODO 识别一组牌的牌型 算法实现
		return null;
	}

	/**
	 * 智能找牌， 从sourcePoker中找出任意种比targetPokers要大的组合，可能是多种组合
	 * @param sourcePokers	待查找的源牌数组，一般是玩家当前手里的所有牌 [PokerVo, PokerVo, ...]
	 * @param targetPokers	用于比较的目标牌组 [PokerVo, PokerVo, ...]
	 * @param evilPoints	当前的赖子的牌点，参考PokerPoints
	 * @param targetGroupType	目标牌组的牌型，如果预先未识别，则为null
	 * @return [[pokers : Array, groupType:int], [pokers : Array, groupType:int], ...]
	 * 返回任意种比targetPokers要大的牌组及其牌型
	 */
	public static function findBiggerPokers(sourcePokers : Array, targetPokers : Array, evilPoints : int, targetGroupType : String = null) : Array {

		return null;
	}

	/**
	 * A组牌是否比B组牌要大
	 * @param aPokers A的一组牌，[PokerVo, PokerVo, ...]
	 * @param bPokers B的一组牌，[PokerVo, PokerVo, ...]
	 * @param evilPoints 当前的赖子的牌点，参考PokerPoints
	 * @param aGroupType A的牌型，如果预先未识别，则为null
	 * @param bGroupType B的排序，如果预先未识别，则为null
	 * @return A比B大，返回true,否则false
	 * @see PokerVo
	 * @see PokerPoints
	 * @see PokerGroupType
	 */
	public static function AIsBiggerThenB(aPokers : Array, bPokers : Array, evilPoints : int, aGroupType : String = null, bGroupType : String = null) : Boolean {
		//TODO 比较2组牌的大小，算法实现
		return false;
	}

	/**
	 * 对一组牌，按照牌型进行排序
	 * @param pokers 一组牌，[PokerVo, PokerVo, ...]
	 * @param evilPoints 当前的赖子的牌点，参考PokerPoints
	 * @param groupType 牌型
	 * @return 排序后的数组
	 * @see PokerVo
	 * @see PokerPoints
	 * @see PokerGroupType
	 */
	public static function sortByGroupType(pokers : Array, evilPoints : int, groupType : String) : Array {
		//TODO 牌型排序，算法实现，建议使用Array.sort();
		return pokers;
	}
}
}
