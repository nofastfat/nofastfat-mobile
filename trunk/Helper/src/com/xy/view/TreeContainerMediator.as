package com.xy.view {
import com.greensock.TweenLite;
import com.xy.cmd.GetOrganizedStructCmd;
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.vo.OrganizedStructVo;
import com.xy.util.EnterFrameCall;
import com.xy.util.STool;
import com.xy.view.event.SInfoCardEvent;
import com.xy.view.event.TreeContainerEvent;
import com.xy.view.layer.DetailContainer;
import com.xy.view.layer.TreeContainer;
import com.xy.view.ui.SInfoCard;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

public class TreeContainerMediator extends AbsMediator {
    public static const NAME : String = "TreeContainerMediator";

    /**
     * 初始化显示
     */
    public static const INIT_SHOW : String = NAME + "INIT_SHOW";

    /**
     * 获取 组织机构数据完成
     */
    public static const GET_ORGANIZED_STRUCT_OK : String = NAME + "GET_ORGANIZED_STRUCT_OK";

    private var _treeRoot : SInfoCard;
    private var _rsX : Number = 0;
    private var _rsY : Number = 0;

    private var _rsScale : Number = 0;

    private var _cards : Map = new Map();

    public function TreeContainerMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);

        ui.addEventListener(TreeContainerEvent.LOCATION_MOVE, __moveHandler);

        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_WHEEL, __mouseWheelHandler);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(INIT_SHOW, initShow);
        map.put(Event.RESIZE, resize);
        map.put(GET_ORGANIZED_STRUCT_OK, getOrganizedStructOk);
        return map;
    }

    public function get ui() : TreeContainer {
        return viewComponent as TreeContainer;
    }

    public function get uiContainer() : Sprite {
        return (viewComponent as TreeContainer).container;
    }

    /**
     * 初始化的显示
     */
    private function initShow() : void {
        if (_treeRoot == null) {
            _treeRoot = new SInfoCard();
            _treeRoot.addEventListener(SInfoCardEvent.DETAIL_CHANGE, __showMoreChildHandler);
        }

        _cards.put(dataProxy.selfData.id, _treeRoot);

        uiContainer.addChild(_treeRoot);
        _treeRoot.x = (ui.sWidth - _treeRoot.width) / 2;
        _treeRoot.y = (ui.sHeight - _treeRoot.height) / 2;
        _treeRoot.setData(dataProxy.selfData);
    }

    private function __showMoreChildHandler(e : SInfoCardEvent) : void {
        if (e.isShow) {
            var vo : OrganizedStructVo = e.vo;

            if (vo.subStuctList == null) {
                _treeRoot.setChildBtnEnable(false);
                sendNotification(GetOrganizedStructCmd.NAME, vo);
            } else {

            }
        } else {
            //TODO 隐藏组织机构
        }
    }

    private function resize(... rest) : void {
        if (_treeRoot != null) {
            _treeRoot.x = (ui.sWidth - _treeRoot.width) / 2;
            _treeRoot.y = (ui.sHeight - _treeRoot.height) / 2;
        }
    }

    /**
     * 获取组织机构数据成功
     * @param vo
     */
    private function getOrganizedStructOk(vo : OrganizedStructVo) : void {
        var parentCard : SInfoCard = _cards.get(vo.id);
        parentCard.setChildBtnEnable(true);
        if (vo.subStuctList == null) {
            //TODO 请求组织机构数据失败了	
        } else {
            var len : int = vo.subStuctList.length;
            var totalWidth : int = len * (parentCard.width + 10) - 10;
            var bottomCenterPoint : Point = parentCard.bottomCenterLoaction;
            var startX : int = bottomCenterPoint.x - totalWidth / 2;
            var startY : int = bottomCenterPoint.y + 100;

            for (var i : int = 0; i < len; i++) {
                var subVo : OrganizedStructVo = vo.subStuctList[i];
                var card : SInfoCard = _cards.get(subVo.id);
                if (card == null) {
                    card = new SInfoCard();
                    card.addEventListener(SInfoCardEvent.DETAIL_CHANGE, __showMoreChildHandler);
                    _cards.put(subVo.id, card);
                }
                card.setData(subVo);
                uiContainer.addChild(card);
                card.x = startX + (parentCard.width + 10) * i;
                card.y = startY;
            }
        }
    }

    private function __moveHandler(e : TreeContainerEvent) : void {
        _rsX += e.offsetX;
        _rsY += e.offsetY;

        if (_rsX != 0 || _rsY != 0) {
            EnterFrameCall.add(move);
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

			
			var p : Point = new Point(EnterFrameCall.getStage().mouseX, EnterFrameCall.getStage().mouseY);
			
			var ix : Number = EnterFrameCall.getStage().mouseX * (uiContainer.scaleX - value);
			var iy : Number = EnterFrameCall.getStage().mouseY * (uiContainer.scaleX - value);
			
			uiContainer.scaleX = uiContainer.scaleY = value;
			uiContainer.x += ix;
			uiContainer.y += iy;
        }


        if (_rsScale == 0) {
            EnterFrameCall.del(scale);
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

        if (_rsX == 0 && _rsY == 0) {
            EnterFrameCall.del(move);
        }
    }

    private function __mouseWheelHandler(e : MouseEvent) : void {
        e.stopImmediatePropagation();
        e.stopPropagation();

        if (!e.ctrlKey) {

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
