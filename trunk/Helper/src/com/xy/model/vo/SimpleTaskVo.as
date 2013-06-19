package com.xy.model.vo {

/**
 * 简化的目标结构
 * @author xy
 */
public class SimpleTaskVo {
    public var id : String;

    /**
     * 目标名
     */
    public var taskName : String;

    /**
     * 目标值
     */
    public var taskValue : String;

    public static function fromJson(obj : *) : SimpleTaskVo {
        var vo : SimpleTaskVo = new SimpleTaskVo;
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
