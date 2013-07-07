package com.xy.view.ui.panels {
import com.xy.ui.UploadPanel;



public class SUploadPanel extends AbsPanel {
    private var _panel : UploadPanel;

    public function SUploadPanel(w : int = 270, h : int = 120, title : String = "上传中") {
        super(w, h, title);

        _panel = new UploadPanel();

        container.addChild(_panel);

        closeBtn.visible = false;
        _panel.progress.stop();
    }

    public function setData(txt : String) : void {
		_panel.tf.htmlText = txt;
    }

    public function playMc() : void {
        _panel.progress.play();
    }

    override public function close() : void {
        super.close();
        _panel.progress.stop();
    }

}
}
