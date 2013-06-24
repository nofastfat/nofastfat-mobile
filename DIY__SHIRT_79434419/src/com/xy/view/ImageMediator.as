package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.enum.DiyDataNotice;
import com.xy.util.EnterFrameCall;
import com.xy.util.PopUpManager;
import com.xy.view.ui.ctrls.ImageContainer;
import com.xy.view.ui.events.ImageContainerEvent;
import com.xy.view.ui.events.UploadImagePanelEvent;
import com.xy.view.ui.panels.UploadImagePanel;

import flash.events.Event;
import flash.events.MouseEvent;

public class ImageMediator extends AbsMediator {
    public static const NAME : String = "ImageMediator";

    private var _panel : UploadImagePanel;

    public function ImageMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(Event.RESIZE, resize);
        map.put(DiyDataNotice.IMAGE_UPDATE, imageUpdate);
        return map;
    }

    override public function onRegister() : void {
        ui.addEventListener(ImageContainerEvent.UPLOAD_IMAGE, __showUploadPanelHandler);
    }

    private function __showUploadPanelHandler(e : ImageContainerEvent) : void {
        if (_panel == null) {
            _panel = new UploadImagePanel();
            _panel.addEventListener(UploadImagePanelEvent.UPLOAD_IMAGE, __uploadHandler);
            _panel.addEventListener(UploadImagePanelEvent.CLEAR_ALL_IMAGE, __clearAllHandler);
            _panel.addEventListener(UploadImagePanelEvent.THUMB_STATUS_CHANGE, __thumbStatusHandler);
        }

        _panel.setData(dataProxy.images);
        PopUpManager.getInstance().showPanel(_panel);
    }

    private function resize() : void {
        if (_panel != null && _panel.stage != null) {
            _panel.resize();
        }
    }

    private function imageUpdate() : void {
        if (_panel != null) {
            _panel.setData(dataProxy.images);
        }
    }

    private function __uploadHandler(e : UploadImagePanelEvent) : void {
        dataProxy.addImages(e.bitmapDatas);
    }

    private function __clearAllHandler(e : UploadImagePanelEvent) : void {
		dataProxy.clearAll();
    }

    private function __thumbStatusHandler(e : UploadImagePanelEvent) : void {
		dataProxy.imageStatusChange(e.vo.id, e.vo.show);
    }

    public function get ui() : ImageContainer {
        return viewComponent as ImageContainer;
    }
}
}
