package com.xy.view.ui.componet {
import com.xy.component.Slider.Slider;
import com.xy.component.Slider.event.SliderEvent;
import com.xy.ui.SelectAlphaUI;
import com.xy.view.ui.events.SSelectAlphaUIEvent;

public class SSelectAlphaUI extends SelectAlphaUI {
    private var _slider : Slider;

    public function SSelectAlphaUI() {
        super();
        _slider = new Slider();
        _slider.setCtrlUI(sliderBtn, sliderBg);
        _slider.setData(1, 100, 1, 1);
        _slider.addEventListener(SliderEvent.DATA_UPDATE, __sliderHandler);
        updateText();
        
        tf.mouseEnabled = false;
    }
    
    public function setAlpha(alpha : Number):void{
    	_slider.setData(1, 100, 1, int(alpha*100));
    	_slider.resetUI();
    	updateText();
    }

    private function updateText() : void {
        tf.htmlText = "透明度(<font color='#FF0000'>" + _slider.getValue() + "%</font>)";
    }

    private function __sliderHandler(e : SliderEvent) : void {
    	e.stopImmediatePropagation();
    	e.stopPropagation();
        updateText();

        dispatchEvent(new SSelectAlphaUIEvent(SSelectAlphaUIEvent.ALPHA_CHANGE, _slider.getValue() / 100));
    }

}
}
