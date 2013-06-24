package com.xy.model.vo {
	import com.xy.util.Tools;
	
	import flash.display.BitmapData;

public class BitmapDataVo {
	public var bmd : BitmapData;
	public var id : String;
	public var show : Boolean = true;
	
    public function BitmapDataVo(bmd : BitmapData) {
		this.bmd = bmd;
		id = Tools.makeId();
    }
}
}
