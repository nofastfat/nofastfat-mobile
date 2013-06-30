package com.xy.view.ui.events {
import flash.events.Event;

public class SUserCtrlBarEvent extends Event {
    /**
     * 描边的宽度
     * data:int
     */
    public static const LINE_CHANGE : String = "LINE_CHANGE";

    /**
     * 描边颜色
     * data:uint
     */
    public static const LINE_COLOR : String = "LINE_COLOR";

    /**
     * 是否显示满图片
     * data:Boolean
     */
    public static const FULL_STATUS : String = "FULL_STATUS";

    /**
     * alpha 变化
     * data:number
     */
    public static const ALPHA : String = "ALPHA";
    
    /**
     * 上移一层
     */
    public static const UP_LEVEL : String = "UP_LEVEL";
    
    /**
     * 下移一层
     */
    public static const DOWN_LEVEL : String = "DOWN_LEVEL";
    
    /**
     * 删除
     */
    public static const DELETE : String = "DELETE";
    
    
    /**
     * 字体颜色
     * data:uint
     */    
    public static const FONT_COLOR : String = "FONT_COLOR";

    public var data : *;

    public function SUserCtrlBarEvent(type : String, data : * = null, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.data = data;
    }

}
}
