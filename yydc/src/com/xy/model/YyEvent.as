package com.xy.model {
import flash.events.Event;


/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-20 下午6:04:42
 **/
public class YyEvent extends Event {
	
	public var data : *;
	
	public function YyEvent(type : String, dat : * = null,bubbles : Boolean = false, cancelable : Boolean = false) {
		super(type, bubbles, cancelable);
		data = dat;
	}
}
}
