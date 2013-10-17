package com.xy.timeUtils
{
	/**
	 * @author xuechong 
	 * @date 2010.08.17
	 * var tianganDizhi:String = TianganDizhi.cyclical(2010);
	 * */
	public class TianganDizhi
	{
		private static var tianganArr:Array = new Array("甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸");
		private static var dizhiArr:Array = new Array("子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥");
		
		public function TianganDizhi()
		{
		    
		}
		
		/**
		 * 传入农历年份返回干支(此农历年份要大于等于1864)
		 * */
		public static function cyclical(lunarYearNo:int):String
		{
			var num:int = lunarYearNo - 1900 + 36;
			return cyclicalm(num);
		}
		
		public static function cyclicalm(num:int):String
		{
			return (tianganArr[num % 10] + dizhiArr[num % 12]);
		}
		
	}
}