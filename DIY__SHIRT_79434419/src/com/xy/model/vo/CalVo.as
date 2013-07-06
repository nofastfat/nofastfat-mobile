package com.xy.model.vo {
import flash.display.BitmapData;

public class CalVo extends BitmapDataVo {
    public var style : String;
    public var year : int;
    public var month : int;

    public function CalVo(cate : String, id : String = null, bmd : BitmapData = null) {
        super(cate, id, bmd);
    }

    public function toString() : String {
        return year + "年" + month + "月";
    }

}
}
