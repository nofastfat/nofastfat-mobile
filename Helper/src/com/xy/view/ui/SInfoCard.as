package com.xy.view.ui {
import com.greensock.TweenLite;
import com.greensock.easing.Back;
import com.xy.component.buttons.ToggleButton;
import com.xy.component.buttons.event.ToggleButtonEvent;
import com.xy.model.vo.OrganizedStructVo;
import com.xy.model.vo.SimpleSubordinateVo;
import com.xy.ui.InfoCard;
import com.xy.util.STool;
import com.xy.view.event.SInfoCardEvent;

import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.net.URLRequest;

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

    public function SInfoCard() {
        super();

        _togChildBtn = new ToggleButton();
        _togChildBtn.setCtrlUI(childBtn, false);

        _togChildBtn.addEventListener(ToggleButtonEvent.STATE_CHANGE, __stateChangeHandler);
        detailBtn.addEventListener(MouseEvent.CLICK, __detailHandler);
        moreBtn.addEventListener(MouseEvent.CLICK, __moreChildHandler);

        _startY = bg.scale9Grid.top;
        _endHeight = bg.height - bg.scale9Grid.bottom;
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

    public function setData(vo : OrganizedStructVo) : void {
        _vo = vo;
        STool.clear(iconContainer, [iconContainer.bg]);

        if (_loader != null) {
            _loader.unload();
        }
        _loader = new Loader();
        _loader.load(new URLRequest(vo.imgUrl));
        _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e : Event) : void {});
        _loader.x = _loader.y = 1;
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

        _showCount = 3;

        updateShowChild();
    }

    private function updateShowChild() : void {

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
                    var bgHeight : int = self.bg.height;
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
                }
            });
    }

    private function __stateChangeHandler(e : ToggleButtonEvent) : void {
        dispatchEvent(new SInfoCardEvent(SInfoCardEvent.DETAIL_CHANGE, _vo, _togChildBtn.selected));
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
    }

    /**
     * 底部中点的坐标
     * @return
     */
    public function get bottomCenterLoaction() : Point {
        return new Point(this.x + this.width / 2, this.y + this.height);
    }
}
}
