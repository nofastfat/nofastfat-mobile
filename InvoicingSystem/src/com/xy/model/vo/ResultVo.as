package com.xy.model.vo {
	import com.adobe.serialization.json.JSON;

public class ResultVo {
    public var status : Boolean;
    public var data : *;
	
	public static function fromString(str : String) : ResultVo{
		var vo : ResultVo = new ResultVo();
		if(str == null){
			vo.status = false;
			vo.data = "未知错误";
		}else{
			try{
				var obj :* = JSON.decode(str);
				vo.status = obj.status;
				vo.data = obj.data;
			}catch(e : Error){
				vo.status = false;
				vo.data = "未知错误";
			}
		}
		
		return vo;
	}
}
}
