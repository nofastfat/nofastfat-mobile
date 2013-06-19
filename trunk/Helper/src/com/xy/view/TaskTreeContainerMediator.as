package com.xy.view {
import com.xy.cmd.GetTaskCmd;
import com.xy.cmd.GetTaskCmd2;
import com.xy.component.toolTip.ToolTip;
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.vo.SimpleTaskVo;
import com.xy.model.vo.TaskVo;
import com.xy.util.EnterFrameCall;
import com.xy.util.STool;
import com.xy.util.Tools;
import com.xy.view.event.STaskCardEvent;
import com.xy.view.event.TreeContainerEvent;
import com.xy.view.layer.TreeContainer;
import com.xy.view.ui.STaskCard;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * 任务 树
 * @author xy
 */
public class TaskTreeContainerMediator extends AbsMediator {
    public static const NAME : String = "TaskTreeContainerMediator";

    /**
     *  初始显示
     * [curretntVo : SimpleTaskVo, siblingVos : Array, index:int]
     */
    public static const INIT_SHOW : String = NAME + "INIT_SHOW";

    /**
     * 请求任务数据完成 包括一级数据 和 子节点
     * [vo:TaskVo, siblingVos:Array]
     */
    public static const GET_TASK_OK : String = NAME + "GET_TASK_OK";

    /**
     * 请求任务数据完成 子节点数据
     * vo:TaskVo
     */
    public static const GET_TASK2_OK : String = NAME + "GET_TASK2_OK";

    private var _cards : Map = new Map();
    private var _lines : Map = new Map();

    private var _rsX : Number = 0;
    private var _rsY : Number = 0;
    private var _rsScale : Number = 0;
    private var _camaraRect : Rectangle;

    public function TaskTreeContainerMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);

        uiContainer.addEventListener(TreeContainerEvent.LOCATION_MOVE, __moveHandler);
        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_WHEEL, __mouseWheelHandler);
        _camaraRect = new Rectangle(-uiContainer.x, -uiContainer.y, ui.sWidth, ui.sHeight);
        ui.switchBtn.addEventListener(MouseEvent.CLICK, __switchToInfoHandler);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(INIT_SHOW, initShow);
        map.put(Event.RESIZE, resize);
        map.put(GET_TASK_OK, getTaskOk);
        map.put(GET_TASK2_OK, getTask2Ok);
        map.put(InfoTreeContainerMediator.SCALE_CHANGE, scaleChange);
        return map;
    }

    private function scaleChange(offset : Number) : void {
        if (uiContainer.stage != null) {
            _rsScale += offset;

            if (_rsScale != 0) {
                EnterFrameCall.add(scale);
            }
        }
    }

    /**
     * 初始化的显示
     */
    private function initShow(curretntVo : SimpleTaskVo, siblingVos : Array, index : int) : void {
        ui.switchContainer(false);

        sendNotification(SUIPanelMediator.REST_SCALE, ui.taskContainer.scaleX);

        var currentTask : TaskVo = dataProxy.taskDatas.get(curretntVo.id);
        var siblingTask : Array = [];
        for each (var sibVo : SimpleTaskVo in siblingVos) {
            var tmp : TaskVo = dataProxy.taskDatas.get(sibVo.id);
            if (tmp != null) {
                siblingTask.push(tmp);
            }
        }

        if (currentTask == null || siblingTask.length != siblingVos.length || currentTask.subTaskList == null) {
            sendNotification(GetTaskCmd.NAME, [curretntVo, siblingVos, index]);
        } else {
            getTaskOk(currentTask, siblingTask, index);
        }
    }

    private function resize(... rest) : void {
//        if (_treeRoot != null) {
//            _treeRoot.x = (ui.sWidth - _treeRoot.width) / 2;
//            _treeRoot.y = (ui.sHeight - _treeRoot.height) / 2;
//        }
    }

    private function __switchToInfoHandler(e : MouseEvent) : void {
        ui.switchContainer(true);
        hideAll();
        ToolTip.hideTip();

        sendNotification(SUIPanelMediator.REST_SCALE, ui.infoContainer.scaleX);
    }

    public function hideAll() : void {
        STool.clear(uiContainer);
        for each (var card : STaskCard in _cards) {
            card.hide("-1");
        }
    }

    private function getTaskOk(vo : TaskVo, siblings : Array, index : int) : void {
        if (siblings != null) {
            initRoots(vo, siblings, index);
        }
        addChilds(vo);
    }

    private function getTask2Ok(vo : TaskVo) : void {
        addChilds(vo);
    }

    private function initRoots(surrentVo : TaskVo, siblings : Array, index : int) : void {
        siblings.splice(index, 0, surrentVo);
        for (var i : int = 0; i < siblings.length; i++) {
            var vo : TaskVo = siblings[i];
            var card : STaskCard = _cards.get(vo.id);
            if (card == null) {
                card = new STaskCard();
                _cards.put(vo.id, card);
                card.addEventListener(TreeContainerEvent.LOCATION_MOVE, __moveHandler);
                card.addEventListener(STaskCardEvent.SHOW_DETAIL, __showDetailHandler);
            }
            card.setData(vo);
            card.showTo(uiContainer);

            card.x = 0;
            card.y = i * (card.height + 20);
        }
    }

    /**
     * 隐藏指定节点的兄弟节点数
     * @param vo
     */
    private function hideSiblingCards(vo : TaskVo) : void {
        var siblings : Array = vo.getSiblingVos();
        for each (var siblingVo : TaskVo in siblings) {
            var card : STaskCard = _cards.get(siblingVo.id);
            if (card.selected) {
                card.setCtrlBtnSelect(false);
                var visibles : Array = siblingVo.getVisibleChildIds();
                hideCards(siblingVo, visibles);
            }
        }
    }

    private function addChilds(vo : TaskVo) : void {
        hideSiblingCards(vo);
        var parentCard : STaskCard = _cards.get(vo.id);
        parentCard.setCtrlBtnSelect(true);

        if (vo.subTaskList == null) {
            //TODO 请求组织机构数据失败了	
            return;
        } else {
            var len : int = vo.subTaskList.length;
            var totalHeight : int = len * (parentCard.height + 20) - 20;
            var rightCenterPoint : Point = parentCard.rightCenterLoaction;
            var startX : int = rightCenterPoint.x + 100;
            var startY : int = rightCenterPoint.y - totalHeight / 2;

            for (var i : int = 0; i < len; i++) {
                var subVo : TaskVo = vo.subTaskList[i];
                subVo.parent = vo;
                var card : STaskCard = _cards.get(subVo.id);
                if (card == null) {
                    card = new STaskCard();
                    card.addEventListener(TreeContainerEvent.LOCATION_MOVE, __moveHandler);
                    card.addEventListener(STaskCardEvent.SHOW_DETAIL, __showDetailHandler);
                    _cards.put(subVo.id, card);
                }
                subVo.cardStatus.parentCard = parentCard;
                card.setData(subVo);
                card.showTo(uiContainer);
                card.x = startX;
                card.y = startY + (parentCard.height + 20) * i;

                var line : Shape = _lines.get(subVo.id);
                var secP : Point = new Point(startX, card.y + parentCard.height / 2);
                secP = secP.subtract(rightCenterPoint);
                if (line == null) {
                    line = Tools.makeConactLine2(new Point(), secP);

                    if (secP.y < 0) {
                        line.name = "scaled";
                    }
                }
                uiContainer.addChild(line);
                line.x = rightCenterPoint.x;
                line.y = rightCenterPoint.y;
                _lines.put(subVo.id, line);
            }
        }

        /* 展开的东西剧中显示 */
        var p : Point = new Point(parentCard.x + parentCard.width + 50, parentCard.y + parentCard.height / 2);
        p = uiContainer.localToGlobal(p);
        _rsX += ui.sWidth / 2 - p.x;
        _rsY += ui.sHeight / 2 - p.y;
        if (_rsX != 0 || _rsY != 0) {
            EnterFrameCall.add(move);
        }
    }

    public function get ui() : TreeContainer {
        return viewComponent as TreeContainer;
    }

    public function get uiContainer() : Sprite {
        return (viewComponent as TreeContainer).taskContainer;
    }

    private function __moveHandler(e : TreeContainerEvent) : void {
        _rsX += e.offsetX;
        _rsY += e.offsetY;

        if (_rsX != 0 || _rsY != 0) {
            EnterFrameCall.add(move);
        }
    }

    private function __showDetailHandler(e : STaskCardEvent) : void {
        var vo : TaskVo = e.vo;
        if (e.selected) {
            if (vo.subTaskList == null || vo.subTaskList.length != vo.subLen) {
                sendNotification(GetTaskCmd2.NAME, vo);
            } else {
                getTask2Ok(vo);
                showCards(vo.getHideChildIdsBy(vo.id));
            }
        } else {
            hideCards(vo, vo.getVisibleChildIds());
        }
    }

    /**
     * 隐藏组织机构
     * @param vo
     * @param ids
     */
    private function hideCards(vo : TaskVo, ids : Array) : void {
        for each (var id : int in ids) {
            var card : STaskCard = _cards.get(id);
            if (card != null) {
                card.hide(vo.id);
            }

            var line : Shape = _lines.get(id);
            STool.remove(line);
        }
    }

    /**
     * 显示组织机构
     * @param ids
     */
    private function showCards(ids : Array) : void {
        for each (var id : int in ids) {
            var card : STaskCard = _cards.get(id);
            if (card != null) {
                card.showTo(uiContainer);
            }

            var line : Shape = _lines.get(id);
            if (line != null) {
                uiContainer.addChild(line);
                var location : Point = card.vo.cardStatus.parentCard.rightCenterLoaction;
                line.x = location.x;
                line.y = location.y;
            }
        }

        checkVisible();
    }

    private function move() : void {
        var speedX : Number = Math.abs(_rsX * 0.35);
        var speedY : Number = Math.abs(_rsY * 0.35);
        if (speedX < 1) {
            speedX = 1;
        }
        if (speedY < 1) {
            speedY = 1;
        }


        if (_rsX != 0) {
            if (Math.abs(_rsX) < speedX) {
                uiContainer.x += _rsX;
                _rsX = 0;
            } else {
                var cal : int = _rsX < 0 ? -speedX : speedX;
                uiContainer.x += cal;
                _rsX -= cal;
            }

        }

        if (_rsY != 0) {
            if (Math.abs(_rsY) < speedY) {
                uiContainer.y += _rsY;
                _rsY = 0;
            } else {
                cal = _rsY < 0 ? -speedY : speedY;
                uiContainer.y += cal;
                _rsY -= cal;
            }
        }
        reCalCamaraRect();

        if (_rsX == 0 && _rsY == 0) {
            EnterFrameCall.del(move);
        }

        checkVisible();
    }

    private function scale() : void {
        var speed : Number = Math.abs(_rsScale * 0.2);
        if (speed < 0.01) {
            speed = 0.01;
        }

        if (_rsScale != 0) {
            var value : Number;
            if (Math.abs(_rsScale) < speed) {
                value = uiContainer.scaleX + _rsScale;
                _rsScale = 0;
            } else {
                var cal : Number = _rsScale < 0 ? -speed : speed;
                value = uiContainer.scaleX + cal;
                _rsScale -= cal;
            }

            if (value < .5) {
                value = .5;
                _rsScale = 0;
            }

            if (value > 1) {
                value = 1;
                _rsScale = 0;
            }


            var p : Point = new Point(EnterFrameCall.getStage().stageWidth/2, EnterFrameCall.getStage().stageHeight/2);

            var ix : Number = p.x * (uiContainer.scaleX - value);
            var iy : Number = p.y * (uiContainer.scaleX - value);

            uiContainer.scaleX = uiContainer.scaleY = value;
            uiContainer.x += ix;
            uiContainer.y += iy;

            reCalCamaraRect();
        }


        if (_rsScale == 0) {
            EnterFrameCall.del(scale);
        }

        checkVisible();
    }

    /**
     * 优化显示，不在窗口内的东西，全部隐藏
     */
    private function checkVisible() : void {
        return;
        for each (var card : STaskCard in _cards.values) {
            var rect : Rectangle = card.rect;
            var visible : Boolean = _camaraRect.intersects(rect) && card.vo.cardStatus.visible;
            if (visible) {
                uiContainer.addChild(card);
            } else {
                STool.remove(card);
            }

            var line : Shape = _lines.get(card.vo.id);
            if (line != null) {
                rect = new Rectangle(line.x, line.y, line.width, line.height);
                if (line.name == "scaled") {
                    rect.y = rect.y - rect.height;
                }

                visible = _camaraRect.intersects(rect) && card.vo.cardStatus.visible;
                if (visible) {
                    uiContainer.addChild(line);
                } else {
                    STool.remove(line);
                }
            }
        }
    }

    /**
     * 计算当前试图的显示区域
     */
    private function reCalCamaraRect() : void {
        var p1 : Point = new Point();
        p1 = uiContainer.globalToLocal(p1);

        _camaraRect.x = p1.x;
        _camaraRect.y = p1.y;
        _camaraRect.width = ui.sWidth / uiContainer.scaleX;
        _camaraRect.height = ui.sHeight / uiContainer.scaleY;
    }

    private function __mouseWheelHandler(e : MouseEvent) : void {
        if (uiContainer.stage == null) {
            return;
        }

        e.stopImmediatePropagation();
        e.stopPropagation();

        if (false && e.ctrlKey) {

            var vl : Number = 0.1;
            if (e.delta < 0) {
                vl = -0.1;
            }
            _rsScale += vl;

            if (_rsScale != 0) {
                EnterFrameCall.add(scale);
            }

        } else {
            if (e.delta > 0) {
                _rsY += 100;
            } else {
                _rsY -= 100;
            }
        }

        if (_rsX != 0 || _rsY != 0) {
            EnterFrameCall.add(move);
        }
    }
}
}
