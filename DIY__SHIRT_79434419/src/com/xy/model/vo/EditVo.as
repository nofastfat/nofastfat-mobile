package com.xy.model.vo {
import flash.geom.Point;
import flash.net.registerClassAlias;
import flash.utils.ByteArray;


public class EditVo {
	public var id : String;
	
	public var ix : Number;
	public var iy : Number;
	public var bmdId : String;
	public var rotation : Number = 0;
	public var registerIndex : int;
	public var realW : Number = 0;
	public var realH : Number = 0;
	public var childX : Number = 0;
	public var childY : Number = 0;
	
	public var lastP:Point;
	
    public var lineSickness : int;
    public var lineColor : uint = 0x000000;
    public var alpha : Number = 1;
    public var isFull : Boolean = false;
    public var bmdScroll : Point = new Point();

    public var text : String = "";
    public var fontName : String = "宋体";
    public var fontSize : String = "12";
    public var fontColor : uint;
    public var isBold : Boolean;
    public var tfWidth : Number = 0;
    public var tfHeight : Number = 0;
    public var align : String = "";

    public var isImage : Boolean = false;
	
	public function EditVo(id : String = null){
		this.id = id;
	}

    public function clone() : EditVo {
		registerClassAlias("EditVo", EditVo);
		registerClassAlias("Point", Point);
        var ba : ByteArray = new ByteArray();
        ba.writeObject(this);
        ba.position = 0;
		
		var rs : EditVo = ba.readObject() as EditVo;
		rs.id = this.id;

        return rs;
    }
}
}
