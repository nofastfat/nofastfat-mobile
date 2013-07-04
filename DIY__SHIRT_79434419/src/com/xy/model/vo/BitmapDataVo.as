package com.xy.model.vo {
import com.xy.util.Tools;

import flash.display.BitmapData;
import flash.geom.Rectangle;

public class BitmapDataVo {
    public var bmd : BitmapData;
    public var id : String;
    public var show : Boolean = true;
    public var type : String = "";
    public var url : String = "";
    public var rect : Rectangle;
    public var info : String = "";
    private var _page : int = 1;
	public var bgs : Array = [];
	public var cate:String;

    public var defaultImages : Array = [];

    public function BitmapDataVo(cate:String,id : String = null, bmd : BitmapData = null) {
        this.bmd = bmd;
		this.cate = cate.toLowerCase();

        if (id == null) {
            id = Tools.makeId();
        } else {
            Tools.recordId(id);
        }
        this.id = id;
    }

    public function get page() : int {
        return _page;
    }

    public function set page(value : int) : void {
        _page = value;
		
		if(_page < 1){
			_page = 1;
		}
    }

}
}
