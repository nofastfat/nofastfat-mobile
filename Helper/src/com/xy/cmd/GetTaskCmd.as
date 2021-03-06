package com.xy.cmd {
import com.adobe.serialization.json.JSON;
import com.xy.interfaces.AbsCommand;
import com.xy.model.Config;
import com.xy.model.vo.SimpleTaskVo;
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
 * 查询任务数据
 * 包括1级数据 和 选中节点的子节点
 * @author xy
 */
public class GetTaskCmd extends AbsCommand {

    /**
     * [currentVo : SimpletaskVo, siblingVos : Array]
     */
    public static const NAME : String = "GetTaskCmd";
    private static var _thread : SingleLogicThread = new SingleLogicThread();


    private var _currentVo : SimpleTaskVo;
    private var _siblingVos : Array;
    private var _index : int;

    public function GetTaskCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
        _thread.startSending(executeDone, notification);

    }

    private function executeDone(notification : INotification) : void {
        _currentVo = notification.getBody()[0];
        _siblingVos = notification.getBody()[1];
        _index = notification.getBody()[2];
        LoadingController.showLoading();

        if (Config.DEBUG_MODE) {
            var currentTask : TaskVo = new TaskVo();
            var jobTypes : Array = ["营销", "技术", "管理"];
            var taskNames : Array = ["2013年多兰之剑销售目标", "野怪清理", "GANK次数"];
            var taskValues : Array = ["1000万", "500万", "100"];
            var taskValues1 : Array = ["2000万", "1000万", "200"];

            currentTask.company = "诺克萨斯公司";
            currentTask.id = _currentVo.id;
            currentTask.imgUrl = "http://127.0.0.1/heads/" + STool.random(1, 3) + ".png";
            currentTask.job = STool.randomFromArray(jobTypes);
            currentTask.name = RandomName.makeName();
            currentTask.statusPercent = STool.random(0, 100);
            currentTask.statusValue = STool.random(0, 2);
            currentTask.taskCurrentValue = STool.randomFromArray(taskValues);
            currentTask.taskName = _currentVo.taskName;
            currentTask.taskValue = _currentVo.taskValue;
            currentTask.subTaskList = [];
			currentTask.decideTime = "2000-2-14";
			currentTask.titleInfo =  STool.copyChar("标题详情", STool.random(2, 10));
			currentTask.auditMan = RandomName.makeName();
			currentTask.auditSuggest = STool.copyChar("审核意见", STool.random(2, 10));
			currentTask.auditTime = "2013-3-14";
            var len : int = STool.random(0, 10);
            currentTask.subLen = len;
            for (var i : int = 0; i < len; i++) {
                var child : TaskVo = new TaskVo();

                child.company = "诺克萨斯公司";
                child.id = Tools.makeId();
                child.imgUrl = "http://127.0.0.1/heads/" + STool.random(1, 3) + ".png";
                child.job = STool.randomFromArray(jobTypes);
                child.name = RandomName.makeName();
                child.statusPercent = STool.random(0, 100);
                child.statusValue = STool.random(0, 2);
                child.taskCurrentValue = STool.randomFromArray(taskValues);
                child.taskName = STool.randomFromArray(taskNames);
                child.taskValue = STool.randomFromArray(taskValues1);
                child.subLen = STool.random(0, 10);
				child.decideTime = "2000-2-14";
				child.titleInfo =  STool.copyChar("标题详情", STool.random(2, 10));
				child.auditMan = RandomName.makeName();
				child.auditSuggest = STool.copyChar("审核意见", STool.random(2, 10));
				child.auditTime = "2013-3-14";
                currentTask.subTaskList.push(child);
            }

            var sibs : Array = [];
            for each (var svo : SimpleTaskVo in _siblingVos) {
                var sib : TaskVo = new TaskVo();

                sib.company = "诺克萨斯公司";
                sib.id = svo.id
                sib.imgUrl = "http://127.0.0.1/heads/" + STool.random(1, 3) + ".png";
                sib.job = STool.randomFromArray(jobTypes);
                sib.name = RandomName.makeName();
                sib.statusPercent = STool.random(0, 100);
                sib.statusValue = STool.random(0, 2);
                sib.taskCurrentValue = STool.randomFromArray(taskValues);
                sib.taskName = svo.taskName;
                sib.taskValue = svo.taskValue;
                sib.subLen = STool.random(0, 10);
				sib.decideTime = "2000-2-14";
				sib.titleInfo =  STool.copyChar("标题详情", STool.random(2, 10));
				sib.auditMan = RandomName.makeName();
				sib.auditSuggest = STool.copyChar("审核意见", STool.random(2, 10));
				sib.auditTime = "2013-3-14";

                sibs.push(sib);
            }

            var rs : * = {};
            rs.current = currentTask;
            rs.siblings = sibs;

            setTimeout(callback, 500, com.adobe.serialization.json.JSON.encode(rs));
        } else {


            var currentId : String = _currentVo.id;
            var siblingIds : Array = [];
            for each (var vo : SimpleTaskVo in _siblingVos) {
                siblingIds.push(vo.id);
            }
            new Http(Config.ACTION2_URL + "?currentId=" + currentId + "&siblingIds=" + siblingIds.join(","), callback);
        }
    }

    /**
     * {current:TaskVo, siblings:Array}
     * @param data
     */
    private function callback(data : String) : void {
    	_thread.clearSending();
        LoadingController.stopLoading();
        if (data == null || data == "" || data == "null") {
            LoadingController.showError();
            //sendNotification(TaskTreeContainerMediator.GET_TASK_OK, [null, [], _index]);
            return;
        }

        var vitrulParent : TaskVo = new TaskVo();
        vitrulParent.subTaskList = [];

        var json : * = com.adobe.serialization.json.JSON.decode(data);
        var vo : TaskVo = TaskVo.fromJson(json.current);
        vitrulParent.subTaskList.push(vo);
        vo.parent = vitrulParent;

        dataProxy.taskDatas.put(vo.id, vo);
        for each (var child : TaskVo in vo.subTaskList) {
            child.parent = vo;
        }

        var siblings : Array = [];
        for each (var obj : * in json.siblings) {
            var sibVo : TaskVo = TaskVo.fromJson(obj);
            dataProxy.taskDatas.put(sibVo.id, sibVo);
            siblings.push(sibVo);
            vitrulParent.subTaskList.push(sibVo);
            sibVo.parent = vitrulParent;
        }


        sendNotification(TaskTreeContainerMediator.GET_TASK_OK, [vo, siblings, _index]);

        _currentVo = null;
        _siblingVos = [];
    }
}
}
