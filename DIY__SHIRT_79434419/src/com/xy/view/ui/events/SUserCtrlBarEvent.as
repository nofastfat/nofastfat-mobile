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
	 * 显示编辑文字的面板 
	 */	
    public static const SHOW_EDIT_TEXT_PANEL : String = "SHOW_EDIT_TEXT_PANEL";
	
    /**
     * 字体颜色
     * data:uint
     */
    public static const FONT_COLOR : String = "FONT_COLOR";
	
	/**
	 * 字体类型
	 * data:String 
	 */	
	public static const FONT_FACE : String = "FONT_FACE";
	
	/**
	 * 字体大小
	 * data:String 
	 */	
	public static const FONT_SIZE : String = "FONT_SIZE";
	
	/**
	 * 加粗
	 * data:boolean 
	 */	
	public static const FONT_BOLD : String = "FONT_BOLD";
	
	/**
	 * 对齐方式
	 * data:String 
	 */	
	public static const FONT_ALIGN : String = "FONT_ALIGN";

    public var data : *;

    public function SUserCtrlBarEvent(type : String, data : * = null, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.data = data;
    }

}
}
