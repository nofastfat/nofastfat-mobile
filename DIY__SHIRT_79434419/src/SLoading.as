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
	
    public function SLoading() {
        super();
        _mask = new Sprite();

        _mask.graphics.beginFill(0x000000, .2);
        _mask.graphics.drawRect(0, 0, 1, 1);
        _mask.graphics.endFill();
		
		_stage = EnterFrameCall.getStage();
        _stage.addEventListener(Event.RESIZE, __resizeHandler);
		this.stop();
    }

    public function show() : void {
		_stage.addChild(_mask);
		_stage.addChild(this);
		__resizeHandler(null);
		play();
    }

    public function hide() : void {
		STool.remove(this);
		STool.remove(_mask);
		this.stop();
    }

    private function __resizeHandler(e : Event) : void {
        if (_mask != null && _mask.stage != null) {
            _mask.width = _stage.stageWidth;
            _mask.height = _stage.stageHeight;
			
			this.x = (_stage.stageWidth-this.width)/2;
			this.y = (_stage.stageHeight -this.height)/2-100;
        }
    }
}
}
