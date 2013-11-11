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
	private static var _stageWidth : int = -1;
	private static var _stageHeight : int = -1;
	public static var IS_IOS : Boolean;

	public static function initStage(stage : Stage) : void {
		_stage = stage;
	}

	public static function get stage() : Stage {
		return _stage;
	}

	public static function get stageWidth() : int {
		if (_stageWidth == -1) {
			_stageWidth = _stage.stageWidth;
		}

		return _stageWidth;
	}

	public static function get stageHeight() : int {
		if (_stageHeight == -1) {
			_stageHeight = _stage.stageHeight;
		}

		return _stageHeight;
	}

	public static function scaleXBy(width : int) : Number {
		return stageWidth/width ;	}

	public static function scaleYBy(height : int) : Number {
		return stageHeight/height;
	}

}
}
