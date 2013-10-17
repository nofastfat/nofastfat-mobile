package com.xy.timeUtils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * as3计时器类库
	 * @author xuechong 
	 * @version v20121030.0.1
	 * @date 2012.10.30
	 * var jishiqi:Jishiqi = new Jishiqi();
	 * 	jishiqi.addEventListener(Jishiqi.RESULT, hello2);
	 *	jishiqi.timeStart(1000);
	 *	function hello2(event:Event):void
	 *	{
	 *	    trace(jishiqi.resultNum);
	 *		jishiqi.timeStop();
	 *	}
	 * */
	public class Jishiqi extends EventDispatcher
	{
		public static const RESULT:String = "jishiqiResult";
		private var _initTimer:Number = 0;
		private var _serverTimer:uint = 0;    //服务器时间
		private var _resultNum:uint = 0;    //结果时间
		private var _interval:uint = 0;    //
		
		public function Jishiqi()
		{
			
		}
		
		/**
		 * 计时器组件计时开始
		 * */
		public function timeStart($serverTimer:Number):void
		{
			_initTimer = new Date().getTime();
			_serverTimer = $serverTimer;
			_interval = setInterval(keepingStart, 1000);
		}
		
		/**
		 * 计时器组件计时停止
		 * */
		public function timeStop():void
		{
			clearInterval(_interval);
		}
		
		/**
		 * 每次都读取本地时间，减小误差
		 * */
		private function keepingStart():void
		{
			_resultNum = (new Date().getTime() - _initTimer) * 0.001 + _serverTimer;
			this.dispatchEvent(new Event(RESULT));
		}
		
		public function get resultNum():uint
		{
		    return _resultNum;
		}
		
	}
}