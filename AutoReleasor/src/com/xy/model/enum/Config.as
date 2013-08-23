package com.xy.model.enum {

/**
 * 配置信息
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-8-22 下午03:12:57
 **/
public class Config {
	/**
	 * AS3项目的标识 
	 */	
	public static const ACTION_SCRIPT_PROPERTIES : String = ".actionScriptProperties";
	
	/**
	 * 库项目的标识 
	 */	
	public static const FLEX_LIB_PROPERTIES : String = ".flexLibProperties";
	
	/**
	 * 包含SWC的命令 
	 */	
	public static const INCLUDE_LIBRARIES : String = "-include-libraries";
	
	/**
	 * 输出命令 
	 */	
	public static const OUT_PUT : String = "-output";
	
	/**
	 * 共享编译命令 
	 */	
	public static const RSL : String = "-external-library-path";
	
	/**
	 * 静态库命令 
	 */	
	public static const STATIC_RSLS : String = "-static-link-runtime-shared-libraries";
	
	/**
	 * 包含其他目录编译 
	 */	
	public static const SOURCE_PATH : String = "-source-path";
}
}
