package com.xy.util {

/**
 * 4方向 
 * @author xy
 */	
public class Direction4 {
	/**
	 * 右 
	 */	
	public static const RIGHT : int = 0;
	
	/**
	 * 下 
	 */	
	public static const DOWN : int = 1;
	
	/**
	 * 上 
	 */	
	public static const UP : int = 2;
	
	/**
	 * 左 
	 */	
	public static const LEFT : int = 3;
	
	/**
	 * 角度对应的方位 
	 */		
	private static const ANGLE_DIRECTION : Array = [
		[45, 135, DOWN],
		[135, 225, LEFT],
		[255, 315, UP]
	];
	
	/**
	 * 计算从一个点到另一个点的方向
	 * @param startX
	 * @param startY
	 * @param endX
	 * @param endY
	 * @return 
	 */	
	public static function fromPt(startX : Number, startY : Number, endX : Number, endY : Number) : int{
		var angle : Number = Math.atan2(endY-startY, endX-startX);
		angle = angle * 180/Math.PI;
		angle = formatAngle(angle);
		
		for each(var arr : Array in ANGLE_DIRECTION){
			if(arr[0] < angle && angle <= arr[1]){
				return arr[2];
			}
		}
		
		return RIGHT;
	}
	
	/**
	 * 转换为0-360之间的度数
	 * @param angle
	 * @return 
	 */		
	private static function formatAngle(angle : Number):Number{
		if(0 <= angle && angle < 360){
			return angle;
		}
		
		if(angle < 0){
			return formatAngle(angle + 360);
		}
		
		if(angle >= 360){
			return formatAngle(angle - 360);
		}
		
		return angle;
	}

}
}
