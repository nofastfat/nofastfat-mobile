package {
import com.xy.DiyFacade;
import com.xy.component.toolTip.ToolTip;
import com.xy.util.EnterFrameCall;
import com.xy.view.layer.LeftContainer;
import com.xy.view.layer.RightContainer;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import net.hires.debug.Stats;

public class DIY__SHIRT_79434419 extends Sprite {
    private var _facade : DiyFacade;

    private var _left : LeftContainer;
    private var _right : RightContainer;

    public function DIY__SHIRT_79434419() {
        addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
    }

    private function __addToStageHandler(e : Event) : void {
        ToolTip.initStage(stage);
        removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
        stage.addEventListener(Event.RESIZE, __resizeHandler);
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        EnterFrameCall.initState(stage);


        _left = new LeftContainer();
        _right = new RightContainer();
        _right.x = 200;
        addChild(_left);
        addChild(_right);

        _facade = new DiyFacade();
        _facade.startUp(this);

        //addChild(new Stats());
        __resizeHandler();
    }

    private function __resizeHandler(e : Event = null) : void {
        if (left != null) {
            left.resize();
        }
        if (_right != null) {
            _right.resize();
        }

        if (_facade != null) {
            _facade.sendNotification(Event.RESIZE);
        }
    }


    public function get right() : RightContainer {
        return _right;
    }

    public function get left() : LeftContainer {
        return _left;
    }
}
}
