package com.xy.util {
import flash.display.Stage;
import flash.events.Event;

/**
 * 基于EnterFrame的帧处理
 * @author xy
 */
public class EnterFrameCall {

	/**
	 * 是否已经初始化stage
	 */
	private static var _isInit : Boolean = false;

	/**
	 * stage，对其监听EnterFrame事件
	 */
	private static var _stage : Stage;

	/**
	 * 缓存的所有回调函数
	 * 跟据需要，应该清理部分回调，否则存储内存泄漏的隐患
	 */
	private static var _calls : Array = [];

	/**
	 * 是否暂停
	 */
	private static var _isPaused : Boolean;

	/**
	 * 初始化Stage
	 * @param stage
	 */
	public static function initState(stage : Stage) : void {
		if (_isInit) {
			return;
		}

		_stage = stage;
		_isInit = true;

		_stage.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
	}

	public static function pause() : void {
		_isPaused = true;
	}

	public static function run() : void {
		_isPaused = false;
	}

	/**
	 * 添加一个基于帧的方法
	 * 重复添加将无效
	 * @param fun 要求不带任何参数
	 */
	public static function add(fun : Function) : void {
		if (fun != null && !exist(fun)) {
			_calls.push(fun);
		}
	}

	/**
	 * 删除指定的回调
	 * 不使用本方法将导致内存泄漏
	 * @param fun
	 */
	public static function del(fun : Function) : void {
		var index : int = _calls.indexOf(fun);
		if (fun == null || index == -1) {
			return;
		}
		_calls.splice(index, 1);
	}

	public static function getStage() : Stage {
		return _stage;
	}

	/**
	 * 是否存在指定的fun
	 * @param fun
	 * @return
	 */
	private static function exist(fun : Function) : Boolean {
		return _calls.indexOf(fun) != -1;
	}

	/**
	 * 集中处理EnterFrame事件
	 * @param e
	 */
	private static function __enterFrameHandler(e : Event) : void {
		if (_isPaused) { 
			return;
		}

		for each (var fun : Function in _calls) {
			fun();
		}

		e.stopPropagation();
	}
}
}
