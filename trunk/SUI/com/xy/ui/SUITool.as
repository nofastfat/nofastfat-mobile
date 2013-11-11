package com.xy.ui {

/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-11-11 上午11:27:45
 **/
public class SUITool {
	public static function skipNull(str : String) : String {
		if (str == null || str == "") {
			return "";
		} else {
			return str;
		}
	}
}
}
