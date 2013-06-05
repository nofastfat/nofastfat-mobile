package com.xy.util {

/**
 * 时间转换为字符串
 * @author xy
 */
public class TimeTraslate {

	/**
	 * 秒转换为文字
	 * @param second
	 * @return
	 */
	public static function sToString(second : Number) : String {
		var day : int = second / (24 * 60 * 60);

		var hour : int = (second % (24 * 60 * 60)) / (60 * 60);

		var minute : int = (second % (60 * 60)) / 60;

		var sc : int = second % 60;
		
		var str : String = "";
		if(day > 0){
			str = day + "天";
		}
		if(hour > 0){
			str += hour + "小时";
		}
		if(minute > 0){
			str += minute + "分";
		}
		if(sc > 0){
			str += sc + "秒";
		}
		
		return str;
	}
	
	/**
	 * 转换为距离现在的时间 
	 * @param date
	 * @return 
	 */	
	public static function toDiffString(date : Date) : String{
		if(date == null){
			return "离线";
		}
		
		var now : Date = new Date();
		var second : int = (now.getTime() - date.getTime()) / 1000;
		
		if(second < 0){
			second = 0;
		}
		
		var rs : String = "";
		if(second < 60){
			rs = "刚刚";
		}else if(second < 60 *60){
			rs = int(second/60) + "分钟前";
		}else if(second < 24 * 60 * 60){
			rs = int(second/(60*60)) + "小时前";
		}else if(second < 30*24*60*60){
			rs = int(second/(24*60*60)) + "天前";
		}else if(second < 12*30*24*60*60){
			rs = int(second/(30*24*60*60)) + "个月前";
		}else{
			rs = "很久很久以前";
		}
		
		return rs;
	}
}
}
