package {
import com.xy.ui.Loading;
import com.xy.util.EnterFrameCall;
import com.xy.util.STool;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;

public class SLoading extends Loading {

    private static var _intance : SLoading;

    public static function getInstance() : SLoading {
        if (_intance == null) {
            _intance = new SLoading();
        }

        return _intance;
    }

    private var _mask : Sprite;

    private var _stage : Stage;

    private var _tmpW : int;
    private var _tmpH : int;

    public function SLoading() {
        super();
        _mask = new Sprite();
        _tmpW = this.width;
        _tmpH = this.height;

        _mask.graphics.beginFill(0xFFFFFF, 0.3);
        _mask.graphics.drawRect(0, 0, 1, 1);
        _mask.graphics.endFill();

        _stage = EnterFrameCall.getStage();
        _stage.addEventListener(Event.RESIZE, __resizeHandler);
    }

    public function show() : void {
        _stage.addChild(_mask);
        _stage.addChild(this);
        __resizeHandler(null);
    }

    public function hide() : void {
        STool.remove(this);
        STool.remove(_mask);
    }

    private function __resizeHandler(e : Event) : void {
        if (_mask != null && _mask.stage != null) {
            _mask.width = _stage.stageWidth;
            _mask.height = _stage.stageHeight;

            this.x = (_stage.stageWidth - _tmpW) / 2;
            this.y = (_stage.stageHeight - _tmpH) / 2 - 100;
        }
    }
}
}
