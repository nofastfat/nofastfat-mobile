package com.xy.util {
import com.xy.ui.BlackButton;
import com.xy.ui.BlueButton;
import com.xy.ui.TabButton;

public class Tools {
	private static var _IDS : Array = [];
	
	public static function makeBlackButton(txt : String) : BlackButton {
		var btn : BlackButton = new BlackButton();
		btn.tf.text = txt;
		btn.tf.mouseEnabled = false;
		return btn;
	}
	
	public static function makeBlueButton(txt : String) : BlueButton {
		var btn : BlueButton = new BlueButton();
		btn.tf.text = txt;
		btn.tf.mouseEnabled = false;
		return btn;
	}

    public static function makeTabButton(txt : String) : TabButton {
        var btn : TabButton = new TabButton();
        btn.tf.text = txt;
        btn.tf.mouseEnabled = false;
        return btn;
    }
	
	
	public static function makeId() : String{
		var id : String = STool.random(101, int.MAX_VALUE) + RandomName.makeName();
		while(_IDS.indexOf(id) != -1){
			id = STool.random(101, int.MAX_VALUE) + RandomName.makeName();
		}
		
		_IDS.push(id);
		
		return id;
	}

}
}
