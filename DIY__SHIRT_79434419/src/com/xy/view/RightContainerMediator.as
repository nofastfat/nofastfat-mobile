package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.enum.DiyDataNotice;
import com.xy.util.EnterFrameCall;
import com.xy.view.layer.RightContainer;
import com.xy.view.ui.SCtrlBar;

import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;

public class RightContainerMediator extends AbsMediator {
    public static const NAME : String = "RightContainerMediator";

    private var _ctrlBar : SCtrlBar;

    private var _diyBg : Bitmap;
    private var _mask : Shape;
    private var _diyArea : Sprite;

    public function RightContainerMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(Event.RESIZE, resize);
        map.put(DiyDataNotice.MODEL_UPDATE, modelUpdate);
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
    }

    private function resize() : void {
        if (_ctrlBar != null) {
            _ctrlBar.resize();
        }

        if (_diyBg != null) {
            _diyBg.x = (EnterFrameCall.getStage().stageWidth - 200 - _diyBg.width) / 2;
            _diyBg.y = (EnterFrameCall.getStage().stageHeight - _diyBg.height) / 2;
        }
    }

    private function modelUpdate() : void {
        _diyBg.bitmapData = dataProxy.currentSelectModel.bmd;
        resize();

        _mask.x = dataProxy.currentSelectModel.rect.x + _diyBg.x;
        _mask.y = dataProxy.currentSelectModel.rect.y + _diyBg.y;
        _mask.width = dataProxy.currentSelectModel.rect.width;
        _mask.height = dataProxy.currentSelectModel.rect.height;

    }

    public function get ui() : RightContainer {
        return viewComponent as RightContainer;
    }
}
}
