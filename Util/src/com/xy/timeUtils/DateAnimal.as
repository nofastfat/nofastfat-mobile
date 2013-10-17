package com.xy.timeUtils
{
	/**
	 * @author xuechong 
	 * @date 2010.08.17
	 * var animalStr:String = DateAnimal.yearAnimals(1988);
	 * */
	public class DateAnimal
	{
		private static var animalArr:Array = new Array("鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪");
		
		public function DateAnimal()
		{
		    
		}
		
		/**
		 * 参数_year为公历年份，返回农历_year年的生肖
		 * */
		public static function yearAnimals(_year:int):String
		{
			return DateAnimal.animalArr[(_year - 4) % 12];
		}
		
	}
}