package com.xy.component.alert.enum {

/**
 * Alert消息框按钮类型
 * 确定按钮  | 取消按钮 | 创建按钮
 * 用法:
 * 	Alert.OK | Alert.CANCEL 表示确定+取消按钮
 * 	Alert.CREATE | Alert.CANCEL 表示创建+取消按钮
 * @author xy
 */
public class AlertType {

	/**
	 * 确定按钮
	 */
	public static const OK : int = 1;

	/**
	 * 取消按钮
	 */
	public static const CANCEL : int = 2;
	
}
}
