package com.xy.timeUtils
{
	/**
	 * 指定日期减去一定天数，返回减去后的新日期
	 * @author xuechong 
	 * @date 2010.08.27
	 * expamle： trace(BeforeDataHandler.minusDateNum(2010, 8, 27, 7993));    //1988/10/8
	 * */
	public class BeforeDataHandler
	{
		private static var beginYear:Number;
		private static var beginMonth:Number;
		private static var beginDay:Number;
		private static var manyDay:Number;
		private static var DAYS_IN_MONTH:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		
		public function BeforeDataHandler()
		{
		    
		}
		
		/**
		 * 指定日期减去一定天数，返回减去后的新日期
		 * */
		public static function minusDateNum(greYear:Number, greMonth:Number, greDay:Number, manyDay:Number):String
		{
			BeforeDataHandler.beginYear = greYear;
			BeforeDataHandler.beginMonth = greMonth;
			BeforeDataHandler.beginDay = greDay;
			BeforeDataHandler.manyDay = manyDay;
			return BeforeDataHandler.minusDateNumStr(BeforeDataHandler.beginYear, BeforeDataHandler.beginMonth, BeforeDataHandler.beginDay, BeforeDataHandler.manyDay);
		}
		
		/**
		 * 具体算法
		 * */
		private static function minusDateNumStr(greYear:Number, greMonth:Number, greDay:Number, manyDay:Number):String
		{
			manyDay = manyDay - greDay;
			if(manyDay < 0)
			{
				BeforeDataHandler.beginDay = -manyDay;
			}
			else
			{
				if(BeforeDataHandler.beginMonth != 1)
				{
					BeforeDataHandler.beginMonth -= 1;
					var _oneMonthDays:Number = BeforeDataHandler.greMonthManyDays(greYear, BeforeDataHandler.beginMonth);
					BeforeDataHandler.beginDay = _oneMonthDays;
					BeforeDataHandler.minusDateNumStr(BeforeDataHandler.beginYear, BeforeDataHandler.beginMonth, BeforeDataHandler.beginDay, manyDay);
				}
				else
				{
					BeforeDataHandler.beginMonth = 12;
					BeforeDataHandler.beginYear -= 1;
					var _oneMonth2Days:Number = BeforeDataHandler.greMonthManyDays(BeforeDataHandler.beginYear, BeforeDataHandler.beginMonth);
					BeforeDataHandler.beginDay = _oneMonth2Days;
					BeforeDataHandler.minusDateNumStr(BeforeDataHandler.beginYear, BeforeDataHandler.beginMonth, BeforeDataHandler.beginDay, manyDay);
				}
			}
			return BeforeDataHandler.beginYear + "/" + BeforeDataHandler.beginMonth + "/" + BeforeDataHandler.beginDay;
		}
		
		/**
		 * 一个公历月有多少天
		 * */
		private static function greMonthManyDays(year:Number, month:Number):Number
		{
			var manyDayNum:Number = BeforeDataHandler.DAYS_IN_MONTH[month - 1];
			if(BeforeDataHandler.isLeapYear(String(year)) && month == 2)
			{
				manyDayNum++;
			}
			return manyDayNum;
		}
		
		/**
		 * 是否为闰年，dayStr标准格式为YYYYMMDD，例如：20100816
		 * */
		private static function isLeapYear(dayStr:String):Boolean
		{
			var _year:Number = Number(dayStr.substr(0, 4));
			if((_year % 4 == 0 && _year % 100 != 0) || _year % 400 == 0)
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