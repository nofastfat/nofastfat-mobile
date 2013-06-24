package com.xy.view.ui.events {
import com.xy.model.vo.BitmapDataVo;

import flash.events.Event;

public class UploadImagePanelEvent extends Event {
    public static const UPLOAD_IMAGE : String = "UPLOAD_IMAGE";

    public static const CLEAR_ALL_IMAGE : String = "CLEAR_ALL_IMAGE";

    public static const THUMB_STATUS_CHANGE : String = "THUMB_STATUS_CHANGE";

    public var bitmapDatas : Array;

    public var vo : BitmapDataVo;

    public function UploadImagePanelEvent(type : String, bitmapDatas : Array = null, vo : BitmapDataVo = null, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.bitmapDatas = bitmapDatas;
        this.vo = vo;
    }
}
}
