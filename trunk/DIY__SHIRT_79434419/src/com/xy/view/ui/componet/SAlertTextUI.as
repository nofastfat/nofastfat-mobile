package com.xy.view.ui.componet {
import com.xy.component.alert.Alert;
import com.xy.component.alert.enum.AlertType;
import com.xy.component.alert.interfaces.IAlertContent;
import com.xy.ui.AlertTextUI;

import flash.text.TextField;

public class SAlertTextUI extends AlertTextUI implements IAlertContent {
	private var _bornY : int = 0;

	public function SAlertTextUI(txt : String) {
		super();
		_bornY = msgTf.y;
		msgTf.htmlText = txt;

		msgTf.y = _bornY + .8 * (msgTf.height - msgTf.textHeight) / 2;
	}

	public function getResult() : * {
		return null;
	}

	public function getAlertType() : int {
		return AlertType.OK | AlertType.CANCEL;
	}

	public function getTitleType() : int {
		return 0;
	}

	public function dispose() : void {
	}
}
}
