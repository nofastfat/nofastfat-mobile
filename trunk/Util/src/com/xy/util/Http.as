package com.xy.util {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

/**
 * @author xy
 * 使用URLLoad请求数据
 * @create 2012-8-1 下午03:04:00
 */
public class Http {
	private var _loader : URLLoader;
	
	private var _call : Function
	
	/**
	 * 使用URLLoad请求数据
	 * @param url　请求的url地址
	 * @param call 回调函数， 回调模式:call(URLLoader.data);
	 * @param dataFormat 请求的数据模式
	 * @param params 允许带的参数
	 * @param method GET | POST
	 */	
	public function Http(url : String, call : Function, dataFormat : String = URLLoaderDataFormat.TEXT, params : URLVariables = null, method : String = URLRequestMethod.GET) {
		_loader = new URLLoader();
		_loader.dataFormat = dataFormat;
		_call = call;
		
		_loader.addEventListener(Event.COMPLETE, __httpOkHandler);
		_loader.addEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
		_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __errorHandler);
		
		var req : URLRequest = new URLRequest(url);
		req.method = method;
		if(params != null){
			req.data = params;
		}
		
		_loader.load(req);
	}
	
	private function __httpOkHandler(e : Event) : void {
		var data : * = _loader.data;
		_call(data);
		dispose();
	}
	
	private function __errorHandler(e : Event) : void {
		_call(null);
		dispose();
	}
	
	private function dispose() : void {
		_loader.removeEventListener(Event.COMPLETE, __httpOkHandler);
		_loader.removeEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
		_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, __errorHandler);
		_loader = null;
		_call = null;
	}
}
}
