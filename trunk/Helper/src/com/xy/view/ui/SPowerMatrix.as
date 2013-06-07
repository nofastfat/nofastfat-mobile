package com.xy.view.ui {
import com.xy.model.vo.OrganizedStructVo;
import com.xy.ui.PowerMatrix;
import com.xy.view.event.SPowerMatrixEvent;

import flash.display.MovieClip;
import flash.events.MouseEvent;

/**
 * 能力矩阵
 * @author xy
 */
public class SPowerMatrix extends PowerMatrix {
    public function SPowerMatrix() {
        super();
        closeBtn.addEventListener(MouseEvent.CLICK, __closeHandler);
    }

    public function setData(vo : OrganizedStructVo) : void {
        for (var i : int = 1; i < 10; i++) {
            var mc : MovieClip = this["matrix" + i];
            mc.gotoAndStop(1);
        }

        mc = this["matrix" + vo.powerMatrix];
        nameTf.text = vo.name;
        if (mc != null) {
            mc.gotoAndStop(vo.powerMatrixValue + 2);
        }
    }

    private function __closeHandler(e : MouseEvent) : void {
        dispatchEvent(new SPowerMatrixEvent(SPowerMatrixEvent.CLOSE));
    }

}
}
