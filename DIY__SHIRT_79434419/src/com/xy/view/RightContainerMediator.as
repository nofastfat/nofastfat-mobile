package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.enum.DiyDataNotice;
import com.xy.model.vo.BitmapDataVo;
import com.xy.util.EnterFrameCall;
import com.xy.util.SMouse;
import com.xy.view.layer.RightContainer;
import com.xy.view.ui.SCtrlBar;
import com.xy.view.ui.componet.DiyBase;
import com.xy.view.ui.componet.DiyFont;
import com.xy.view.ui.componet.DiySystemImage;
import com.xy.view.ui.componet.SUserCtrlBar;

import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.Font;
import flash.text.TextField;
import flash.ui.Mouse;

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

    public function RightContainerMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);
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
        ui.addChild(_ctrlBar);
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
        _diyArea.mask = _mask;

        _diyBar = new SUserCtrlBar(ui);

        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_UP, __upHandler);
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
    }

    private function modelUpdate() : void {
        _diyBg.bitmapData = dataProxy.currentSelectModel.bmd;
        resize();
    }

    private function addImage(vo : BitmapDataVo, stageX : Number, stageY : Number) : void {
        var image : DiySystemImage = new DiySystemImage(vo);
        addAndRecordDiy(image, stageX, stageY);
    }

    private function __downHandler(e : MouseEvent) : void {
        var sp : DiyBase = e.currentTarget as DiyBase;
        EnterFrameCall.add(drag);
        _lastX = e.stageX;
        _lastY = e.stageY;

        _currentSelectImage = sp;
        _diyBar.hide();
        sp.bg.showTo(ui);
    }

    private function drag() : void {
        var stageX : Number = EnterFrameCall.getStage().mouseX;
        var stageY : Number = EnterFrameCall.getStage().mouseY;

        _currentSelectImage.moveOffset(stageX - _lastX, stageY - _lastY);

        _lastX = stageX;
        _lastY = stageY;
    }

    private function __upHandler(e : MouseEvent) : void {
        if (_currentSelectImage != null) {
            EnterFrameCall.del(drag);
            _diyBar.showByDiyBase(_currentSelectImage);

            _currentSelectImage = null;
        }
    }

    private function addFont(font : Font, stageX : Number, stageY : Number) : void {
        var image : DiyFont = new DiyFont(font);
        addAndRecordDiy(image, stageX, stageY);
    }

    private function addAndRecordDiy(diy : DiyBase, stageX : Number, stageY : Number) : void {
        var p : Point = new Point(stageX, stageY);
        p = _diyArea.globalToLocal(p);
        diy.x = p.x;
        diy.y = p.y;
        _diyImages.push(diy);
		_diyArea.addChild(diy);
		diy.bg.showTo(ui);
        diy.addEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
		diy.resetRegister();
    }

    public function get ui() : RightContainer {
        return viewComponent as RightContainer;
    }
}
}
