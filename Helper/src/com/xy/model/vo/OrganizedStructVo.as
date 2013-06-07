package com.xy.model.vo {
import com.adobe.serialization.json.JSON;
import com.xy.model.vo.uiStatus.SInfoCardStatus;

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

	/**
	 * ui显示的状态 
	 */
	public var cardStatus : SInfoCardStatus = new SInfoCardStatus();

    public static function fromJsonStr(jsonStr : String) : OrganizedStructVo {
        return fromJson(JSON.decode(jsonStr));
    }

    public static function fromJson(obj : *) : OrganizedStructVo {
        var vo : OrganizedStructVo = new OrganizedStructVo;
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
                        if (key == "subStuctList") {
                            fun = OrganizedStructVo.fromJson;
                        } else if (key == "simpleSubordinateList") {
                            fun = SimpleSubordinateVo.fromJson;
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

    public function getChild(childId : int) : OrganizedStructVo {
        if (id == childId) {
            return this;
        }
		
        if (subStuctList == null) {
            return null;
        }

        for each (var vo : OrganizedStructVo in subStuctList) {
            if (vo.id == childId) {
                return vo;
            }
        }

        for each (vo in subStuctList) {
            if (vo.getChild(childId) != null) {
                return vo;
            }
        }

        return null;
    }
    
    public function getVisibleChildIds() : Array{
    	var rs : Array = [];
    	  for each (var vo : OrganizedStructVo in subStuctList) {
            if (vo.cardStatus.visible) {
                rs.push(vo.id);
            }
            
            rs = rs.concat(vo.getVisibleChildIds());
        }
        
    	return rs;
    }
}
}
