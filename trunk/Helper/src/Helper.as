package {
import com.xy.HelperFacade;
import com.xy.view.layer.DetailContainer;
import com.xy.view.layer.TreeContainer;

import flash.display.Sprite;
import flash.events.Event;

public class Helper extends Sprite {
    private var _facade : HelperFacade;

    private var _treeContainer : TreeContainer;
    private var _detailContainer : DetailContainer;

    public function Helper() {
        addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
    }

    private function __addToStageHandler(e : Event) : void {
        removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
        stage.addEventListener(Event.RESIZE, __resizeHandler);

        _treeContainer = new TreeContainer();
        _detailContainer = new DetailContainer();

        _facade = new HelperFacade();
        _facade.startUp(this);
    }

    private function __resizeHandler(e : Event) : void {

    }


    public function get detailContainer() : DetailContainer {
        return _detailContainer;
    }

    public function get treeContainer() : TreeContainer {
        return _treeContainer;
    }
}
}
