package com.xy.model.enum {

/**
 * 多张牌型枚举
 * @author xy
 */
public class PokerGroupType {

	/**
	 * 单张
	 */
	public static const SINGLE : String = "SINGLE";

	/**
	 * 一对,对子
	 */
	public static const ONE_PAIR : String = "ONE_PAIR";

	/**
	 * 三张相同的牌
	 */
	public static const THREE_OF_A_KIND : String = "THREE_OF_A_KIND";

	/**
	 * 三张相同和一张牌
	 * 三带一
	 */
	public static const FULL_HOUSE_1 : String = "FULL_HOUSE_1";

	/**
	 * 三张相同和二张相同的牌
	 * 三带二
	 */
	public static const FULL_HOUSE : String = "FULL_HOUSE";

	/**
	 * 四张相同的牌
	 * 炸弹
	 */
	public static const FOUR_OF_A_KIND : String = "FOUR_OF_A_KIND";

	/**
	 * 四张相同的牌带2个单张
	 */
	public static const FOUR_OF_A_KIND_SINGLE : String = "FOUR_OF_A_KIND_SINGLE";
	
	/**
	 * 四张相同的牌带2个对子
	 */
	public static const FOUR_OF_A_KIND_DOUBLE : String = "FOUR_OF_A_KIND_DOUBLE";

	/**
	 * 2个王
	 * 火箭
	 */
	public static const DOUBLE_JOKER : String = "DOUBLE_JOKER";

	/**
	 * 顺子
	 * 单顺
	 */
	public static const STRAIGHT : String = "STRAIGHT";

	/**
	 * 双顺
	 */
	public static const DOUBLE_STRAIGHT : String = "DOUBLE_STRAIGHT";

	/**
	 * 三顺
	 */
	public static const TRIPLE_STRAIGHT : String = "TRIPLE_STRAIGHT";

	/**
	 * 单飞机
	 * 三顺带单张
	 */
	public static const TRIPLE_STRAIGHT_SINGLE : String = "TRIPLE_STRAIGHT_SINGLE";

	/**
	 * 双飞机
	 * 三顺带对子
	 */
	public static const TRIPLE_STRAIGHT_DOUBLE : String = "TRIPLE_STRAIGHT_DOUBLE";
}
}
