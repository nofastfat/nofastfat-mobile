package com.xy.view {
import com.xy.cmd.GetOrganizedStructCmd;
import com.xy.cmd.GetPersonInfoCmd;
import com.xy.component.toolTip.ToolTip;
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.vo.OrganizedStructVo;
import com.xy.model.vo.PersonInfoVo;
import com.xy.util.EnterFrameCall;
import com.xy.util.STool;
import com.xy.util.Tools;
import com.xy.view.event.SInfoCardEvent;
import com.xy.view.event.TreeContainerEvent;
import com.xy.view.layer.TreeContainer;
import com.xy.view.ui.SInfoCard;

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.external.ExternalInterface;
import flash.geom.Point;
import flash.geom.Rectangle;

public class InfoTreeContainerMediator extends AbsMediator {
    public static const NAME : String = "TreeContainerMediator";

    /**
     * 初始化显示
     */
    public static const INIT_SHOW : String = NAME + "INIT_SHOW";

    /**
     * 获取 组织机构数据完成
     */
    public static const GET_ORGANIZED_STRUCT_OK : String = NAME + "GET_ORGANIZED_STRUCT_OK";

    /**
     * 获取人员信息数据完成
     */
    public static const GET_PERSON_INFO_OK : String = NAME + "GET_PERSON_INFO_OK";

    /**
     * 缩放变化
     * offsetScale:Number
     */
    public static const SCALE_CHANGE : String = NAME + "SCALE_CHANGE";

    private var _treeRoot : SInfoCard;
    private var _rsX : Number = 0;
    private var _rsY : Number = 0;

    private var _rsScale : Number = 0;
    private var _cards : Map = new Map();
    private var _lines : Map = new Map();

    private var _camaraRect : Rectangle;

    private var _lastSelectCard : SInfoCard;

    public function InfoTreeContainerMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);

        uiContainer.addEventListener(TreeContainerEvent.LOCATION_MOVE, __moveHandler);

        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_WHEEL, __mouseWheelHandler);

        _camaraRect = new Rectangle(-uiContainer.x, -uiContainer.y, ui.sWidth, ui.sHeight);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(INIT_SHOW, initShow);
        map.put(Event.RESIZE, resize);
        map.put(GET_ORGANIZED_STRUCT_OK, getOrganizedStructOk);
        map.put(GET_PERSON_INFO_OK, getPersonInfoOk);
        map.put(SCALE_CHANGE, scaleChange);
        return map;
    }

    public function get ui() : TreeContainer {
        return viewComponent as TreeContainer;
    }

    public function get uiContainer() : Sprite {
        return (viewComponent as TreeContainer).infoContainer;
    }

    /**
     * 初始化的显示
     */
    private function initShow() : void {
        if (_treeRoot == null) {
            _treeRoot = new SInfoCard();
            _treeRoot.addEventListener(SInfoCardEvent.DETAIL_CHANGE, __showMoreChildHandler);
            _treeRoot.addEventListener(TreeContainerEvent.LOCATION_MOVE, __moveHandler);
            _treeRoot.addEventListener(MouseEvent.CLICK, __selectCardHandler);
            _treeRoot.addEventListener(SInfoCardEvent.SHOW_POWER_MATRIX, __showPowerMatrixHandler);
            _treeRoot.addEventListener(SInfoCardEvent.SHOW_PERSON_CARD, __showPersonCardHandler);
        }
        _cards.put(dataProxy.selfData.id, _treeRoot);

        _treeRoot.setData(dataProxy.selfData, locationCall);
        _treeRoot.showTo(uiContainer);
        _treeRoot.x = (ui.sWidth - _treeRoot.width) / 2;
        _treeRoot.y = (ui.sHeight - _treeRoot.height) / 2;
        
        if(_treeRoot.x < 0){
        	_treeRoot.x = 100;
        }
        if(_treeRoot.y < 0){
        	_treeRoot.y = 100;
        }
    }

    private function locationCall(childIds : Array, offsetY : Number) : void {
        for each (var id : int in childIds) {
            var card : SInfoCard = _cards.get(id);
            var line : Shape = _lines.get(id);
            if (card != null) {
                card.y += offsetY;
            }

            if (line != null) {
                line.y += offsetY;
            }
        }
    }

    private function __showMoreChildHandler(e : SInfoCardEvent) : void {
        var vo : OrganizedStructVo = e.vo;
        if(vo.simpleSubordinateList == null || vo.simpleSubordinateList.length == 0){
        	return;
        }
        
        var card : SInfoCard = _cards.get(vo.id);
        if (e.isShow) {
            if (vo.subStuctList == null) {
                card.setChildBtnEnable(false);
                sendNotification(GetOrganizedStructCmd.NAME, vo);
            } else {
                getOrganizedStructOk(vo);
                showCards(vo.getHideChildIdsBy(vo.id));
            }

        } else {
            hideCards(vo, vo.getVisibleChildIds());
        }
    }

    /**
     * 隐藏指定节点的兄弟节点数
     * @param vo
     */
    private function hideSiblingCards(vo : OrganizedStructVo) : void {
        var siblings : Array = vo.getSiblingVos();
        for each (var siblingVo : OrganizedStructVo in siblings) {
            var card : SInfoCard = _cards.get(siblingVo.id);
            if (card.togChildBtn.selected) {
                card.setChildBtnSelect(false);
                var visibles : Array = siblingVo.getVisibleChildIds();
                hideCards(siblingVo, visibles);
            }
        }
    }

    /**
     * 隐藏组织机构
     * @param vo
     * @param ids
     */
    private function hideCards(vo : OrganizedStructVo, ids : Array) : void {
        for each (var id : int in ids) {
            var card : SInfoCard = _cards.get(id);
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
            var card : SInfoCard = _cards.get(id);
            if (card != null) {
                card.showTo(uiContainer);
            }

            var line : Shape = _lines.get(id);
            if (line != null) {
                uiContainer.addChild(line);
                var location : Point = card.vo.cardStatus.parentCard.bottomCenterLoaction;
                line.x = location.x;
                line.y = location.y;
            }
        }

        checkVisible();
    }

    private function resize(... rest) : void {
    }

    /**
     * 获取组织机构数据成功
     * @param vo
     */
    private function getOrganizedStructOk(vo : OrganizedStructVo) : void {
        hideSiblingCards(vo);
        var parentCard : SInfoCard = _cards.get(vo.id);
        parentCard.setChildBtnEnable(true);
        parentCard.setChildBtnSelect(true);
        if (vo.subStuctList == null) {
            //TODO 请求组织机构数据失败了	
            return;
        } else {
            var len : int = vo.subStuctList.length;
            var totalWidth : int = len * (parentCard.width + 10) - 10;
            var bottomCenterPoint : Point = parentCard.bottomCenterLoaction;
            var startX : int = bottomCenterPoint.x - totalWidth / 2;
            var startY : int = bottomCenterPoint.y + 100;

            for (var i : int = 0; i < len; i++) {
                var subVo : OrganizedStructVo = vo.subStuctList[i];
                subVo.parent = vo;
                var card : SInfoCard = _cards.get(subVo.id);
                if (card == null) {
                    card = new SInfoCard();
                    card.addEventListener(SInfoCardEvent.DETAIL_CHANGE, __showMoreChildHandler);
                    card.addEventListener(TreeContainerEvent.LOCATION_MOVE, __moveHandler);
                    card.addEventListener(MouseEvent.CLICK, __selectCardHandler);
                    card.addEventListener(SInfoCardEvent.SHOW_POWER_MATRIX, __showPowerMatrixHandler);
                    card.addEventListener(SInfoCardEvent.SHOW_PERSON_CARD, __showPersonCardHandler);
                    _cards.put(subVo.id, card);
                }
                subVo.cardStatus.parentCard = parentCard;
                card.setData(subVo, locationCall);
                card.showTo(uiContainer);
                card.x = startX + (parentCard.width + 10) * i;
                card.y = startY;

                var line : Shape = _lines.get(subVo.id);
                var secP : Point = new Point(card.x + parentCard.width / 2, startY);
                secP = secP.subtract(bottomCenterPoint);
                if (line == null) {
                    line = Tools.makeConactLine(new Point(), secP);

                    if (secP.x < 0) {
                        line.name = "scaled";
                    }
                }
                uiContainer.addChild(line);
                line.x = bottomCenterPoint.x;
                line.y = bottomCenterPoint.y;
                _lines.put(subVo.id, line);
            }
        }

        ToolTip.hideTip();

        /* 展开的东西剧中显示 */
        var p : Point = new Point(parentCard.x + card.width / 2, parentCard.y + card.height + 50);
        p = uiContainer.localToGlobal(p);
        _rsX += ui.sWidth / 2 - p.x;
        _rsY += ui.sHeight / 2 - p.y;
        if (_rsX != 0 || _rsY != 0) {
            EnterFrameCall.add(move);
        }
    }

    private function getPersonInfoOk(id : int, mc : DisplayObject) : void {
        var vo : PersonInfoVo = dataProxy.personDatas.get(id);
        if (vo == null) {
            //请求人员信息失败
            return;
        }
        sendNotification(DetailContainerMediator.SHOW_PEROSON_CARD, [vo, mc]);
    }

    private function __moveHandler(e : TreeContainerEvent) : void {
        _rsX += e.offsetX;
        _rsY += e.offsetY;

        if (_rsX != 0 || _rsY != 0) {
            EnterFrameCall.add(move);
        }
    }

    private function __selectCardHandler(e : MouseEvent) : void {
        var card : SInfoCard = e.currentTarget as SInfoCard;
        if (card != null) {
            if (_lastSelectCard != null) {
                _lastSelectCard.bg.gotoAndStop(1);
            }
            card.bg.gotoAndStop(2);
            _lastSelectCard = card;
            
            if(uiContainer.contains(card)){
            	uiContainer.setChildIndex(card, uiContainer.numChildren -1);
            }
        }
    }

    private function __showPowerMatrixHandler(e : SInfoCardEvent) : void {
        var card : SInfoCard = _cards.get(e.vo.id);
        var startLoaction : Point = new Point(card.statusMc.x, card.statusMc.y);
        startLoaction = card.localToGlobal(startLoaction);
        sendNotification(DetailContainerMediator.SHOW_POWER_MATRIX, [startLoaction, e.vo]);
    }

    private function __showPersonCardHandler(e : SInfoCardEvent) : void {
        var personVo : PersonInfoVo = dataProxy.personDatas.get(e.id);
        if (personVo == null) {
            sendNotification(GetPersonInfoCmd.NAME, [e.id, e._target, e.name]);
        } else {
            getPersonInfoOk(e.id, e._target);
        }
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
        for each (var card : SInfoCard in _cards.values) {
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
                    rect.x = rect.x - rect.width;
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

    private function scaleChange(offset : Number) : void {
        if (uiContainer.stage != null) {
            _rsScale += offset;

            if (_rsScale != 0) {
                EnterFrameCall.add(scale);
            }
        }
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
