package com.xy.cmd {
import com.adobe.serialization.json.JSON;
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.OrganizedStructVo;
import com.xy.model.vo.SimpleSubordinateVo;
import com.xy.util.Http;
import com.xy.util.RandomName;
import com.xy.util.STool;
import com.xy.util.SingleLogicThread;
import com.xy.util.Tools;
import com.xy.view.InfoTreeContainerMediator;

import flash.utils.setTimeout;

import org.puremvc.as3.interfaces.INotification;

/**
 * 获取组织机构数据
 * @author xy
 */
public class GetOrganizedStructCmd extends AbsCommand {
    public static const NAME : String = "GetOrganizedStructCmd";

    private static var _thread : SingleLogicThread = new SingleLogicThread();

    private var _requestVo : OrganizedStructVo;

    public function GetOrganizedStructCmd() {
        super();
    }


    override public function execute(notification : INotification) : void {
        _thread.startSending(executeDone, notification);

    }

    private function executeDone(notification : INotification) : void {
        var vo : OrganizedStructVo = notification.getBody() as OrganizedStructVo;
        _requestVo = vo;
        LoadingController.showLoading();

        if (Config.DEBUG_MODE) {
            //TODO testcode 获取组织机构数据
            var rs : Array = [];
            var departs : Array = ["销售部", "生产部", "公关部"];
            var jobTypes : Array = ["营销类", "技术类", "管理类"];
            for each (var svo : SimpleSubordinateVo in vo.simpleSubordinateList) {
                var tmp : OrganizedStructVo = new OrganizedStructVo();
                tmp.id = svo.id;
                tmp.company = "诺克萨斯公司";
                tmp.imgUrl = "http://127.0.0.1/heads/per_0" + STool.random(1, 3) + ".png";
                tmp.jobScore = STool.random(100, 3000);
                tmp.jobType = STool.randomFromArray(jobTypes) as String;
                tmp.joinTime = "2001-03-10";
                tmp.levelUpLastScore = STool.random(100, 1000);
                tmp.name = RandomName.makeName();
                tmp.powerMatrix = STool.random(1, 9);
                tmp.sex = STool.random(0, 1);
                tmp.simpleSubordinateList = [];
                tmp.status = STool.random(0, 2);
                var len : int = STool.random(0, 15);

                var ids : Array = STool.makeUnionRandomArray(1, 99, len);
                for (var i : int = 0; i < len; i++) {
                    var svo1 : SimpleSubordinateVo = new SimpleSubordinateVo();
                    svo1.department = STool.randomFromArray(departs);
                    svo1.id = Tools.makeId();
                    svo1.name = RandomName.makeName();
                    svo1.status = STool.random(0, 2);
                    tmp.simpleSubordinateList.push(svo1);
                }
                rs.push(tmp);
            }
            setTimeout(callback, 500, JSON.encode(rs));
        } else {
            new Http(Config.ACTION0_URL + "?parentId=" + vo.id, callback);
        }
    }

    private function callback(data : String) : void {
    	_thread.clearSending();
        LoadingController.stopLoading();
        if (data == null || data == "" || data == "null") {
            LoadingController.showError();
            //sendNotification(InfoTreeContainerMediator.GET_ORGANIZED_STRUCT_OK, _requestVo);
            return;
        }

        var arr : Array = JSON.decode(data);
        _requestVo.subStuctList = [];
        for each (var obj : * in arr) {
            var child : OrganizedStructVo = OrganizedStructVo.fromJson(obj)
            _requestVo.subStuctList.push(child);
            child.parent = _requestVo;
        }



        sendNotification(InfoTreeContainerMediator.GET_ORGANIZED_STRUCT_OK, _requestVo);
        _requestVo = null;
    }
}
}
