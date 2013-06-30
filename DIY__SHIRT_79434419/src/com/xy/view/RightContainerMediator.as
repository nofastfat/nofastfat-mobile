package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.enum.DiyDataNotice;
import com.xy.model.vo.BitmapDataVo;
import com.xy.util.EnterFrameCall;
import com.xy.util.PopUpManager;
import com.xy.util.SMouse;
import com.xy.util.STool;
import com.xy.view.layer.RightContainer;
import com.xy.view.ui.SCtrlBar;
import com.xy.view.ui.componet.BitmapDragTip;
import com.xy.view.ui.componet.DiyBase;
import com.xy.view.ui.componet.DiyFont;
import com.xy.view.ui.componet.DiySystemImage;
import com.xy.view.ui.componet.SUserCtrlBar;
import com.xy.view.ui.events.ChooseBackgroundPanelEvent;
import com.xy.view.ui.events.SCtrlBarEvent;
import com.xy.view.ui.events.SUserCtrlBarEvent;
import com.xy.view.ui.panels.ChooseBackgroundPanel;

import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.Font;

public class RightContainerMediator extends AbsMediator {
    public static const NAME : String = "RightContainerMediator";

    /**
     * 添加图片
     * [
     *   vo:BitmapDataVo
     *   stageX:Number
     *   stageY:Number
     * ]
     */
    public static const ADD_IMAGE : String = NAME + "ADD_IMAGE";

    /**
     * 添加文字
     * [
     *   font:Font
     *   stageX:Number
     *   stageY:Number
     * ]
     */
    public static const ADD_FONT : String = NAME + "ADD_FONT";

    private var _ctrlBar : SCtrlBar;

    private var _diyBg : Bitmap;
    private var _mask : Shape;
    private var _diyArea : Sprite;

    private var _diyImages : Array = [];

    private var _currentSelectImage : DiyBase;
    private var _diyBar : SUserCtrlBar;

    private var _lastX : Number;
    private var _lastY : Number;

    private var _chooseModelPanel : ChooseBackgroundPanel;

    private var _bmpDragTip : BitmapDragTip;

    public function RightContainerMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);

        _chooseModelPanel = new ChooseBackgroundPanel(720, 520, "选择模板");
        _chooseModelPanel.addEventListener(ChooseBackgroundPanelEvent.BACKGROUND_STATUS, __modelChangeHandler);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(Event.RESIZE, resize);
        map.put(DiyDataNotice.MODEL_UPDATE, modelUpdate);
        map.put(ADD_IMAGE, addImage);
        map.put(ADD_FONT, addFont);
        return map;
    }

    override public function onRegister() : void {
        _ctrlBar = new SCtrlBar();
        _ctrlBar.x = _ctrlBar.y = 10;
        _mask = new Shape();
        _mask.graphics.beginFill(0xFF0000);
        _mask.graphics.drawRect(0, 0, 1, 1);
        _mask.graphics.endFill();

        _diyArea = new Sprite();

        _diyBg = new Bitmap();

        ui.addChild(_diyBg);
        ui.addChild(_mask);
        ui.addChild(_diyArea);
        ui.addChild(_ctrlBar);
        _diyArea.mask = _mask;

        _diyBar = new SUserCtrlBar(ui);

        _bmpDragTip = new BitmapDragTip();

        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_UP, __upHandler);
        _ctrlBar.addEventListener(SCtrlBarEvent.CHANGE_MODEL, __changeModel);
        _diyBar.addEventListener(SUserCtrlBarEvent.LINE_CHANGE, __lineChangeHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.LINE_COLOR, __lineColorHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.ALPHA, __alphaHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.UP_LEVEL, __upLevelHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.DOWN_LEVEL, __downLevelHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.DELETE, __deleteHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.FULL_STATUS, __fullStatusHandler);
        ui.bg.addEventListener(MouseEvent.CLICK, __unSelectHandler);
    }

    private function resize() : void {
        if (_ctrlBar != null) {
            _ctrlBar.resize();
        }

        if (_diyBg != null) {
            _diyBg.x = (EnterFrameCall.getStage().stageWidth - 200 - _diyBg.width) / 2;
            _diyBg.y = (EnterFrameCall.getStage().stageHeight - _diyBg.height) / 2;

            if (_mask != null && dataProxy.currentSelectModel != null) {
                _mask.x = dataProxy.currentSelectModel.rect.x + _diyBg.x;
                _mask.y = dataProxy.currentSelectModel.rect.y + _diyBg.y;
                _mask.width = dataProxy.currentSelectModel.rect.width;
                _mask.height = dataProxy.currentSelectModel.rect.height;
            }

            if (_diyArea != null) {
                _diyArea.x = _diyBg.x;
                _diyArea.y = _diyBg.y;
            }
        }

        if (dataProxy.currentSelectModel != null) {
            var newRect : Rectangle = dataProxy.currentSelectModel.rect.clone();
            var p : Point = new Point(_mask.x, _mask.y);
            p = ui.localToGlobal(p);
            newRect.x = p.x;
            newRect.y = p.y;
            SMouse.getInstance().setHotArea(newRect);
        }

        if (_currentSelectImage != null) {
            _currentSelectImage.bg.showTo(ui);
            if (_diyBar != null && _diyBar.stage != null) {
                _diyBar.showByDiyBase(_currentSelectImage);
            }
        }

        if (_bmpDragTip != null) {
            _bmpDragTip.x = EnterFrameCall.getStage().stageWidth - _bmpDragTip.width - 10;
            _bmpDragTip.y = _ctrlBar.y + _ctrlBar.height + 10;
        }
    }

    private function modelUpdate() : void {
        _diyBg.bitmapData = dataProxy.currentSelectModel.bmd;
        resize();

        if (_chooseModelPanel.stage != null) {
            _chooseModelPanel.setData(dataProxy.models);
        }
    }

    private function addImage(vo : BitmapDataVo, stageX : Number, stageY : Number) : void {
        var image : DiySystemImage = new DiySystemImage(vo, dataProxy.currentSelectModel.rect, _bmpDragTip);
        addAndRecordDiy(image, stageX, stageY);
    }

    private function __downHandler(e : MouseEvent) : void {
        if (_currentSelectImage != null) {
            _currentSelectImage.bg.hide();
        }

        var sp : DiyBase = e.currentTarget as DiyBase;
        EnterFrameCall.add(drag);
        _lastX = e.stageX;
        _lastY = e.stageY;

        _currentSelectImage = sp;
        _diyBar.hide();
        sp.bg.showTo(ui);

        if (_currentSelectImage.editVo.isFull) {
            _bmpDragTip.showBy(_currentSelectImage as DiySystemImage);
        } else {
            STool.remove(_bmpDragTip);
        }
    }

    private function drag() : void {
        var stageX : Number = EnterFrameCall.getStage().mouseX;
        var stageY : Number = EnterFrameCall.getStage().mouseY;

        _currentSelectImage.moveOffset(stageX - _lastX, stageY - _lastY);

        _lastX = stageX;
        _lastY = stageY;

        _diyBar.showByDiyBase(_currentSelectImage);
    }

    private function __upHandler(e : MouseEvent) : void {
        EnterFrameCall.del(drag);
    }

    private function __changeModel(e : SCtrlBarEvent) : void {
        _chooseModelPanel.setData(dataProxy.models);

        PopUpManager.getInstance().showPanel(_chooseModelPanel);
    }

    private function __modelChangeHandler(e : ChooseBackgroundPanelEvent) : void {
        dataProxy.chooseModel(e.vo);
        PopUpManager.getInstance().closeAll();
    }

    private function __lineChangeHandler(e : SUserCtrlBarEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }
        _currentSelectImage.setLineSickness(e.data);

    }

    private function __lineColorHandler(e : SUserCtrlBarEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }
        _currentSelectImage.setLineColor(e.data);
    }

    private function __alphaHandler(e : SUserCtrlBarEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }
        _currentSelectImage.setAlpha(e.data);
    }

    private function __upLevelHandler(e : SUserCtrlBarEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }
        _currentSelectImage.upLevel();
    }

    private function __downLevelHandler(e : SUserCtrlBarEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }
        _currentSelectImage.downLevel();
    }

    private function __deleteHandler(e : SUserCtrlBarEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }
        _currentSelectImage.deleted();
        _currentSelectImage = null;
        __unSelectHandler(null);
        _diyBar.hide();
    }

    private function __fullStatusHandler(e : SUserCtrlBarEvent) : void {
        var status : Boolean = e.data;
        if (_currentSelectImage == null) {
            return;
        }
        if (_currentSelectImage is DiySystemImage) {
            (_currentSelectImage as DiySystemImage).setFullStatus(status);
        }

        _currentSelectImage.bg.showTo(ui);
    }

    private function __unSelectHandler(e : MouseEvent) : void {
        if (_currentSelectImage != null) {
            _currentSelectImage.bg.hide();
            _diyBar.hide();
        }
        _currentSelectImage = null;
        STool.remove(_bmpDragTip);
    }


    private function addFont(font : Font, stageX : Number, stageY : Number) : void {
        var image : DiyFont = new DiyFont(font);
        addAndRecordDiy(image, stageX, stageY);
    }

    private function addAndRecordDiy(diy : DiyBase, stageX : Number, stageY : Number) : void {
        __unSelectHandler(null);

        var p : Point = new Point(stageX, stageY);
        p = _diyArea.globalToLocal(p);
        diy.x = p.x;
        diy.y = p.y;
        _diyImages.push(diy);
        _diyArea.addChild(diy);
        diy.bg.showTo(ui);
        diy.addEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
        diy.resetRegister();
        _diyBar.showByDiyBase(diy);
        _currentSelectImage = diy;
    }

    public function get ui() : RightContainer {
        return viewComponent as RightContainer;
    }
}
}