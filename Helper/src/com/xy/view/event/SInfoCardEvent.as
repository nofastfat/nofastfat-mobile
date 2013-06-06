package com.xy.view.event {
import com.xy.model.vo.OrganizedStructVo;

import flash.events.Event;

public class SInfoCardEvent extends Event {
    /**
     * 展开/收起 下属详情
     */
    public static const DETAIL_CHANGE : String = "DETAIL_CHANGE";

    /**
     * 显示/隐藏 自己的详细信息
     */
    public static const SHOW_DETAIL : String = "SHOW_DETAIL";

    public var vo : OrganizedStructVo;
    public var isShow : Boolean;

    public function SInfoCardEvent(type : String, vo : OrganizedStructVo, isShow : Boolean = false, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);

        this.vo = vo;
        this.isShow = isShow;

    }
}
}
