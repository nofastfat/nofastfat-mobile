package com.xy.util {

/**
 * 协议只能以单线程模式运行，
 * 即不允许同时发多个 
 * @author xy
 */	
public class SingleLogicThread {
	/**
	 * 数据是否正在发送中 
	 */	
	private var _isSending : Boolean = false;
	
	/**
	 * 临时发送的数据 
	 */	
	private var _tmpSendData : *;

	/**
	 * 发送数据  
	 * @param executeFun
	 * @param params
	 */	
	public function startSending(executeFun : Function, ...params) : void {
		if(canSending){
			_isSending = true;
			_tmpSendData = params;
			executeFun.apply(null, params);
		}
	}
	
	/**
	 * 清除发送状态 
	 */	
	public function clearSending() : void{
		_isSending = false;
		_tmpSendData = null;
	}
	
	/**
	 * 是否能发送数据 
	 * @return 
	 */	
	public function get canSending() : Boolean{
		return !_isSending;
	}
	
	/**
	 * 发送的数据
	 * 就是...params 
	 * @return 
	 */	
	public function get tmpSendData() : * {
		return _tmpSendData;
	}
	
	public function dispose() : void {
		_tmpSendData = null;
	}
}
}
