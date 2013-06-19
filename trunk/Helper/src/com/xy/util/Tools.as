package com.xy.util {
import com.xy.graphics.CubicBezier;

import flash.display.Shape;
import flash.geom.Point;


public class Tools {
	private static var _IDS : Array = [];
	
    /**
     * 画一个赛贝尔的连接线 上下连接 
     * @param start
     * @param end
     * @return 
     */	
    public static function makeConactLine(start : Point, end : Point) : Shape {
        var bezierLine : CubicBezier = new CubicBezier(start, end, new Point(start.x, start.y + 40), new Point(end.x, end.y - 30), 0xaaaaaa);
        return bezierLine.draw();
    }
    
    /**
     * 画一个赛贝尔的连接线  左右连接
     * @param start
     * @param end
     * @return 
     */	
    public static function makeConactLine2(start : Point, end : Point) : Shape {
        var bezierLine : CubicBezier = new CubicBezier(start, end, new Point(start.x + 40, start.y), new Point(end.x - 30, end.y), 0xaaaaaa);
        return bezierLine.draw();
    }
    
    public static function makeId() : String{
    	var id : int = STool.random(101, int.MAX_VALUE);
    	while(_IDS.indexOf(id) != -1){
    		id = STool.random(101, int.MAX_VALUE);
    	}
    	
    	_IDS.push(id);
    	
    	return id+"";
    }
}
}
