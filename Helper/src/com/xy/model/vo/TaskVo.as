package com.xy.model.vo {
import com.adobe.serialization.json.JSON;
import com.xy.model.vo.uiStatus.STaskStatus;


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
    public var taskValue : String;


    /**
     * 当前完成值
     */
    public var taskCurrentValue : String;

    /**
     * 完成度状态
     * 0-2：高，中，低
     */
    public var statusValue : int;

    /**
     * 完成百分比
     * 0-100
     */
    public var statusPercent : int;

    /**
     * 子目标列表
     * null表示未初始化
     * [TaskVo, TaskVo, ...]
     */
    public var subTaskList : Array;

	/**
	 * 子节点的数量 
	 */
	public var subLen : int;



    public var parent : TaskVo;

    /**
     * ui显示的状态
     */
    public var cardStatus : STaskStatus = new STaskStatus();

    public function getHideChildIdsBy(hideId : int) : Array {
        var rs : Array = [];
        for each (var vo : TaskVo in subTaskList) {
            if (!vo.cardStatus.visible && vo.cardStatus.hideById == hideId) {
                rs.push(vo.id);
            }

            rs = rs.concat(vo.getHideChildIdsBy(hideId));
        }

        return rs;
    }

    /**
     * 获取兄弟节点
     * [OrganizedStructVo, OrganizedStructVo, ...]
     * @return
     */
    public function getSiblingVos() : Array {
        var rs : Array = [];
        if (parent == null) {
            return rs;
        }

        for each (var siblingVo : TaskVo in parent.subTaskList) {
            if (siblingVo.id != this.id) {
                rs.push(siblingVo);
            }
        }
        return rs;
    }

    /**
     * 获取所有正在显示的子节点的id
     * @return
     */
    public function getVisibleChildIds() : Array {
        var rs : Array = [];
        for each (var vo : TaskVo in subTaskList) {
            if (vo.cardStatus.visible) {
                rs.push(vo.id);
            }

            rs = rs.concat(vo.getVisibleChildIds());
        }

        return rs;
    }

    public static function fromJsonStr(jsonStr : String) : TaskVo {
        return fromJson(JSON.decode(jsonStr));
    }

    public static function fromJson(obj : *) : TaskVo {
        var vo : TaskVo = new TaskVo;
        for (var key : String in obj) {
            var type : String = typeof obj[key];
            switch (type) {
                case "number":
                    vo[key] = int(obj[key]);
                    break;
                case "object":
                    var arr : Array = obj[key] as Array;
                    if (arr != null) {
                        var fun : Function;
                        if (key == "subTaskList") {
                            fun = TaskVo.fromJson;
                        }

                        if (fun != null) {
                            var rs : Array = [];
                            for each (var subObj : * in arr) {
                                rs.push(fun(subObj));
                            }

                            vo[key] = rs;
                        }
                    }


                    break;
                default:
                    vo[key] = String(obj[key]);
            }
        }
        return vo;
    }
}
}