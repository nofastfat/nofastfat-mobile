package com.xy.component.numericStepper.event {
import flash.events.Event;

public class NumericStepperEvent extends Event {
	public static const DATA_UPDATE : String = "data_update";
	
	public var  value : int;
	
	public function NumericStepperEvent(type : String, vl : int,bubbles : Boolean = false, cancelable : Boolean = false) {
		super(type, bubbles, cancelable);
		value = vl;
	}
}
}
