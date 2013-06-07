package com.xy.view.ui {
import com.greensock.TweenLite;
import com.xy.model.vo.TaskVo;
import com.xy.ui.TaskCard;
import com.xy.util.STool;
import com.xy.view.event.STaskCardEvent;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * 目标卡片
 * @author xy
 */
public class STaskCard extends TaskCard {
    private var _vo : TaskVo;

    private var _rect : Rectangle;

    private var _selected : Boolean = false;

    public function STaskCard() {
        super();
        _rect = new Rectangle(0, 0, width, height);
        ctrlBtn.addEventListener(MouseEvent.CLICK, __showChildHandler);

    }

    public function setData(vo : TaskVo) : void {
        _vo = vo;

        targetTf.text = _vo.taskName;
        nameTf.text = _vo.name;
        jobTf.text = _vo.job;
        companyTf.text = _vo.company;
        totalTaskTf.text = _vo.taskValue;
        taskValueTf.text = _vo.taskCurrentValue;
        stateMc.gotoAndStop(_vo.statusValue + 1);
        bg.gotoAndStop(_vo.statusValue + 1);
        ctrlBtn.gotoAndStop(_vo.statusValue + 1);


        var per : Number = _vo.statusPercent / 100;

        if (per < 0) {
            per = 0;
        }

        if (per > 1) {
            per = 1;
        }

        TweenLite.to(statusBar.bar, 0.3, {width: (statusBar.bg.width - 2) * per, overwrite: true})


    }

    public function get vo() : TaskVo {
        return _vo;
    }

    public function setCtrlBtnSelect(selected : Boolean) : void {
        _selected = selected;
    }

    private function __showChildHandler(e : MouseEvent) : void {
        _selected = !_selected;
        dispatchEvent(new STaskCardEvent(STaskCardEvent.SHOW_DETAIL, _vo, _selected));
    }

    public function showTo(parent : Sprite) : void {
        super.x = _vo.cardStatus.locationX;
        super.y = _vo.cardStatus.locationY;

        parent.addChild(this);
        _vo.cardStatus.setVisible(true);
    }

    public function hide(hideById : int) : void {
        STool.remove(this);
        _vo.cardStatus.setVisible(false, hideById);
    }

    override public function set x(value : Number) : void {
        super.x = value;
        _vo.cardStatus.locationX = value;
        _rect.x = value;
    }

    override public function set y(value : Number) : void {
        super.y = value;
        _vo.cardStatus.locationY = value;
        _rect.y = value;
    }

    /**
     * 底部中点的坐标
     * @return
     */
    public function get rightCenterLoaction() : Point {
        return new Point(this.x + this.width + 3, this.y + bg.height / 2);
    }

    public function get rect() : Rectangle {
        return _rect;
    }
    
    public function get selected() : Boolean {
    	return _selected;
    }
}
}
