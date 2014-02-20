package com.xy.model {

/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-18 下午3:36:12
 **/
public class Global {
	public static var root : yydc;
	
	public static var me : UserDTO;
	
	/**
	 * 是否是管理员 
	 */	
	public static var isAdmin:Boolean = false;
	
	public static function get userName():String{
		if(me != null){
			return me.name
		}
		
		return "";
	}
}
}
