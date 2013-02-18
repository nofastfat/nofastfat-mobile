package com.xy.util {
import flash.utils.Dictionary;

/**
 * 基于帧的执行函数
 * 逻辑代码卡/掉帧严重 就找我
 * @author xy
 */
public class EnterFrameExecuter {
	/**
	 * 单例
	 */
	private static var _instances : Array = [];


	/**
	 * 获取单例的引用
	 * @return EnterFrameExecuter
	 */
	public static function getInstance(index : int = 0) : EnterFrameExecuter {
		if (_instances[index] == null) {
			_instances[index] = new EnterFrameExecuter();
			_instances[index].init();
		}

		return _instances[index];
	}


	/****************类对象结构*******************/

	/**
	 *  类帧数统计
	 */
	private var _frameRater : int;

	/**
	 *  等待处理的方法及其参数
	 *  key:String
	 *  value:
	 *  {
	 * 		fun:Functon,
	 * 		params : Array
	 *  }
	 */
	private var _callCache : Dictionary;

	/**
	 * 为了能够实现队列的功能，用数组存储所有key
	 */
	private var _keyArray : Array;

	/**
	 * 当前正在执行的key
	 */
	private var _nowKey : String;

	/**
	 * 当前正在执行的类对象
	 */
	private var _nowObj : *;

	/**
	 * 添加一个需要延时处理的函数
	 * @param key 			标志性的key
	 * @param runObj 		需要执行的对象本身，其实就是BitmapMc了
	 * @param funDataArray 	等待执行的function及params,
	 * 						结构:[{fun:Function, params:Array}, {fun:Function, params:Array}, ...]
	 * @param needFirst 	加载优先级，true的话会优先处理
	 */
	public function add(key : String, runObj : *, funDataArray : Array, needFirst : Boolean = false) : void {

		/*先尝试删除旧的*/
		del(key);

		/*缓存数据*/
		_callCache[key] = {
				runObj: runObj,
				funData: funDataArray
			};

		/*优先处理的情况还得额外判断，伤疤*/
		if (needFirst) {
			/*如果当前加载的就是key，可能会有异步的BUG，*/
			_keyArray.splice(0, 0, key);
		} else {
			_keyArray.push(key);
		}
	}

	/**
	 * 清理所有的回调
	 */
	public function clear() : void {
		_callCache = new Dictionary();
		_keyArray = [];
		_nowKey = "";
		_nowObj = null;
	}

	/**
	 * 删除一个延时处理的函数
	 * @param key
	 */
	public function del(key : String) : void {
		/*删除前会先进行判断*/
		var index : int = _keyArray.indexOf(key);

		/*存在则删除*/
		if (index != -1) {
			_keyArray.splice(index, 1);
			delete _callCache[key];

			/*删除的是当前正在执行的方法，则连带删除*/
			if (_nowKey == key) {
				_nowKey = "";
				_nowObj = null;
			}
		}
	}

	/**
	 * 从缓存中取出一个数据
	 * @return
	 * {
	 * 		fun:Functon,
	 * 		params : Array
	 *  }
	 */
	private function shift() : * {
		if (_keyArray.length <= 0) {
			return null;
		}

		if (_nowKey == "") {
			_nowKey = _keyArray[0];
		}

		/*当前没有执行的方法，重新取方法*/
		var o : * = _callCache[_nowKey];

		/*当前正在执行的对象 */
		_nowObj = o.runObj;

		/*待执行的方法及参数*/
		var funDataArray : Array = o.funData;

		/*还有需要执行的方法及参数*/
		if (funDataArray.length > 0) {
			var rs : * = funDataArray.shift();

			return rs;
		} else {
			/*这个已经执行完了，换下一个key*/

			/*删除已经执行完了的*/
			del(_nowKey);

			/*换下一个key*/
			_nowKey = "";

			return shift();
		}

		return null;
	}

	/**
	 * 初始化
	 *
	 */
	private function init() : void {
		_frameRater = 0;
		_callCache = new Dictionary();
		_keyArray = [];
		_nowKey = "";

		/*基于帧的处理*/
		EnterFrameCall.add(execute);
	}

	/**
	 * 处理执行
	 */
	private function execute() : void {
		var o : * = shift();
		if (o == null) {
			return;
		}
	
		var fun : Function = o.fun;
		var params : * = o.params;
		if (fun != null) {
			try{
				fun.apply(_nowObj, params);
			}catch(e : Error){
				trace("ERROR:这个一个很难察觉的错误，把错误信息发给xy，3Q" + e);
			}
		}
	}
}
}
