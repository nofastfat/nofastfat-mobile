package com.xy.comunication {

/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-20 下午3:57:31
 **/
public class Protocal {
//	public static const PRE : String = "http://192.168.1.13/YummyServer/";
	public static const PRE : String = "http://192.168.1.250:8080/YummyServer/";
	
	/**
	 * ======================注册======================
		路径user/register
		参数
		name 用户名
		telephone 手机号
		gender 性别
		返回UserDTO说明注册成功，返回null说明注册失败 
	 */	
	public static const REGISTER : String = "user/register.action?name={0}&telephone={1}&gender={2}";
	
	
	/** 
	 * ======================登录======================
		路径user/login
		参数name 用户名
		返回UserDTO说明登录成功，返回null说明登录失败 
	 */	
	public static const LOGIN : String = "user/login.action?name={0}";
	
	/**
	 * ======================餐馆列表======================
		路径restaurant/list
		参数无
		返回RestaurantDTO数组 
	 */	
	public static const RESTAURANT_LIST : String = "restaurant/list.action";
	
	/**
	 * ======================我的本次点餐状态======================
		路径detail/my
		返回ReservationDetailDTO，如果返回空就是本次没有点餐 
	 */	
	public static const DETAIL_MY : String = "detail/my.action";
	
	/**
	 * ======================点餐状态======================
		路径reservation/state
		参数
		无参数
		返回ReservationDTO 
	 */	
	public static const RESERVATION_STATE : String = "reservation/state.action";
	
	/**
	 * ======================我的点餐退订======================
		路径detail/cancel
		参数
		reservationId 当前预约点餐id
		返回1-成功 0-失败 
	 */	
	public static const DETAIL_CANCEL : String = "detail/cancel.action?reservationId={0}";
	
	/**
	 * ======================点餐======================
		路径detail/order
		参数
		dishId 菜品id
		userId 我点的是谁的
		reservationId 当前的预约点餐id
		comment 备注
		返回ReservationDetailDTO说明点餐成功，如果返回空就是点餐失败 
	 */	
	public static const DETAIL_ORDER : String = "detail/order.action?dishId={0}&userId={1}&reservationId={2}&comment={3}";
	
	
	/**
	 * ======================后台餐馆及菜品列表======================
		路径admin/restaurant/list
		参数无
		返回RestaurantDTO数组 
	 */	
	public static const ADMIN_RESTAURANT_LIST : String = "admin/restaurant/list.action";
	
	/**
	 * ======================后台餐馆添加======================
		路径admin/restaurant/add
		参数
		name 餐馆名称
		telephone 餐馆电话，字符串可以填写多个电话
		address 餐馆地址
		返回1-添加成功 0-失败 
	 */	
	public static const ADMIN_RESTAURANT_ADD : String = "admin/restaurant/add.action?name={0}&telephone={1}&address={2}";
	
	/**
	 * ======================后台餐馆编辑======================
		路径admin/restaurant/add
		参数
		id 餐馆id
		name 餐馆名称
		telephone 餐馆电话，字符串可以填写多个电话
		address 餐馆地址
		返回1-编辑成功 0-失败 
	 */	
	public static const ADMIN_RESTAURANT_EDIT : String = "admin/restaurant/edit.action?id={0}&name={1}&telephone={2}&address={3}";
	
	/**
	 * ======================后台餐馆删除======================
		路径admin/restaurant/remove
		参数
		id 餐馆id
		返回1-删除成功 0-失败 
	 */	
	public static const ADMIN_RESTAURANT_REMOVE : String = "admin/restaurant/remove.action?id={0}";
	
	/**
	 * ======================后台菜品添加======================
		路径admin/dish/add
		参数
		name 菜品名称
		price 菜品单价 单位角
		restaurantId 所属餐馆id
		picture 图片
		返回1-添加成功 0-失败 
	 */	
	public static const ADMIN_DISH_ADD : String = "admin/dish/add.action?name={0}&price={1}&restaurantId={2}";
	
	/**
	 * ======================后台菜品编辑======================
		路径admin/dish/edit
		参数
		id 菜品id
		name 菜品名称
		price 菜品单价 单位角
		restaurantId 所属餐馆id
		picture 图片
		返回1-编辑成功 0-失败 
	 */	
	public static const ADMIN_DISH_EDIT : String = "admin/dish/edit.action?id={0}&name={1}&price={2}&restaurantId={3}";
	
	/**
	 * ======================后台菜品删除======================
		路径admin/dish/edit
		参数
		id 菜品id
		返回1-删除成功 0-失败 
	 */	
	public static const ADMIN_DISH_REMOVE : String = "admin/dish/remove.action?id={0}";
	
	/**
	 * ======================后台点餐状态预览======================
		路径admin/reservation/report
		参数无
		返回【0-ReservationDTO 1-ReservationDetailDTO数组】的数组 
	 */	
	public static const ADMIN_RESERVATION_REPORT : String = "admin/reservation/report.action";
	
	/**
	 * ======================后台点餐提交并锁定======================
		路径admin/reservation/commit
		参数
		reservationId 需要锁定的预约点餐id
		返回1说明提交成功 返回0说明失败 
	 */	
	public static const ADMIN_RESERVATION_COMMIT : String = "admin/reservation/commit.action?reservationId={0}";
	
	/**
	 *======================后台用户列表======================
		路径admin/user/list
		参数无
		一次性返回UserDTO数组 
	 */	
	public static const ADMIN_USER_LIST : String = "admin/user/list.action";
	
	/**
	 * ======================后台用户添加======================
		路径路径admin/user/add
		参数
		name 用户名
		telephone 手机号
		gender 性别
		返回UserDTO说明添加成功，返回null说明添加失败 
	 */	
	public static const ADMIN_USER_ADD : String = "admin/user/add.action?name={0}&telephone={1}&gender={2}";
	
	/**
	 * ======================后台用户编辑======================
		路径admin/user/edit
		参数
		id 用户id
		telephone 手机号
		gender 性别
		返回1说明编辑成功 0说明失败 理论上不会失败的 
	 */	
	public static const ADMIN_USER_EDIT : String = "admin/user/edit.action?id={0}&name={1}&telephone={2}&gender={3}";
	
	/**
	 * ======================后台用户删除======================
		路径admin/user/remove
		参数
		id 用户id
		返回1说明删除成功 0说明失败 理论上不会失败的 
	 */	
	public static const ADMIN_USER_REMOVE : String = "admin/user/remove.action?id={0}";
}
}
