package com.xy.model.vo {

/**
 * 组织机构
 * @author xy
 */
public class OrganizedStructVo {
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
     * 性别:
     * 0==男，1==女
     */
    public var sex : int;

    /**
     * 公司名
     */
    public var company : String;

    /**
     * 离职风险
     * 0==低， 1==中， 2==高
     */
    public var status : int;

    /**
     * 人才类型
     */
    public var jobType : String;

    /**
     * 任职日期
     * 格式:2013-1-12
     */
    public var joinTime : String;

    /**
     * 我的岗位积分
     */
    public var jobScore : int;

    /**
     * 升值还差积分
     */
    public var levelUpLastScore : int;

    /**
     * 直属列表
     * [SimpleSubordinateVo, SimpleSubordinateVo, ...]
     */
    public var simpleSubordinateList : Array;

    /**
     * 能力矩阵值
     * 从高到低， 1-9
     */
    public var powerMatrix : int;

    /**
     * 直属列表详情
     * null表示未初始化
     * [OrganizedStructVo, OrganizedStructVo, ...]
     */
    public var subStuctList : Array;

}
}
