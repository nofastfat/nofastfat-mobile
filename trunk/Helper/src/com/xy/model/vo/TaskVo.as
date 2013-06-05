package com.xy.model.vo {

/**
 * 任务目标
 * @author xy
 */
public class TaskVo {
    public var id : int;

    /**
     *  目标名
     */
    public var taskName : String;

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
     * 职务
     */
    public var job : String;

    /**
     * 目标值
     */
    public var taskValue : int;

    /**
     * 完成度状态
     */
    public var statusPercent : int;

    /**
     * 完成度值
     */
    public var statusValue : int;

    /**
     * 子目标列表
	 * null表示未初始化
     * [TaskVo, TaskVo, ...]
     */
    public var subTaskList : Array;

}
}
