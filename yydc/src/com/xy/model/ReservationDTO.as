package com.xy.model {

/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-20 下午6:32:11
 **/
public class ReservationDTO {

	/**
	 * 主键
	 */
	public var id : int;

	/**
	 * 预约点餐日期
	 */
	public var reservationTime : Number;

	/**
	 * 预约订餐类型1-早餐 2-中餐 3-晚餐
	 */
	public var type : int;

	/**
	 * 状态 0-已作废 1-接受预约 9-已封存
	 */
	public var state : int;

	/**
	 * 预约订单创建时间
	 */
	public var timeCreated : Number;

	/**
	 * 订单封存时的总金额
	 */
	public var amount : int;

	/**
	 * 预约订单结束时间
	 */
	public var timeFinished : int;
}
}
