package com.xy.model {

/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-20 上午10:17:48
 **/
public class DishDTO {
	/**
	 * 主键
	 */
	public var id : int;

	/**
	 * 菜品名字
	 */
	public var name : String;

	/**
	 * 菜品单价,单位：角
	 */
	public var price : int;

	/**
	 * 图片附件名称
	 */
	public var picture : String;

	/**
	 * 菜品状态 1-正常 0-失效
	 */
	public var state : int;

	/**
	 * 菜品rank
	 */
	public var rank : int;

	/**
	 * 创建时间
	 */
	public var timeCreated : Number;
	
	public function get priceStr():String{
		return price/10.0 + "元";
	}
}
}
