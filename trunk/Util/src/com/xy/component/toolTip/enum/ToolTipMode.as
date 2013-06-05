package com.xy.component.toolTip.enum {

public class ToolTipMode {

	/**
	 * 自由显示，TIP显示的位置是鼠标事件触发时的位置 
	 */	
	public static const FREE : int = 0;
	
	/**
	 * TIP显示在事件源的左边正中的位置,即f的位置
	 * <pre>下图为事件源的位置矩阵，设a点为事件源的注册点
	 * a b c
	 * d e f
	 * e h i
	 * <pre>
	 */	
	public static const RIGHT_BOTTOM_CENTER : int = 1; 
	
	/**
	 * TIP显示在事件源的注册点,即a的位置
	 * <pre>下图为事件源的位置矩阵，设a点为事件源的注册点
	 * a b c
	 * d e f
	 * e h i
	 * <pre>
	 */	
	public static const LEFT_TOP : int = 2;
	
	/**
	 * TIP显示在事件源的注册点,右上的位置,即c的位置
	 * <pre>下图为事件源的位置矩阵，设a点为事件源的注册点
	 * a b c
	 * d e f
	 * e h i
	 * <pre>
	 */	
	public static const RIGHT_TOP : int = 3;
}
}
