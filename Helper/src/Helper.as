package {
import com.xy.HelperFacade;

import flash.display.Sprite;
import flash.events.Event;

public class Helper extends Sprite {
    private var _facade : HelperFacade;

    public function Helper() {
        addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
    }

    private function __addToStageHandler(e : Event) : void {
        removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);

        _facade = new HelperFacade();
        _facade.startUp(this);
    }
}
}
