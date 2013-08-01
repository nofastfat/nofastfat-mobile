package com.xy.model.enum {

public class AccountType {
	
	/**
	 * 系统管理员
	 */	
    public static const ADMIN : int = 1;
	
	/**
	 * 店主 
	 */	
    public static const SECOND_ADMIN : int = 2;
	
	/**
	 * 员工
	 */	
    public static const USERS : int = 3;
	
	public static function ToString(type : int):String{
		if(type == ADMIN){
			return "系统管理员";
		}else if(type == SECOND_ADMIN){
			return "店主";
		}else{
			return "员工";
		}
	}

}
}
