package com.xy.util {
import com.adobe.utils.StringUtil;
import com.xy.ui.BlackButton;
import com.xy.ui.BlueButton;
import com.xy.ui.ButtonList;
import com.xy.ui.TabButton;

public class Tools {
    private static var _IDS : Array = [];

    public static function makeBlackButton(txt : String) : BlackButton {
        var btn : BlackButton = new BlackButton();
        btn.tf.htmlText = "<b><font color='#FFFFFF'>" + txt + "</font></b>";
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

    public static function makeListButton(num : int) : ButtonList {
        var btn : ButtonList = new ButtonList();
        if (num == 0) {
            btn.textTf.text = "无描边";
        } else {
            btn.textTf.text = num + "像素描边";
        }
        btn.textTf.mouseEnabled = false;
        btn.name = num + "";
        return btn;
    }

    public static function makeSizeButton(size : int, w : int) : ButtonList {
        var btn : ButtonList = new ButtonList();
        btn.textTf.text = size + "px";
        btn.textTf.width = btn.btn.width = w;

        btn.textTf.mouseEnabled = false;
        btn.name = size + "";
        return btn;
    }

    public static function makeId() : String {
        var id : String = STool.random(101, int.MAX_VALUE) + RandomName.makeName();
        while (_IDS.indexOf(id) != -1) {
            id = STool.random(101, int.MAX_VALUE) + RandomName.makeName();
        }

        _IDS.push(id);

        return id;
    }

    public static function recordId(id : String) : void {
        _IDS.push(id);
    }

    public static function gainConfig(str : String) : String {
        str = StringUtil.replace(str, "，", ",");
        str = StringUtil.trim(str);

        return str;
    }

}
}
