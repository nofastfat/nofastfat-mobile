package com.xy.view.ui {
import com.greensock.TweenLite;
import com.xy.component.buttons.ToggleButton;
import com.xy.component.buttons.event.ToggleButtonEvent;
import com.xy.component.toolTip.ToolTip;
import com.xy.component.toolTip.enum.ToolTipMode;
import com.xy.model.vo.OrganizedStructVo;
import com.xy.model.vo.SimpleSubordinateVo;
import com.xy.ui.InfoCard;
import com.xy.util.EnterFrameCall;
import com.xy.util.STool;
import com.xy.view.event.SInfoCardEvent;
import com.xy.view.event.TreeContainerEvent;

import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLRequest;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

/**
 * 组织机构
 * @author xy
 */
public class SInfoCard extends InfoCard {
    private var _vo : OrganizedStructVo;

    private var _lineList : Array = [];

    private var _loader : Loader;

    private var _togChildBtn : ToggleButton;

    private var _showCount : int = 3;

    private var _startY : int;
    private var _endHeight : int;

    private var _tempVisibleChildIds : Array = [];
    private var _locationCall : Function;
    private var _lastHeight : Number = 0;

    private var _rect : Rectangle;
    private var _lastLocation : Point = new Point();

    public function SInfoCard() {
        super();
        _rect = new Rectangle();

        _togChildBtn = new ToggleButton();
        _togChildBtn.setCtrlUI(childBtn, false);
        setChildBtnSelect(false);

        _togChildBtn.addEventListener(ToggleButtonEvent.STATE_CHANGE, __stateChangeHandler);
        detailBtn.addEventListener(MouseEvent.CLICK, __detailHandler);
        moreBtn.addEventListener(MouseEvent.CLICK, __moreChildHandler);
        statusMc.buttonMode = true;
        ToolTip.setSimpleTip(statusMc, "查看 能力-态度矩阵", ToolTipMode.RIGHT_BOTTOM_CENTER);
        statusMc.addEventListener(MouseEvent.CLICK, __openPowerMatrixHandler);


        ToolTip.setSimpleTip(detailBtn, "查看 任务目标", ToolTipMode.RIGHT_BOTTOM_CENTER);
        detailBtn.addEventListener(MouseEvent.CLICK, __showDetailHandler);

        _startY = bg.scale9Grid.top;
        _endHeight = bg.height - bg.scale9Grid.bottom;

        statusBg.mouseChildren = false;
        statusBg.mouseEnabled = false;
        iconContainer.mouseChildren = false;
        iconContainer.mouseEnabled = false;

        bg.addEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_UP, __upHandler);

        updateTogMoreBtnTip();
    }

    private function __downHandler(e : MouseEvent) : void {
        Mouse.cursor = MouseCursor.HAND;
        _lastLocation.x = EnterFrameCall.getStage().mouseX;
        _lastLocation.y = EnterFrameCall.getStage().mouseY;
        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_MOVE, __moveHandler);
    }

    public function setChildBtnSelect(selected : Boolean) : void {
        _togChildBtn.selected = selected;
        updateTogChildBtnTip();
    }

    private function __upHandler(e : MouseEvent) : void {
        Mouse.cursor = MouseCursor.AUTO;
        EnterFrameCall.getStage().removeEventListener(MouseEvent.MOUSE_MOVE, __moveHandler);
    }

    private function __moveHandler(e : MouseEvent) : void {
        var offsetX : Number = EnterFrameCall.getStage().mouseX - _lastLocation.x;
        var offsetY : Number = EnterFrameCall.getStage().mouseY - _lastLocation.y;
        dispatchEvent(new TreeContainerEvent(TreeContainerEvent.LOCATION_MOVE, offsetX, offsetY));

        _lastLocation.x = EnterFrameCall.getStage().mouseX;
        _lastLocation.y = EnterFrameCall.getStage().mouseY;
    }

    public function setChildBtnEnable(enable : Boolean) : void {
        STool.setMovieClipEnable(childBtn, enable);
        childBtn.mouseChildren = true;
    }

    public function dispose() : void {
        detailBtn.removeEventListener(MouseEvent.CLICK, __detailHandler);
        moreBtn.removeEventListener(MouseEvent.CLICK, __moreChildHandler);
        _togChildBtn.removeEventListener(ToggleButtonEvent.STATE_CHANGE, __stateChangeHandler);
        _togChildBtn.dispose();
    }

    public function get vo() : OrganizedStructVo {
        return _vo;
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

    public function setData(vo : OrganizedStructVo, locationCall : Function) : void {
        _vo = vo;
        _locationCall = locationCall;
        STool.clear(iconContainer, [iconContainer.bg]);

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

        sexMc.gotoAndStop(vo.sex + 1);
        nameTf.text = vo.name;
        companyTf.text = vo.company;
        statusMc.gotoAndStop(vo.status + 1);
        statusBg.gotoAndStop(vo.status + 1);
        jobTypeTf.text = vo.jobType;
        joinTimeTf.text = vo.joinTime;
        myScoreTf.text = vo.jobScore + "";
        leftSorceTf.text = vo.levelUpLastScore + "";
        subordinateCountTf.text = "（" + vo.simpleSubordinateList.length + "）";

        STool.minSizeTextfield(nameTf);
        STool.minSizeTextfield(companyTf);
        STool.minSizeTextfield(jobTypeTf);
        STool.minSizeTextfield(joinTimeTf);
        STool.minSizeTextfield(myScoreTf);
        STool.minSizeTextfield(leftSorceTf);
        STool.minSizeTextfield(subordinateCountTf);

        _showCount = _vo.cardStatus.showCount;

        updateShowChild();
    }

    private function updateShowChild() : void {
        _tempVisibleChildIds = _vo.getVisibleChildIds();

        if (_lastHeight == 0) {
            _lastHeight = bg.height;
        }

        var subHeight : int;

        if (_showCount > _vo.simpleSubordinateList.length) {
            _showCount = _vo.simpleSubordinateList.length;
        }

        for (var i : int = 0; i < _showCount; i++) {
            var line : SInfoList = _lineList[i];
            var vo : SimpleSubordinateVo = _vo.simpleSubordinateList[i];
            if (vo == null) {
                break;
            }
            if (line == null) {
                line = new SInfoList();
                ToolTip.setSimpleTip(line.detalBtn, "查看 任务目标", ToolTipMode.RIGHT_BOTTOM_CENTER);
                line.detalBtn.addEventListener(MouseEvent.CLICK, __showDetailHandler);
                _lineList[i] = line;
            }
            subHeight = line.height + 1;

            //addChild(line);

            line.x = 0;
            line.y = _startY + i * subHeight + 5;

            line.setData(vo);

        }

        moreBtn.visible = _vo.simpleSubordinateList.length > 3;
        var resultHeight : int = _startY + _endHeight + _showCount * subHeight;
//        bg.height = resultHeight;
//        moreBtn.y = bg.height;

        TweenLite.to(bg, 0.3, {
                height: resultHeight,
                overwrite: true,
                onUpdateParams: [this],
                onUpdate: function(self : SInfoCard) : void {
                    var bgHeight : Number = self.bg.height;
                    self.moreBtn.y = bgHeight;
                    for (var i : int = 0; i < self._showCount; i++) {
                        var line : SInfoList = self._lineList[i];
                        if (line.stage == null && line.y + subHeight <= bgHeight - _endHeight) {
                            self.addChild(line);
                        }
                    }

                    for (i = self._showCount; i < self._lineList.length; i++) {
                        line = self._lineList[i];
                        if (line != null && line.stage != null && line.y + subHeight > bgHeight - self._endHeight) {
                            STool.remove(line);
                        }
                    }
                    self._locationCall(self._tempVisibleChildIds, bgHeight - self._lastHeight);
                    self._lastHeight = bgHeight;
                },
                onCompleteParams: [this],
                onComplete: function(self : SInfoCard) : void {
                    for (var i : int = 0; i < self._showCount; i++) {
                        var line : SInfoList = self._lineList[i];
                        if (line.stage == null) {
                            self.addChild(line);
                        }
                    }

                    if (self._showCount >= self._vo.simpleSubordinateList.length) {
                        self._showCount = self._vo.simpleSubordinateList.length;
                        self.moreBtn.gotoAndStop(2);
                    } else {
                        self.moreBtn.gotoAndStop(1);
                    }
                    _locationCall(self._tempVisibleChildIds, self.bg.height - self._lastHeight);
                    self._lastHeight = self.bg.height;
                    self._rect.x = self.x;
                    self._rect.y = self.y;
                    self._rect.width = self.width;
                    self._rect.height = self.height;
                    self.updateTogMoreBtnTip();
                }
            });

        _vo.cardStatus.showCount = _showCount;
    }

    private function __stateChangeHandler(e : ToggleButtonEvent) : void {
        dispatchEvent(new SInfoCardEvent(SInfoCardEvent.DETAIL_CHANGE, _vo, _togChildBtn.selected));
        updateTogChildBtnTip();
    }

    private function updateTogChildBtnTip() : void {

        var tip : String = "展开 下属详情";
        if (_togChildBtn.selected) {
            tip = "收起 下属详情";
        }

        ToolTip.setSimpleTip(childBtn, tip, ToolTipMode.RIGHT_BOTTOM_CENTER);
    }

    private function updateTogMoreBtnTip() : void {

        var tip : String = "展开 直属下属";
        if (moreBtn.currentFrame == 2) {
            tip = "收起 直属下属";
        }

        ToolTip.setSimpleTip(moreBtn, tip, ToolTipMode.RIGHT_BOTTOM_CENTER);
    }

    private function __detailHandler(e : MouseEvent) : void {
        dispatchEvent(new SInfoCardEvent(SInfoCardEvent.SHOW_DETAIL, _vo));
    }

    private function __moreChildHandler(e : MouseEvent) : void {
        if (_showCount == _vo.simpleSubordinateList.length) {
            _showCount = 3;
        } else {
            _showCount += 5;
            if (_showCount > _vo.simpleSubordinateList.length) {
                _showCount = _vo.simpleSubordinateList.length;
            }
        }

        updateShowChild();

        if (this.parent != null) {
            this.parent.setChildIndex(this, this.parent.numChildren - 1);
        }
    }

    private function __openPowerMatrixHandler(e : MouseEvent) : void {
        dispatchEvent(new SInfoCardEvent(SInfoCardEvent.SHOW_POWER_MATRIX, _vo));
    }

    private function __showDetailHandler(e : MouseEvent) : void {
        var currentTarget : MovieClip = e.currentTarget.parent as MovieClip;

        var id : int;
        var name : String;

        if (currentTarget is SInfoCard) {
            id = _vo.id;
            name = _vo.name;
        } else {
            var list : SInfoList = currentTarget as SInfoList;
            id = list.vo.id;
            name = list.vo.name;
        }
        dispatchEvent(new SInfoCardEvent(SInfoCardEvent.SHOW_PERSON_CARD, null, false, id, e.currentTarget as DisplayObject, name));

    }

    /**
     * 底部中点的坐标
     * @return
     */
    public function get bottomCenterLoaction() : Point {
        var moreBtnHeight : Number = moreBtn.visible ? moreBtn.height : 3;
        return new Point(this.x + this.width / 2, this.y + bg.height + moreBtnHeight + 3);
    }

    override public function set x(value : Number) : void {
        super.x = value;
        _vo.cardStatus.locationX = value;
    }

    override public function set y(value : Number) : void {
        super.y = value;
        _vo.cardStatus.locationY = value;
    }

    public function get rect() : Rectangle {
        return _rect;
    }

    public function get togChildBtn() : ToggleButton {
        return _togChildBtn;
    }
}
}
