package com.xy.view.event {
import starling.events.Event;

public class NewUserPanelEvent extends Event {
	
	/**
	 * 创建新用户 
	 */	
	public static const CREATE : String = "CREATE";
	
	/**
	 * 取消创建 
	 */	
	public static const CANCEL : String = "CANCEL";

	public function NewUserPanelEvent(type : String, bubbles : Boolean = false, data : Object = null) {
		super(type, bubbles, data);
	}
}
}
