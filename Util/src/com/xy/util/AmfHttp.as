package com.xy.util {
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;

/**
 * 基于AMF的http请求， 
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-11-8 上午11:39:26
 **/
public class AmfHttp {
	private var _loader : URLLoader;
	
	private var _call : Function
	
	/**
	 * 基于AMF的http请求， 
	 * @param url
	 * @param call， function call(responseDto:*):void{}
	 * @param requestDto，发送到服务器的对象
	 */	
	public function AmfHttp(url : String, call : Function,requestDto : * = null) {
				
		_loader = new URLLoader();
		_loader.dataFormat = URLLoaderDataFormat.BINARY; 
		_call = call;
		
		_loader.addEventListener(Event.COMPLETE, __httpOkHandler);
		_loader.addEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
		_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __errorHandler);
		var req : URLRequest = new URLRequest();
		req.url = url
		req.method = URLRequestMethod.POST;
		
		if(requestDto != null){
			var ba : ByteArray = new ByteArray();
			ba.writeObject(requestDto);
			req.data = ba;
		}
		req.contentType = "application/octet-stream";
		_loader.load(req);
	}
	
	private function __httpOkHandler(e : Event) : void {
		var rsBa : ByteArray = _loader.data;
		if(rsBa != null){
			_call(rsBa.readObject());
		}else{
			_call(null);
		}
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
