package com.xy.view.ui {
import com.xy.model.vo.SimpleTaskVo;
import com.xy.ui.TaskList;

/**
 * 人员信息中的任务目标
 * @author xy
 */
public class STaskList extends TaskList {
    private var _vo : SimpleTaskVo;

    public function STaskList() {
        super();
    }

    public function setData(vo : SimpleTaskVo) : void {
        _vo = vo;
        taskTf.text = vo.taskName;
        valueTf.text = vo.taskValue;
    }

    public function get vo() : SimpleTaskVo {
        return _vo;
    }
}
}
