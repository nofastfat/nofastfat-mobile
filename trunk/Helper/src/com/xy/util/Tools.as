package com.xy.util {
import com.xy.graphics.CubicBezier;

import flash.display.Shape;
import flash.geom.Point;


public class Tools {
    /**
     * 画一个赛贝尔的连接线 
     * @param start
     * @param end
     * @return 
     */	
    public static function makeConactLine(start : Point, end : Point) : Shape {
        var bezierLine : CubicBezier = new CubicBezier(start, end, new Point(start.x, start.y + 40), new Point(end.x, end.y - 30), 0xaaaaaa);
        return bezierLine.draw();
    }
}
}
