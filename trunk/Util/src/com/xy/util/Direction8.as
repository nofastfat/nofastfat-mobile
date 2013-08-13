package com.xy.util {

/**
 * 8方向
 * @author xy
 */
public class Direction8 {
	/**
	 * 右
	 */
	public static const RIGHT : int = 0;

	/**
	 * 右下
	 */
	public static const RIGHT_DOWN : int = 1;

	/**
	 * 下
	 */
	public static const DOWN : int = 2;

	/**
	 * 左下
	 */
	public static const LEFT_DOWN : int = 3;

	/**
	 * 左
	 */
	public static const LEFT : int = 4;

	/**
	 * 左上
	 */
	public static const LEFT_UP : int = 5;

	/**
	 * 上
	 */
	public static const UP : int = 6;

	/**
	 * 右上
	 */
	public static const RIGHT_UP : int = 7;


	/**
	 * 角度对应的方位
	 */
	private static const ANGLE_DIRECTION : Array = [
		[22.5, 67.5, RIGHT_DOWN],
		[67.5, 112.5, DOWN],
		[112.5, 157.5, LEFT_DOWN],
		[157.5, 202.5, LEFT],
		[202.5, 247.5, LEFT_UP],
		[247.5, 292.5, UP],
		[292.5, 337.5, RIGHT_UP]
		];

	/**
	 * 计算从一个点到另一个点的方向
	 * @param startX
	 * @param startY
	 * @param endX
	 * @param endY
	 * @return
	 */
	public static function fromPt(startX : Number, startY : Number, endX : Number, endY : Number) : int {
		var angle : Number = Math.atan2(endY - startY, endX - startX);
		angle = angle * 180 / Math.PI;
		angle = formatAngle(angle);

		for each (var arr : Array in ANGLE_DIRECTION) {
			if (arr[0] < angle && angle <= arr[1]) {
				return arr[2];
			}
		}

		return RIGHT;
	}

	/**
	 * 转换为0-360之间的度数
	 * @param angle
	 * @return
	 */
	private static function formatAngle(angle : Number) : Number {
		if (0 <= angle && angle < 360) {
			return angle;
		}

		if (angle < 0) {
			return formatAngle(angle + 360);
		}

		if (angle >= 360) {
			return formatAngle(angle - 360);
		}

		return angle;
	}
}
}
