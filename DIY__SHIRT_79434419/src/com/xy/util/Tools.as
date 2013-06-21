package com.xy.util {
	import com.xy.ui.BlackButton;

public class Tools {
	public static function makeBlackButton(txt : String):BlackButton{
		var btn : BlackButton = new BlackButton();
		btn.tf.text = txt;
		btn.tf.mouseEnabled = false;
		return btn;
	}
}
}
