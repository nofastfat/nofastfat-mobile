package com.xy.component.page.event {
import flash.events.Event;

public class SPageEvent extends Event {
	public static const PAGE_CHANGE : String = "PAGE_CHANGE";
	public var pageIndex : int;
	public var startIndex : int

	public function SPageEvent(type : String, pageIndex : int, startIndex : int, bubbles : Boolean = false, cancelable : Boolean = false) {
		super(type, bubbles, cancelable);
		this.pageIndex = pageIndex;
		this.startIndex = startIndex;
	}
}
}
