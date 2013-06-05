package com.xy.util {
import flash.utils.Dictionary;

/**
 * 单线程模式消息工厂
 * @author xy
 */
public class ThreadFactory {

	private var _dic : Dictionary = new Dictionary();

	/**
	 * 发送消息
	 * @param key
	 * @param executeFun
	 * @param params
	 */
	public function startSending(key : String, executeFun : Function, ... params) : void {
		if (!_dic.hasOwnProperty(key)) {
			_dic[key] = new SingleLogicThread();
		}
		params.unshift(executeFun);
		var thread : SingleLogicThread = _dic[key];
		thread.startSending.apply(null, params);
	}

	/**
	 * 检查是否可以发送 
	 * @param key
	 * @return 
	 */	
	public function canSending(key : String) : Boolean {
		if (!_dic.hasOwnProperty(key)) {
			return true;
		}

		var thread : SingleLogicThread = _dic[key];
		return thread.canSending;
	}

	/**
	 * 清理状态
	 * @param key
	 */
	public function clearSending(key : String) : void {
		var thread : SingleLogicThread = _dic[key];

		if (thread != null) {
			thread.clearSending();
		}
	}

	/**
	 * 获取发送的数据
	 * @param key
	 * @return
	 */
	public function getTmpData(key : String) : * {

		var thread : SingleLogicThread = _dic[key];

		if (thread != null) {
			return thread.tmpSendData;
		}

		return null;
	}

	public function dispose() : void {
		for (var key : String in _dic) {
			var thread : SingleLogicThread = _dic[key];
			thread.dispose();
		}

		_dic = new Dictionary();
	}
}
}
