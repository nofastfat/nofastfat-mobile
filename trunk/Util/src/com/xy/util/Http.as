package com.xy.util {
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.ByteArray;

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
	public function Http(url : String, call : Function, dataFormat : String = "text", params : URLVariables = null, method : String = "GET", useByteArrayForPost:Boolean = false) {
		_loader = new URLLoader();
		_loader.dataFormat = dataFormat;
		_call = call;

		_loader.addEventListener(Event.COMPLETE, __httpOkHandler);
		_loader.addEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
		_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __errorHandler);

		var req : URLRequest;
		if (method == "GET" || !useByteArrayForPost) {
			req = new URLRequest(url);
			req.method = method;
			if (params != null) {
				req.data = params;
			}
		} else {
//			var builder : HttpRequestBuilder = new HttpRequestBuilder(url);
//			for (var key : String in params) {
//				if (params[key] is String || params[key] is int) {
//					builder.writeVariable(key, params[key]);
//				} else {
//					builder.writeByteArray(key, params[key]);
//				}
//			}
//			req = builder.request;
			
			req = new URLRequest(url);
			var pp : URLVariables = new URLVariables();
			for (var key : String in params) {
				if (params[key] is String || params[key] is Number ||params[key] is int) {
					pp[key] = params[key];
				} else {
					pp[key] = Base64.encode(params[key]);
				}
			}
			req.data = pp;
			req.method = URLRequestMethod.POST;
		}
		if(req.hasOwnProperty("userAgent")){
			req.requestHeaders = [new URLRequestHeader("Accept-Encoding","gzip,deflate,sdch")];
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

import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.ByteArray;

class HttpRequestBuilder {

	//构造的URLRequest
	private var _request : URLRequest;
	//构造的二进制ByteArray
	private var _byteArray : ByteArray;
	//Http协议分割符
	private var _separator : String;
	//标志位
	private var PROTOCAL_END_SET : Boolean = false; //是否填写HTTP文件尾

	public function HttpRequestBuilder($url : String, separator : String = "7d86d710144a") {
		//初始化
		_separator = separator;

		_request = new URLRequest($url);
		_request.method = URLRequestMethod.POST;
		_request.contentType = "multipart/form-data; boundary=---------------------------" + separator;

		_byteArray = new ByteArray();
	}

	/*
	* 写入变量
	* @param $name 写入的变量名
	* @param $value 写入的变量值
	*/
	public function writeVariable($name : String, $value : String) : void {
		writeSeparator();
		_byteArray.writeUTFBytes("Content-Disposition: form-data; name=\"" + $name + "\"\r\n\r\n" + $value);
	}

	/*
	* 写入图片
	* @param $name 变量名
	* @param $filename 图片文件名
	* @param $content 图片二进制数据
	*/
	public function writeByteArray($name : String, $content : ByteArray) : void {
		writeSeparator();
		_byteArray.writeUTFBytes("Content-Disposition: form-data; name=\"" + $name + "\"\r\nContent-Type: application/octet-stream\r\n\r\n");
		_byteArray.writeBytes($content);
	}

	/*
	* 构造HTTP分割线
	*/
	private function writeSeparator() : void {
		_byteArray.writeUTFBytes("\r\n-----------------------------" + separator + "\r\n");
	}

	/*
	* 构造HTTP结尾,只能调用一次，二次调用会抛出错误
	*/
	private function writeHttpEnd() : void {
		if (!PROTOCAL_END_SET) {
			_byteArray.writeUTFBytes("\r\n-----------------------------" + separator + "--");
		}
	}


	//get set
	public function get separator() : String {
		return _separator;
	}

	/*
	* 获取前会检查是否写入HTTP结尾，未调用的话会报错
	*/
	public function get request() : URLRequest {
		writeHttpEnd();
		_request.data = _byteArray;
		return _request;
	}
}
