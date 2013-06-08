package com.xy.view.ui {
import com.xy.component.toolTip.ToolTip;
import com.xy.component.toolTip.enum.ToolTipMode;
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
        ToolTip.setSimpleTip(detailBtn, "查看任务分配", ToolTipMode.RIGHT_BOTTOM_CENTER);
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
