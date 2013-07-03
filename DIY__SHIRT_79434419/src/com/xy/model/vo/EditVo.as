package com.xy.model.vo {
import flash.geom.Point;


public class EditVo {
    public var id : String;
    public var groupId : String;

    public var ix : Number;
    public var iy : Number;
    public var bmdId : String;
    public var rotation : Number = 0;
    public var registerIndex : int;
    public var realW : Number = 0;
    public var realH : Number = 0;
    public var childX : Number = 0;
    public var childY : Number = 0;

    public var lastP : Point;

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
    public var lastScaleX : Number = 1;
    public var lastScaleY : Number = 1;

    public var isImage : Boolean = false;

    public function EditVo(id : String = null) {
        this.id = id;
    }

    public function clone() : EditVo {
        var rs : EditVo = new EditVo();
        rs.id = this.id;
        rs.groupId = this.groupId;
        rs.ix = this.ix;
        rs.iy = this.iy;
        rs.bmdId = this.bmdId;
        rs.rotation = this.rotation;
        rs.registerIndex = this.registerIndex;
        rs.realW = this.realW;
        rs.realH = this.realH;
        rs.childX = this.childX;
        rs.childY = this.childY;

        if (this.lastP != null) {
            rs.lastP = this.lastP.clone();
        }
        rs.lineSickness = this.lineSickness;
        rs.lineColor = this.lineColor;
        rs.alpha = this.alpha;
        rs.isFull = this.isFull;
        rs.bmdScroll = this.bmdScroll.clone();
        rs.text = this.text;
        rs.fontName = this.fontName;
        rs.fontSize = this.fontSize;
        rs.fontColor = this.fontColor;
        rs.isBold = this.isBold;
        rs.tfWidth = this.tfWidth;
        rs.tfHeight = this.tfHeight;
        rs.align = this.align;
        rs.isImage = this.isImage;
        rs.lastScaleX = this.lastScaleX;
        rs.lastScaleY = this.lastScaleY;
        return rs;
    }

    public function copyFrom(vo : EditVo) : void {
        this.id = vo.id;
        this.groupId = vo.groupId;
        this.ix = vo.ix;
        this.iy = vo.iy;
        this.bmdId = vo.bmdId;
        this.rotation = vo.rotation;
        this.registerIndex = vo.registerIndex;
        this.realW = vo.realW;
        this.realH = vo.realH;
        this.childX = vo.childX;
        this.childY = vo.childY;

        if (vo.lastP != null) {
            this.lastP = vo.lastP.clone();
        }
        this.lineSickness = vo.lineSickness;
        this.lineColor = vo.lineColor;
        this.alpha = vo.alpha;
        this.isFull = vo.isFull;
        this.bmdScroll = vo.bmdScroll.clone();
        this.text = vo.text;
        this.fontName = vo.fontName;
        this.fontSize = vo.fontSize;
        this.fontColor = vo.fontColor;
        this.isBold = vo.isBold;
        this.tfWidth = vo.tfWidth;
        this.tfHeight = vo.tfHeight;
        this.align = vo.align;
        this.isImage = vo.isImage;
        this.lastScaleX = vo.lastScaleX;
        this.lastScaleY = vo.lastScaleY;
    }
}
}
