package com.xy.timeUtils
{
	
	/**
	 * 指定日期加上一定天数，返回加上后的新日期
	 * author xuechong 2012.08.26
	 * expamle： trace(AfterDateHandler.addDateNum(1988, 10, 8, 7992));    //2010/8/26
	 * */
	public class AfterDateHandler
	{
		private static var beginYear:Number;
		private static var beginMonth:Number;
		private static var beginDay:Number;
		private static var manyDay:Number;
		
		private static var DAYS_IN_MONTH:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		
		public function AfterDateHandler()
		{
		    
		}
		
		/**
		 * 指定日期加上一定天数，返回加上后的新日期
		 * */
		public static function addDateNum(greYear:Number, greMonth:Number, greDay:Number, manyDay:Number):String
		{
			AfterDateHandler.beginYear = greYear;
			AfterDateHandler.beginMonth = greMonth;
			AfterDateHandler.beginDay = greDay;
			AfterDateHandler.manyDay = manyDay;
			return AfterDateHandler.addDateNumStr(AfterDateHandler.beginYear, AfterDateHandler.beginMonth, AfterDateHandler.manyDay);
		}
		
		/**具体算法*/
		private static function addDateNumStr(greYear:Number, greMonth:Number, manyDay:Number):String
		{
			var _oneMonthDays:Number = AfterDateHandler.greMonthManyDays(greYear, greMonth);
			var _andDayNum:Number = AfterDateHandler.beginDay + manyDay;
			if(_andDayNum <= _oneMonthDays)
			{
				AfterDateHandler.beginDay = _andDayNum;
			}
			else
			{
				if(AfterDateHandler.beginMonth != 12)
				{
					manyDay = manyDay - (_oneMonthDays - AfterDateHandler.beginDay);
					AfterDateHandler.beginMonth += 1;
					AfterDateHandler.beginDay = 0;
					AfterDateHandler.addDateNumStr(AfterDateHandler.beginYear, AfterDateHandler.beginMonth, manyDay);
				}
				else
				{
					manyDay = manyDay - (_oneMonthDays - AfterDateHandler.beginDay);
					AfterDateHandler.beginYear += 1;
					AfterDateHandler.beginMonth = 1;
					AfterDateHandler.beginDay = 0;
					AfterDateHandler.addDateNumStr(AfterDateHandler.beginYear, AfterDateHandler.beginMonth, manyDay);
				}
			}
			return AfterDateHandler.beginYear + "/" + AfterDateHandler.beginMonth + "/" + AfterDateHandler.beginDay;
		}
		
		/**
		 * 一个公历月有多少天
		 * */
		private static function greMonthManyDays(year:Number, month:Number):Number
		{
			var manyDayNum:Number = AfterDateHandler.DAYS_IN_MONTH[month - 1];
			if(AfterDateHandler.isLeapYear(year) && month == 2)
			{
				manyDayNum++;
			}
			return manyDayNum;
		}
		
		/**是否为闰年，year标准格式为YYYY*/
		private static function isLeapYear(year:Number):Boolean
		{
			if((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
	}
}