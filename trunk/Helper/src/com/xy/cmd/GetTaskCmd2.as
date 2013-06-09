package com.xy.cmd {
import com.adobe.serialization.json.JSON;
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.TaskVo;
import com.xy.util.Http;
import com.xy.util.RandomName;
import com.xy.util.STool;
import com.xy.util.SingleLogicThread;
import com.xy.util.Tools;
import com.xy.view.TaskTreeContainerMediator;

import flash.utils.setTimeout;

import org.puremvc.as3.interfaces.INotification;

/**
 * 查询任务数据 查询指定节点的子节点
 * @author xy
 */
public class GetTaskCmd2 extends AbsCommand {

    /**
     * vo : TaskVo
     */
    public static const NAME : String = "GetTaskCmd2";
    private static var _thread : SingleLogicThread = new SingleLogicThread();

    private var _vo : TaskVo;

    public function GetTaskCmd2() {
        super();
    }

    override public function execute(notification : INotification) : void {
        _thread.startSending(executeDone, notification);

    }

    private function executeDone(notification : INotification) : void {
        _vo = notification.getBody() as TaskVo;
        LoadingController.showLoading();

        if (Config.DEBUG_MODE) {
            var jobTypes : Array = ["营销", "技术", "管理"];
            var taskNames : Array = ["2013年多兰之剑销售目标", "野怪清理", "GANK次数"];
            var taskValues : Array = ["1000万", "500万", "100"];
            var taskValues1 : Array = ["2000万", "1000万", "200"];

            var rs : Array = [];
            var len : int = STool.random(0, 10);
            for (var i : int = 0; i < len; i++) {
                var child : TaskVo = new TaskVo();

                child.company = "诺克萨斯公司";
                child.id = Tools.makeId();
                child.imgUrl = "http://127.0.0.1/heads/per_0" + STool.random(1, 3) + ".png";
                child.job = STool.randomFromArray(jobTypes);
                child.name = RandomName.makeName();
                child.statusPercent = STool.random(0, 100);
                child.statusValue = STool.random(0, 2);
                child.taskCurrentValue = STool.randomFromArray(taskValues);
                child.taskName = STool.randomFromArray(taskNames);
                child.taskValue = STool.randomFromArray(taskValues1);
                child.subLen = STool.random(0, 10);

                rs.push(child);
            }

            setTimeout(callback, 500, JSON.encode(rs));
        } else {
            new Http(Config.ACTION3_URL + "?currentId=" + _vo.id, callback);
        }
    }

    /**
     * childs:Array
     * @param data
     */
    private function callback(data : String) : void {
        _thread.clearSending();
        LoadingController.stopLoading();
        if (data == null || data == "" || data == "null") {
            LoadingController.showError();
            //sendNotification(TaskTreeContainerMediator.GET_TASK2_OK, _vo);
            return;
        }

        var json : Array = JSON.decode(data);
        _vo.subTaskList = [];

        var siblings : Array = [];
        for each (var obj : * in json) {
            var child : TaskVo = TaskVo.fromJson(obj);
            child.parent = _vo;
            _vo.subTaskList.push(child);
        }


        sendNotification(TaskTreeContainerMediator.GET_TASK2_OK, _vo);

        _vo = null;
    }

}
}
