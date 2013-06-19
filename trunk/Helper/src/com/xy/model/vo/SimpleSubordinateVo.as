package com.xy.model.vo {

/**
 * 简化的直属下属结构
 * @author xy
 */
public class SimpleSubordinateVo {

    public var id : String;

    /**
     * 名字
     */
    public var name : String;

    /**
     * 部门
     */
    public var department : String;
	
    /**
     * 离职风险
     * 0==低， 1==中， 2==高
     */
    public var status : int;
	
	public static function fromJson(obj : *) : SimpleSubordinateVo{
		var vo : SimpleSubordinateVo = new SimpleSubordinateVo;
		for (var key : String in obj) {
			var type : String = typeof obj[key];
			switch (type) {
				case "number":
					vo[key] = int(obj[key]);
					break;
				default:
					vo[key] = String(obj[key]);
			}
		}
		return vo;
	}
}
}
