package com.xy.model.vo {
import com.xy.util.Tools;

import flash.display.BitmapData;

public class BitmapDataVo {
    public var bmd : BitmapData;
    public var id : String;
    public var show : Boolean = true;
    public var type : String = "";
	public var url : String = "";

    public function BitmapDataVo(bmd : BitmapData = null) {
        this.bmd = bmd;
        id = Tools.makeId();
    }
}
}
