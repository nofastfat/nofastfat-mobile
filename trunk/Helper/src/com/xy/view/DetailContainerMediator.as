package com.xy.view {
import com.greensock.TweenLite;
import com.xy.component.toolTip.ToolTip;
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.vo.OrganizedStructVo;
import com.xy.model.vo.PersonInfoVo;
import com.xy.util.EnterFrameCall;
import com.xy.util.STool;
import com.xy.view.event.SPowerMatrixEvent;
import com.xy.view.event.SSimpleInfoCardEvent;
import com.xy.view.layer.DetailContainer;
import com.xy.view.ui.SPowerMatrix;
import com.xy.view.ui.SSimpleInfoCard;

import flash.display.DisplayObject;
import flash.geom.Point;

public class DetailContainerMediator extends AbsMediator {
    public static const NAME : String = "DetailContainerMediator";

    /**
     * 显示能力矩阵
     * [startLoaction : Point, vo : OrganizedStructVo ]
     */
    public static const SHOW_POWER_MATRIX : String = NAME + "SHOW_POWER_MATRIX";

    /**
     * 显示人员卡片
     * [vo:PersonInfoVo, mc:mc]
     */
    public static const SHOW_PEROSON_CARD : String = NAME + "SHOW_PEROSON_CARD";

    private var _matrix : SPowerMatrix;
    private var _personCard : SSimpleInfoCard;

    public function DetailContainerMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);

        checkContent();
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(SHOW_POWER_MATRIX, showPowerMatrix);
        map.put(SHOW_PEROSON_CARD, showPerosonCard);
        return map;
    }

    /**
     * 显示/隐藏 能力矩阵
     * @param target
     * @param vo
     */
    private function showPowerMatrix(startLoaction : Point, vo : OrganizedStructVo) : void {
        if (_matrix == null) {
            _matrix = new SPowerMatrix();
            _matrix.addEventListener(SPowerMatrixEvent.CLOSE, __closeMatrixHandler);
        }
        ui.visible = true;
        STool.remove(_personCard);
        _matrix.setData(vo);
        _matrix.alpha = 1;
        var targetLocation : Point = new Point((ui.sWidth - _matrix.width) / 2, (ui.sHeight - _matrix.height) / 2);
        if (targetLocation.x + _matrix.width > ui.sWidth) {
            targetLocation.x = ui.sWidth - _matrix.width - 10;
        }

        var stageLocation : Point = ui.localToGlobal(targetLocation);
        EnterFrameCall.getStage().addChild(_matrix);
        _matrix.x = stageLocation.x;
        _matrix.y = stageLocation.y;
        _matrix.scaleX = _matrix.scaleY = 1;

        TweenLite.from(_matrix, 0.3, {overwrite: true, x: startLoaction.x, y: startLoaction.y, alpha: 0.3, scaleX: 0.2, scaleY: 0.2, onComplete: function() : void {
            STool.remove(_matrix);
            ui.addChild(_matrix);
            _matrix.x = targetLocation.x;
            _matrix.y = targetLocation.y;
        }});

    }

    private function checkContent() : void {
        ui.visible = ui.numChildren  > 1;
    }

    private function showPerosonCard(vo : PersonInfoVo, mc : DisplayObject) : void {
        if (vo == null) {
            return;
        }

        ui.visible = true;
        STool.remove(_matrix);
        if (_personCard == null) {
            _personCard = new SSimpleInfoCard();
            _personCard.addEventListener(SSimpleInfoCardEvent.CLOSE, __closePersonCardHandler);
            _personCard.addEventListener(SSimpleInfoCardEvent.SHOW_TASK_CHILD, __showTaskChildHandle);
        }

        _personCard.setData(vo);
        _personCard.alpha = 1;
        var startP : Point = new Point();
        if (mc != null) {
            startP.x = mc.x;
            startP.y = mc.y;

            startP = mc.parent.localToGlobal(startP);
        }
        EnterFrameCall.getStage().addChild(_personCard);

        var targetLocation : Point = new Point((ui.sWidth - _personCard.width) / 2, (ui.sHeight - _personCard.height) / 2);
        if (targetLocation.x + _personCard.width > ui.sWidth) {
            targetLocation.x = ui.sWidth - _personCard.width - 10;
        }
        var stageLocation : Point = ui.localToGlobal(targetLocation);

        _personCard.x = stageLocation.x;
        _personCard.y = stageLocation.y;
        _personCard.scaleX = _personCard.scaleY = 1;

        TweenLite.from(_personCard, 0.3, {overwrite: true, x: startP.x, y: startP.y, alpha: 0.3, scaleX: 0.2, scaleY: 0.2, onComplete: function() : void {
            STool.remove(_personCard);
            ui.addChild(_personCard);
            _personCard.x = targetLocation.x;
            _personCard.y = targetLocation.y;
        }});
    }

    private function __closeMatrixHandler(e : SPowerMatrixEvent) : void {
        if (_matrix == null) {
            return;
        }

        TweenLite.to(_matrix, 0.3, {x: _matrix.x + 300, alpha: 0.3, overwrite: true, onComplete: function() : void {
            STool.remove(_matrix);
            checkContent();
        }});
    }

    private function __closePersonCardHandler(e : SSimpleInfoCardEvent) : void {
        if (_personCard == null) {
            return;
        }

        TweenLite.to(_personCard, 0.3, {x: _personCard.x + 300, alpha: 0.3, overwrite: true, onComplete: function() : void {
            STool.remove(_personCard);

            checkContent();
        }});
    }

    private function __showTaskChildHandle(e : SSimpleInfoCardEvent) : void {
        __closePersonCardHandler(null);
        ToolTip.hideTip();
        sendNotification(TaskTreeContainerMediator.INIT_SHOW, [e.currentVo, e.siblingVos, e.index]);
    }

    public function get ui() : DetailContainer {
        return viewComponent as DetailContainer;
    }
}
}
