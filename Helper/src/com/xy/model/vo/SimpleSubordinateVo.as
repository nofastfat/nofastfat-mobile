package com.xy.model.vo {

/**
 * 简化的直属下属结构
 * @author xy
 */
public class SimpleSubordinateVo {

    public var id : int;

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
}
}
