package com.xy.timeUtils
{
	/**
	 * delWeekendDaysAllNum()函数指定日期加上一定天数，返回加上后又减去周六日的总天数后的新日期  <br/>
	 * @author xuechong  <br/>
	 * @date 2010.09.16  <br/>
	 * expamle： trace(new AfterDateNoWeekend().manyWeekendDaysNum(2010, 9, 16, 5));    //2010/8/26
	 * */
	public class AfterDateNoWeekend
	{
		private static var beginYear:Number;
		private static var beginMonth:Number;
		private static var beginDay:Number;
		private static var addManyDaysNum:Number;
		private static var DAYS_IN_MONTH:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
		
		public function AfterDateNoWeekend()
		{
		    
		}
		
		/**
		 * 指定日期加上一定天数，返回加上后的新日期
		 * */
		public static function delWeekendDaysAllNum(greYear:Number, greMonth:Number, greDay:Number, _addManyDaysNum:Number):String
		{
			AfterDateNoWeekend.beginYear = greYear;
			AfterDateNoWeekend.beginMonth = greMonth;
			AfterDateNoWeekend.beginDay = greDay;
			AfterDateNoWeekend.addManyDaysNum = _addManyDaysNum;
			var _beginDate:Date = new Date(greYear, greMonth, greDay);
			return AfterDateNoWeekend.delWeekendDaysAllFunc(_beginDate, greYear, greMonth, _addManyDaysNum);
		}
		
		private static function delWeekendDaysAllFunc(_beginDate:Date, _greYear:Number, _greMonth:Number, _addManyDaysNum:Number):String
		{
			var _tempNewDayStr:String;
			var _tempGreYear:Number = _greYear;
			var _tempGreMonth:Number = _greMonth;
			var _tempGreDate:Number = _beginDate.getDate();
			var _tempWitchWeekDay:Number;
			for(var i:int = 1; i <= _addManyDaysNum; i++)
			{    //保证加几天就要for执行几次（即for全执行）
				var _dateStr:String = AfterDateNoWeekend.addDateNumStr(_tempGreYear, _tempGreMonth, 1);    //得到了下一天
				var _tempDateArr:Array = _dateStr.split("/");    
				_beginDate.fullYear = Number(_tempDateArr[0]);
				_beginDate.month = Number(_tempDateArr[1]) - 1;
				_beginDate.date = Number(_tempDateArr[2]);
				_tempWitchWeekDay = _beginDate.getDay();
				_tempGreYear = Number(_tempDateArr[0]);
				_tempGreMonth = Number(_tempDateArr[1]);
				_tempGreDate = Number(_tempDateArr[2]);
				if(_tempWitchWeekDay == 6)
				{
					_dateStr = AfterDateNoWeekend.addDateNumStr(_beginDate.fullYear, _beginDate.getMonth() + 1, 2);
					_tempDateArr = _dateStr.split("/");
					_tempGreYear = Number(_tempDateArr[0]);
					_tempGreMonth = Number(_tempDateArr[1]);
					_tempGreDate = Number(_tempDateArr[2]);
				}
				else if(_tempWitchWeekDay == 7)
				{
					_dateStr = AfterDateNoWeekend.addDateNumStr(_beginDate.fullYear, _beginDate.getMonth(), 1);
					_tempDateArr = _dateStr.split("/");
					_tempGreYear = Number(_tempDateArr[0]);
					_tempGreMonth = Number(_tempDateArr[1]);
					_tempGreDate = Number(_tempDateArr[2]);
				}
			}
			_tempNewDayStr = _tempGreYear + "/" + _tempGreMonth + "/" + _tempGreDate;
			return _tempNewDayStr;
		}
		
		/**
		 * 指定日期加上一定天数，返回加上后的新日期
		 * */
		private static function addDateNumStr(greYear:Number, greMonth:Number, manyDay:Number):String
		{
			var _oneMonthDays:Number = AfterDateNoWeekend.greMonthManyDays(greYear, greMonth);    //一个公历月有多少天
			var _andDayNum:Number = AfterDateNoWeekend.beginDay + manyDay;
			if(_andDayNum <= _oneMonthDays)
			{
				AfterDateNoWeekend.beginDay = _andDayNum;
			}
			else
			{
				if(AfterDateNoWeekend.beginMonth != 12)
				{
					manyDay = manyDay - (_oneMonthDays - AfterDateNoWeekend.beginDay);
					AfterDateNoWeekend.beginYear = greYear;
					AfterDateNoWeekend.beginMonth += 1;
					AfterDateNoWeekend.beginDay = 0;
					AfterDateNoWeekend.addDateNumStr(AfterDateNoWeekend.beginYear, AfterDateNoWeekend.beginMonth, manyDay);
				}
				else
				{
					manyDay = manyDay - (_oneMonthDays - AfterDateNoWeekend.beginDay);
					AfterDateNoWeekend.beginYear = greYear;
					AfterDateNoWeekend.beginYear += 1;
					AfterDateNoWeekend.beginMonth = 1;
					AfterDateNoWeekend.beginDay = 0;
					AfterDateNoWeekend.addDateNumStr(AfterDateNoWeekend.beginYear, AfterDateNoWeekend.beginMonth, manyDay);
				}
			}
			return AfterDateNoWeekend.beginYear + "/" + AfterDateNoWeekend.beginMonth + "/" + AfterDateNoWeekend.beginDay;
		}
		
		/**
		 * 一个公历月有多少天
		 * */
		private static function greMonthManyDays(year:Number, month:Number):Number
		{
			var manyDayNum:Number = AfterDateNoWeekend.DAYS_IN_MONTH[month - 1];
			if(AfterDateNoWeekend.isLeapYear(year) && month == 2)
			{
				manyDayNum++;
			}
			return manyDayNum;
		}
		
		/**
		 * 是否为闰年，dayStr标准格式为YYYYMMDD，例如：20100816
		 * */
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