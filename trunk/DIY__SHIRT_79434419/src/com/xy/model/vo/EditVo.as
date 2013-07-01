package com.xy.model.vo {
import flash.geom.Point;


public class EditVo {
    public var lineSickness : int;
    public var lineColor : uint = 0x000000;
    public var alpha : Number = 1;
    public var isFull : Boolean = false;
    public var bmdScroll : Point = new Point();

    public var text : String="";
    public var fontName : String="宋体";
    public var fontSize : String="12";
    public var fontColor : uint;
    public var isBold : Boolean;
    public var tfWidth : Number = 0;
    public var tfHeight : Number = 0;
	public var align : String = "";
}
}
