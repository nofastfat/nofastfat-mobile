package com.xy.model {

/**
 * 餐馆数据类型
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-20 上午10:11:12
 **/
public class RestaurantDTO {
	/**
	 * 主键
	 */
	public var id : int;

	/**
	 * 餐馆名称
	 */
	public var name : String;

	/**
	 * 订餐电话
	 */
	public var telephone : String;

	/**
	 * 餐馆地址
	 */
	public var address : String;

	/**
	 * 状态 1-正常 0-失效
	 */
	public var state : int;

	/**
	 * 餐馆rank
	 */
	public var rank : int;

	/**
	 * 创建时间
	 */
	public var timeCreated : Number;


	/**
	 * 餐馆下面的菜品数组
	 */
	public var dishDTOs : Array;
}
}
