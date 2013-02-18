package com.xy.model.enum {
	import starling.utils.deg2rad;

/**
 * 方向
 * @author xy
 */
public class Direction {
	/**
	 * 左上
	 */
	public static const LU : String = "LU";

	/**
	 * 左下
	 */
	public static const LB : String = "LB";

	/**
	 * 右下
	 * 
	 */
	public static const RB : String = "RB";

	/**
	 * 右上
	 */
	public static const RU : String = "RU";
	
	/**
	 * 4个方向对应的弧度常量 
	 */	
	private static const LU_RAD : Number = deg2rad(225);
	private static const LB_RAD : Number = deg2rad(135);
	private static const RB_RAD : Number = deg2rad(45);
	private static const RU_RAD : Number = deg2rad(315);
	
	/**
	 * 将方向换算为对应的弧度 
	 * @param direction
	 * @return 
	 */	
	public static function toRad(direction : String) : Number {
		return Direction[direction.toUpperCase() + "_RAD"];
	}
}
}
