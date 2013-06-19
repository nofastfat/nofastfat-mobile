package com.xy.view.event {
import com.xy.model.vo.OrganizedStructVo;

import flash.display.DisplayObject;
import flash.display.MovieClip;
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

    /**
     * 显示/隐藏 能力矩阵
     */
    public static const SHOW_POWER_MATRIX : String = "SHOW_POWER_MATRIX";

    public static const SHOW_PERSON_CARD : String = "SHOW_PERSON_CARD";

    public var vo : OrganizedStructVo;
    public var isShow : Boolean;

    public var id : String;
    public var _target : DisplayObject;
    public var name : String;

    public function SInfoCardEvent(type : String, vo : OrganizedStructVo, isShow : Boolean = false, id : String = "0", _target : DisplayObject = null, name : String = null, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);

        this.vo = vo;
        this.isShow = isShow;
        this.id = id;
        this._target = _target;
        this.name = name;

    }
}
}
