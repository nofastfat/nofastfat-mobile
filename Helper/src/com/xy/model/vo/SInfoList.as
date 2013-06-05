package com.xy.model.vo {
import com.xy.ui.InfoList;

public class SInfoList extends InfoList {
    private var _vo : SimpleSubordinateVo;

    public function SInfoList() {
        super();
    }

    public function get vo() : SimpleSubordinateVo {
        return _vo;
    }

    public function setData(vo : SimpleSubordinateVo) : void {
        _vo = vo;

        nameTf.text = vo.name;
        departmentTf.text = vo.department;
        gotoAndStop(vo.status + 1);
    }
}
}
