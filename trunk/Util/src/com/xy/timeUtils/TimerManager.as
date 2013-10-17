package com.xy.timeUtils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * 时间管理器
	 * */
	public class TimerManager
	{
		private var _globalTimer:Timer;
		private var _delayTime:uint;
		private var _timerEventMap:Object;
		private var _timerEventMapKeys:Array;
		private var _pollEventMap:Array;
		private var _startDate:Date;
		
		public function TimerManager()
		{
			
		}
		
		/**
		 * 仅初始执行一次
		 */		
		public function register(num:Number):void
		{
			_timerEventMap = new Object();
			_timerEventMapKeys = [];
			_pollEventMap = [];
			_startDate = new Date(num);
			_globalTimer = new Timer(500);
			_globalTimer.addEventListener(TimerEvent.TIMER, timeEventHandler);
			startTimer();
		}
		
		public function registerTimerEvent(time:Number, handle:Function, context:Object, args:Array=null):void
		{
			var tempCt:Number = time + currTime;
			if(tempCt)
			{
				addKey(tempCt);
			}
			var cache:Object = new Object();
			cache.method = handle;
			cache.context = context;
			cache.args = args;
			_timerEventMap[tempCt].push(cache);
		}
		
		public function registerPollEvent(time:Number, handle:Function, context:Object, args:Array=null):void
		{
			var cache:Object = new Object();
			cache.startTime = currTime;
			cache.delay = time;
			cache.method = handle;
			cache.context = context;
			cache.args = args;
			_pollEventMap.push(cache);
		}
		
		private function addKey(time:Number):void
		{
			var key:* = undefined;
			for each(key in _timerEventMapKeys)
			{
				if(key == time)
				{
					return;
				}
			}
			_timerEventMapKeys.push(time);
			//_timerEventMapKeys.sort(sortOnTime);
			_timerEventMap[time] = new Array();
		}
		
		private function sortOnTime():Number
		{
			return 0;
		}
		
		public function remove():void
		{
			stopTimer();
			_timerEventMap = null;
		}
		
		public function get currTime():Number
		{
			return _startDate.getTime() + getTimer();
		}
		
		private function startTimer():void
		{
			_globalTimer.start();
		}
		
		private  function stopTimer():void
		{
			_globalTimer.stop();
		}
		
		private function timeEventHandler(evt:TimerEvent):void
		{
			var i:int;
			var j:int;
			var handle:Function;
			var context:Object;
			var args:Object;
			var currPollObj:Object;
			var dt:int;
			var ct:* = currTime;
			i = 0;
			while(i < _timerEventMapKeys.length) 
			{
				try
				{
					if(_timerEventMapKeys[i] < currTime) 
					{
						j = 0;
						while(j < _timerEventMap[_timerEventMapKeys[i]].length)
						{
							try
							{
								handle = _timerEventMap[_timerEventMapKeys[i]][j].method;
								context = _timerEventMap[_timerEventMapKeys[i]][j].context;
								args = _timerEventMap[_timerEventMapKeys[i]][j].args;
								handle.apply(context, args);
							}
							catch(e:Error)
							{
								
							}
							j++;
						}
						removeKey(_timerEventMapKeys[i]);
					}
					else
					{
						break;
					}
				}
				catch(e:Error)
				{
					
				}
				i++;
			}
			i = 0;
			while(i < _pollEventMap.length)
			{
				try
				{
					currPollObj = _pollEventMap[i];
					dt = ct - currPollObj.startTime;
					if(dt >= currPollObj.delay)
					{
						handle = currPollObj.method;
						handle.apply(currPollObj.context, currPollObj.args);
						currPollObj.startTime = ct;
					}
				}
				catch(e:Error)
				{
					
				}
				i++;
			}
			//evt.updateAfterEvent();
		}
		
		private function removeKey(time:Number):void
		{
			var i:int = 0;
			while(i < _timerEventMapKeys.length)
			{
				if(_timerEventMapKeys[i] == time)
				{
					delete _timerEventMap[_timerEventMapKeys[i]];
					_timerEventMapKeys.splice(i, 1);
					_timerEventMapKeys.sort(sortOnTime);
					return;
				}
				i++;
			}
		}
		
		public function removeTimerEvent(time:Number):void
		{
			var obj:Object;
			if(!_timerEventMap[time])
			{
				return;
			}
			try
			{
				var timerEvent:* = _timerEventMap[time];
				for each(obj in timerEvent)
				{
					delete obj.method;
					delete obj.context;
				}
			}
			catch(e:Error)
			{
				
			}
		}
		
		public function removePollEvent(time:Number, handle:Function, context:Object):void
		{
			var obj:Object;
			var i:int = 0;
			while(i < _pollEventMap.length)
			{
				obj = _pollEventMap[i];
				if(obj.delay == time && obj.method == handle && obj.context == context)
				{
					_pollEventMap.splice(i, 1);
				}
				i++;
			}
		}
		
		public function removeMethod(time:Number, handle:Function, context:Object):void
		{
			if(_timerEventMap[time])
			{
				var i:int = 0;
				while(i < _timerEventMap[time].length)
				{
					if(_timerEventMap[time][i].method == handle && _timerEventMap[time][i].context == context)
					{
						try
						{
							delete _timerEventMap[time][i].method;
							delete _timerEventMap[time][i].context;
							_timerEventMap[time].splice(i, 1);
						}
						catch(e:Error)
						{
							
						}
					}
					i++;
				}
			}
		}
		
		public function set delayTime(delay:uint):void
		{
			_delayTime = delay;
			_globalTimer.delay = _delayTime;
			if(_globalTimer.running)
			{
				_globalTimer.start();
			}
		}
		
		public function havePollEvent(time:Number, handle:Function, context:Object):Boolean
		{
			var obj:Object;
			var i:int = 0;
			while(i < _pollEventMap.length)
			{
				obj = _pollEventMap[i];
				if(obj.delay == time && obj.method == handle && obj.context == context)
				{
					return true;
				}
				i++;
			}
			return false;
		}
		
	}
}