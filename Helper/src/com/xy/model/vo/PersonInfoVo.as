package com.xy.model.vo {

/**
 * 人员信息
 * @author xy
 */
public class PersonInfoVo {

    public var id : int;

    /**
     * 头像图片地址
     */
    public var imgUrl : String;

    /**
     * 名字
     */
    public var name : String;

    /**
     * 公司名
     */
    public var company : String;

    /**
     * 部门名
     */
    public var department : String;

    /**
     * 联系电话
     */
    public var phone : String;

    /**
     * email
     */
    public var email : String;

    /**
     * 目标列表
     */
    public var taskList : Array;
}
}
