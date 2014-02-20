package com.xy.model {

/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-20 下午6:33:18
 **/
public class ReservationDetailDTO {
	/**
	 * 主键
	 */
	public var id : int;

	/**
	 * 下单人的用户
	 */
	public var userDTO : UserDTO;
	/**
	 * 操作人 外键。如果是代点，操作人和下单人是不一样的
	 */
	public var operatorDTO : UserDTO;

	/**
	 * 菜品
	 */
	public var dishDTO : DishDTO;

	/**
	 * 预约点餐
	 */
	public var reservationDTO : ReservationDTO;

	/**
	 * 本次菜品评价
	 */
	public var rank : int;

	/**
	 * 更新时间
	 */
	public var timeUpdated : Number;
}
}
