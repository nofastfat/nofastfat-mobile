package com.xy.view.ui {
import com.xy.model.vo.PersonInfoVo;
import com.xy.model.vo.SimpleTaskVo;
import com.xy.ui.SimpleInfoCard;
import com.xy.util.STool;
import com.xy.view.event.SSimpleInfoCardEvent;

import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.net.URLRequest;

/**
 * 人员信息卡片
 * @author xy
 */
public class SSimpleInfoCard extends SimpleInfoCard {
    private var _loader : Loader;
    private var _vo : PersonInfoVo;

    private var _tasks : Array = [];

    public function SSimpleInfoCard() {
        super();

        closeBtn.addEventListener(MouseEvent.CLICK, __closeHandler);
    }

    public function setData(vo : PersonInfoVo) : void {
        STool.clear(iconContainer, [iconContainer.bg]);
        _vo = vo;
        if (_loader != null) {
            _loader.unload();
        }
        _loader = new Loader();
        _loader.load(new URLRequest(vo.imgUrl));
        _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e : Event) : void {});
        _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e : Event) : void {
            _loader.width = iconContainer.bg.width - 4;
            _loader.height = iconContainer.bg.height - 4;
        });
        _loader.x = _loader.y = 2;
        iconContainer.addChild(_loader);

        nameTf.text = vo.name;
        departmentTf.text = vo.department;
        companyTf.text = vo.company;
        telTf.text = vo.phone;
        emailTf.text = vo.email;

        var startY : int = bg.scale9Grid.top;
        var taskHeight : int;
        for (var i : int = 0; i < vo.taskList.length; i++) {
            var svo : SimpleTaskVo = vo.taskList[i];
            var task : STaskList = _tasks[i];
            if (task == null) {
                task = new STaskList();
                task.detailBtn.addEventListener(MouseEvent.CLICK, __showTaskChildHandler);
                _tasks[i] = task;
            }

            task.setData(svo);
            taskHeight = task.height;

            addChild(task);
            task.x = 0;
            task.y = startY + i * (taskHeight + 5);
        }
        bg.height = startY + vo.taskList.length * (taskHeight + 5) + 20;

        for (i = vo.taskList.length; i < _tasks.length; i++) {
            task = _tasks[i];
            STool.remove(task);
        }
    }

    private function __showTaskChildHandler(e : MouseEvent) : void {
        var selfVo : SimpleTaskVo;
        var siblingVos : Array = [];
        var index : int = 0;
        for(var i : int = 0; i < _tasks.length; i++){
        	var list : STaskList = _tasks[i];
            if (list.detailBtn == e.currentTarget) {
                selfVo = list.vo;
                index = i;
            } else {
                siblingVos.push(list.vo);
            }
        }

        dispatchEvent(new SSimpleInfoCardEvent(SSimpleInfoCardEvent.SHOW_TASK_CHILD, selfVo, siblingVos, index));

    }

    private function __closeHandler(e : MouseEvent) : void {
        dispatchEvent(new SSimpleInfoCardEvent(SSimpleInfoCardEvent.CLOSE));
    }
}
}
