package com.xy.ui {
	import flash.display.Stage;
/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-11-8 下午3:23:33
 **/
public class SUIRoot {
	private static var _stage : Stage;
	
	public static function initStage(stage : Stage):void{
		_stage = stage;
	}
	
	public static function getStage():Stage{
		return _stage;
	}
	
}
}
