package com.xy.model.vo {

public class GoodsVo {
	public var id : int;
    public var sbn : String;
    public var name : String;
    public var weight : Number;
    public var type : String;
    public var info : String;
	
	public function copyFrom(source : GoodsVo):void{
		id = source.id;
		sbn = source.sbn;
		name = source.name;
		weight = source.weight;
		type = source.type;
		info = source.info;
	}
	
	public function clone():GoodsVo{
		var vo : GoodsVo = new GoodsVo();
		vo.copyFrom(this);
		
		return vo;
	}
}
}
