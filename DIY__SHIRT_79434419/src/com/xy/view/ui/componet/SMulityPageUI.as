package com.xy.view.ui.componet {
import com.xy.component.Slider.Slider;
import com.xy.component.Slider.SliderMode;
import com.xy.ui.MulityPageUI;
import com.xy.util.EnterFrameCall;

public class SMulityPageUI extends MulityPageUI {
    private var _scroll : Slider;

    public function SMulityPageUI() {
        super();
        _scroll = new Slider();
        _scroll.setCtrlUI(scrollUI.scrollBtn, scrollUI.bg, scrollUI.prevBtn, scrollUI.nextBtn, SliderMode.HORIZONTAL);
        _scroll.setData(0, 100, 1, 0);
    }

    public function resize() : void {
        this.x = 20;

        var w : int = EnterFrameCall.getStage().stageWidth - 200 - 20 - 20 - 140;
        bg.width = w;
        scrollUI.bg.width = w - 20 - 30;
        scrollUI.nextBtn.x = scrollUI.bg.width + 13;
        _scroll.resetUI();

        this.y = EnterFrameCall.getStage().stageHeight - this.height - 20;
    }
}
}
