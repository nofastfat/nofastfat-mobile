package com.xy.view {
import com.xy.component.Slider.Slider;
import com.xy.component.Slider.event.SliderEvent;
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.view.layer.SUIPanel;

public class SUIPanelMediator extends AbsMediator {
    public static const NAME : String = "SUIPanelMediator";

    /**
     * 重置缩放值
     * scaleValue : Number
     */
    public static const REST_SCALE : String = NAME + "REST_SCALE";

    private var _slider : Slider;

    private var _lastValue : int;

    public function SUIPanelMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);
        _slider = new Slider();
        _slider.setCtrlUI(ui.scrollMc.sliderBtn, ui.scrollMc.bg);
        _lastValue = 49;
        _slider.setData(0, 49, 1, _lastValue);
        _slider.addEventListener(SliderEvent.DATA_UPDATE, __dataUpdateHandler);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(REST_SCALE, restScale);
        return map;
    }

    private function restScale(scale : Number) : void {
        var vl : int = scale * 100;
        _lastValue = vl - 50 - 1;
        _slider.setData(0, 49, 1, _lastValue);
    }

    public function get ui() : SUIPanel {
        return viewComponent as SUIPanel;
    }

    private function __dataUpdateHandler(e : SliderEvent) : void {
        var per : Number = (_slider.getValue() - _lastValue) / 100;
        sendNotification(InfoTreeContainerMediator.SCALE_CHANGE, per);

        _lastValue = _slider.getValue();
    }

}
}
