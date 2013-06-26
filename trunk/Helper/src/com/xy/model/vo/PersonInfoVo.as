package com.xy.model.vo {
import com.adobe.serialization.json.JSON;


/**
 * 人员信息
 * @author xy
 */
public class PersonInfoVo {

    public var id : String;

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
     * [SimpleTaskVo, SimpleTaskVo, ...]
     */
    public var taskList : Array;

    public static function fromJsonStr(jsonStr : String) : PersonInfoVo {
        return fromJson(JSON.decode(jsonStr));
    }

    public static function fromJson(obj : *) : PersonInfoVo {
        var vo : PersonInfoVo = new PersonInfoVo;
        for (var key : String in obj) {
            var type : String = typeof obj[key];
            if (key == "id") {
                vo.id = obj["id"];
            } else {
                switch (type) {
                    case "number":
                        vo[key] = int(obj[key]);
                        break;
                    case "object":
                        var arr : Array = obj[key] as Array;
                        if (arr != null) {
                            var fun : Function = SimpleTaskVo.fromJson;

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
        }
        return vo;
    }
}
}
