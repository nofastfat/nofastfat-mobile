package com.xy.model {

/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-20 上午10:14:05
 **/
public class UserDTO {
	/**
	 * 主键
	 */
	public var id : int;

	/**
	 * 账户 使用用户的姓名的MD5来做
	 */
	public var passport : String;

	/**
	 * 用户姓名
	 */
	public var name : String;

	/**
	 * 手机号码
	 */
	public var telephone : String;

	/**
	 * 性别，1-男，2-女
	 */
	public var gender : int;

	/**
	 * 生日
	 */
	public var birthday : Number;

	/**
	 * 状态 1-正常,0-删除
	 */
	public var state : int;

	/**
	 * 创建日期
	 */
	public var timeCreated : int;
}
}
