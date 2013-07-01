package com.xy.view.ui.panels {
import com.xy.ui.BlueButton;
import com.xy.util.Tools;
import com.xy.view.ui.events.EditTextPanelEvent;

import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldType;

public class EditTextPanel extends AbsPanel {

    private var _tf : TextField;
    private var _ok : BlueButton;
    private var _cancal : BlueButton;

    public function EditTextPanel(w : int = 300, h : int = 300, title : String = "编辑文字") {
        super(w, h, title);

        _tf = new TextField();
        _tf.type = TextFieldType.INPUT;
        _tf.border = true;
        _tf.borderColor = 0x333333;
        _tf.width = 260;
        _tf.height = 195;

        _ok = Tools.makeBlueButton("确认");
        _cancal = Tools.makeBlueButton("取消");

        container.addChild(_tf);
        container.addChild(_ok);
        container.addChild(_cancal);

        _ok.x = 40;
        _ok.y = 206;
        _cancal.x = 140;
        _cancal.y = 206;

        _ok.addEventListener(MouseEvent.CLICK, __okHandler);
        _cancal.addEventListener(MouseEvent.CLICK, __closeHandler);
    }

    public function setText(txt : String) : void {
        _tf.text = txt;
    }

    private function __okHandler(e : MouseEvent) : void {
        dispatchEvent(new EditTextPanelEvent(EditTextPanelEvent.EDIT, _tf.text));
        __closeHandler(null);
    }
}
}
