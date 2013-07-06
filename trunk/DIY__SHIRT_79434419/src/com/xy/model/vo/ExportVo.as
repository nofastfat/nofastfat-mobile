package com.xy.model.vo {
import com.xy.util.Tools;

import flash.display.BitmapData;

public class ExportVo {
    public var id : String;
    public var vo : BitmapDataVo;
    public var index :int;
    public var bgData : *;
    public var diys : Array = [];
    public var exportBmd : BitmapData;
    public var calVo : CalVo;
    
    public function ExportVo():void{
    	id = Tools.makeId();
    }
}
}
