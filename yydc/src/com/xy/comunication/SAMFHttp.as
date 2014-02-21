package com.xy.comunication {

import com.xy.comunication.Protocal;
import com.xy.util.Http;
import com.xy.util.STool;

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
public class SAMFHttp {
	private var _loader : URLLoader;

	private var _call : Function

	/**
	 * 基于AMF的http请求，
	 * @param url
	 * @param call， function call(responseDto:*):void{}
	 * @param requestDto，发送到服务器的对象
	 */
	public function SAMFHttp(protocal : String, call : Function, params : Array = null, hasImg : Boolean = false) {
		if (params == null) {
			params = [];
		}

		var ba : ByteArray;
		if(hasImg){
			ba = params.pop();
		}
		
		params.splice(0, 0, protocal);
		var url : String = Protocal.PRE + STool.format.apply(null, params);
		_call = call;

		var uri : String;
		var ps : String;
		var vars : URLVariables;
		
		var method : String = "GET";
		var useBa : Boolean = false;

		if (url.indexOf("?") == -1) {
			uri = url;
		} else {
			uri = url.substr(0, url.indexOf("?"));
			ps = url.substr(url.indexOf("?") + 1);
			vars = new URLVariables(ps);
			
			if(ba != null){
				vars.picture = ba;
			}
		}
		
		if(hasImg){
			method = "POST";
			useBa = true;
		}

		if(vars == null){
			uri += "?r=" + Math.random();
		}else{
			vars.r = Math.random();
		}
		
		new Http(uri, function(rsBa : ByteArray) : void {
			if (rsBa != null && rsBa.bytesAvailable != 0) {
				_call(rsBa.readObject());
			} else {
				_call(null);
			}
		}, URLLoaderDataFormat.BINARY, vars, method, useBa);
	}

	private function __httpOkHandler(e : Event) : void {
		var rsBa : ByteArray = _loader.data;
		if (rsBa != null) {
			_call(rsBa.readObject());
		} else {
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
