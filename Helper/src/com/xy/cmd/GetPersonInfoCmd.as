package com.xy.cmd {
import com.adobe.serialization.json.JSON;
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.PersonInfoVo;
import com.xy.model.vo.SimpleTaskVo;
import com.xy.util.Http;
import com.xy.util.STool;
import com.xy.util.SingleLogicThread;
import com.xy.util.Tools;
import com.xy.view.InfoTreeContainerMediator;

import flash.display.DisplayObject;
import flash.utils.setTimeout;

import org.puremvc.as3.interfaces.INotification;

/**
 * 请求人员信息
 * @author xy
 */
public class GetPersonInfoCmd extends AbsCommand {
    /**
     * [id:int, target:mc]
     */
    public static const NAME : String = "GetPersonInfoCmd";
    private static var _thread : SingleLogicThread = new SingleLogicThread();

    private var _id : String;
    private var _mc : DisplayObject;

    public function GetPersonInfoCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
        _thread.startSending(executeDone, notification);

    }

    private function executeDone(notification : INotification) : void {
        _id = notification.getBody()[0];
        _mc = notification.getBody()[1];
        var name : String = notification.getBody()[2];
        LoadingController.showLoading();

        if (Config.DEBUG_MODE) {
            //TODO testcode 获取人员信息数据
            var departs : Array = ["销售部", "生产部", "公关部"];
            var vo : PersonInfoVo = new PersonInfoVo();
            vo.id = _id;
            vo.company = "诺克萨斯公司";
            vo.department = STool.randomFromArray(departs);
            vo.email = "xxxx@mail.com";
            vo.imgUrl = "http://127.0.0.1/heads/" + STool.random(1, 3) + ".png";
            vo.name = name;
            vo.phone = "110119";

            vo.taskList = [];
            var len : int = STool.random(2, 20);
            var taskNames : Array = ["2013年多兰之剑销售目标", "野怪清理", "GANK次数"];
            var taskValues : Array = ["2000万", "1000万", "200"];
            for (var i : int = 0; i < len; i++) {
                var svo : SimpleTaskVo = new SimpleTaskVo();
                svo.id = Tools.makeId();
                svo.taskName = STool.randomFromArray(taskNames);
                svo.taskValue = STool.randomFromArray(taskValues);
                vo.taskList.push(svo);
            }

            setTimeout(callback, 500, com.adobe.serialization.json.JSON.encode(vo));
        } else {
            new Http(Config.ACTION1_URL + "?personId=" + _id, callback);
        }

    }

    private function callback(data : String) : void {
    	_thread.clearSending();
        LoadingController.stopLoading();
        if (data == null || data == "" || data == "null") {
        	LoadingController.showError();
            //sendNotification(InfoTreeContainerMediator.GET_PERSON_INFO_OK, [_id, null]);
            return;
        }

        var vo : PersonInfoVo = PersonInfoVo.fromJsonStr(data);

        dataProxy.personDatas.put(_id, vo);


        sendNotification(InfoTreeContainerMediator.GET_PERSON_INFO_OK, [_id, _mc]);

        _mc = null;
    }
}
}
