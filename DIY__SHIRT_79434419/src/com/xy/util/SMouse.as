package com.xy.util {
	import flash.display.BitmapData;

public class SMouse {
	
	private static var _intance : SMouse;
	
	public static function getInstance() : SMouse {
		if (_intance == null) {
			_intance = new SMouse();
		}
		
		return _intance;
	}
	
	
    public function SMouse() {
    }
	
	public function setMouse(bmd : BitmapData):void{
	
	}
	
	public function 
}
}
