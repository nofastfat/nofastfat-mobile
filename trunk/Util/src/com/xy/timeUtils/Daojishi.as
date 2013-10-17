package com.xy.timeUtils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * as3倒计时类库
	 * @author xuechong 
	 * @version v20121030.0.3
	 * @date 2010.10.21
	 * 调用方式： var daojishi:Daojishi = new Daojishi();
	 *	daojishi.timeStart(1, 2, 00, 00, ":");
	 *	daojishi.eventDispatcher.addEventListener(Daojishi.RESULT, hello);
	 *	function hello(event:Event):void
	 *	{
	 *	    trace(daojishi.result);
	 *	}
	 * 其返回的结果在本类的onTimerHandler()函数中显示;    //例如返回值: 00-01-29-51
	 * */
	public class Daojishi
	{
		import flash.events.TimerEvent;
		import flash.utils.Timer;
		
		public static const RESULT:String = "daojishi_result";
		public var eventDispatcher:EventDispatcher;
		public var result:String = "";
		private var _timer:Timer;
		private var _splitStr:String = "";
		private var _dayNum:Number = 0;
		private var _hourNum:Number = 0;
		private var _minutesNum:Number = 0;
		private var _secondsNum:Number = 0;
		
		/**
		 * @param _dayNum 指定天数
		 * @param _hourNum 指定小时
		 * @param _minutesNum 指定分钟数
		 * @param _secondsNum 指定秒数
		 * @param _splitStr 分割返回的各个时间点的字符
		 * */
		public function timeStart(dayNum:Number, hourNum:Number, minutesNum:Number, secondsNum:Number, splitStr:String):void
		{
			_timer = new Timer(1000);
			eventDispatcher = new EventDispatcher();
			_dayNum = dayNum;
			_hourNum = hourNum;
			_minutesNum = minutesNum;
			_secondsNum = secondsNum;
			_splitStr = splitStr;
			_timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
			_timer.start();
		}
		
		public function timeStop():void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onTimerHandler);
			_timer = null;
		}
		
		public function addEventListener(callBack:Function):void
		{
			eventDispatcher.addEventListener(Daojishi.RESULT, callBack);
		}
		
		private function onTimerHandler(event:TimerEvent):void
		{
			result = jisuanFunc(_splitStr);
			eventDispatcher.dispatchEvent(new Event(RESULT));
		}
		
		/**
		 * 具体的算法
		 * @param _splitStr 分割返回的各个时间点的字符
		 * */
		private function jisuanFunc(splitStr:String):String
		{
			_secondsNum -= 1;
			if(_secondsNum < 0)
			{
				if(_minutesNum > 0)
				{
					_minutesNum -= 1;
					_secondsNum = 59;
				}
				else    //小于0了就遭殃， 本身重置和上层判断(分临界了)
				{
					if(_hourNum > 0)
					{
						_hourNum -= 1;
						_minutesNum = 59;
						_secondsNum = 59;
					}
					else    //小于0了就遭殃， 本身重置和上层判断(分临界了)
					{
						if(_dayNum > 0)
						{
							_dayNum -= 1;
							_hourNum = 23;
							_minutesNum = 59;
							_secondsNum = 59;
						}
						else
						{
							_dayNum = 0;
							_hourNum = 0;
							_minutesNum = 0;
							_secondsNum = 0;
							_timer.stop();
							_timer.removeEventListener(TimerEvent.TIMER, onTimerHandler);
						}
					}
				}
			}
			return doubleStrFunc(_dayNum) + _splitStr + doubleStrFunc(_hourNum) + _splitStr + 
				doubleStrFunc(_minutesNum) + _splitStr + doubleStrFunc(_secondsNum);
		}
		
		/**
		 * 字符处理/月日时分秒数不足10时前加0
		 * */
		private function doubleStrFunc(timeNum:int):String
		{
			if(timeNum < 10)
			{
				return "0" + timeNum;
			}
			else
			{
				return timeNum.toString();
			}
		}
		
	}
}