package com.xy.component.Slider.event {
import flash.events.Event;

public class SliderEvent extends Event {
	public static const DATA_UPDATE : String = "data_update";
	
	public var  value : int;
	
	public function SliderEvent(type : String, vl : int,bubbles : Boolean = false, cancelable : Boolean = false) {
		super(type, bubbles, cancelable);
		value = vl;
	}
}
}
