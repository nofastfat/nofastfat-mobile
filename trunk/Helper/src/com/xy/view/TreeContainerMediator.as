package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.view.layer.DetailContainer;

public class TreeContainerMediator extends AbsMediator {
    public static const NAME : String = "TreeContainerMediator";

    public function TreeContainerMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();

        return map;
    }

    public function get ui() : DetailContainer {
        return viewComponent as DetailContainer;
    }
}
}