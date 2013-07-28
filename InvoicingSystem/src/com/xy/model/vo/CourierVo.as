package com.xy.model.vo {

public class CourierVo {
	public var id : int;
    public var name : String;
    
    public function copyFrom(source : CourierVo):void{
		id = source.id;
		name = source.name;
	}
	
	public function clone():CourierVo{
		var vo : CourierVo = new CourierVo();
		vo.copyFrom(this);
		
		return vo;
	}
}
}
