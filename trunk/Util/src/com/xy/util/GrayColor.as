package com.xy.util {
	import flash.filters.ColorMatrixFilter;

/**
 * @author xy
 * @create 2012-5-26 下午03:08:32
 */
public class GrayColor {
	public static const value : Array = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0,
		0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];

}
}
