package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.util.STool;
import com.xy.view.layer.DetailContainer;
import com.xy.view.layer.TreeContainer;
import com.xy.view.ui.SInfoCard;

import flash.events.Event;

public class TreeContainerMediator extends AbsMediator {
    public static const NAME : String = "TreeContainerMediator";

    /**
     * 初始化显示
     */
    public static const INIT_SHOW : String = NAME + "INIT_SHOW";

    private var _treeRoot : SInfoCard;

    public function TreeContainerMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(INIT_SHOW, initShow);
        map.put(Event.RESIZE, resize);
        return map;
    }

    public function get ui() : TreeContainer {
        return viewComponent as TreeContainer;
    }

    /**
     * 初始化的显示
     */
    private function initShow() : void {
        if (_treeRoot == null) {
            _treeRoot = new SInfoCard();
        }

        ui.addChild(_treeRoot);
        _treeRoot.x = (ui.sWidth - _treeRoot.width) / 2;
        _treeRoot.y = (ui.sHeight - _treeRoot.height) / 2;
		_treeRoot.setData(dataProxy.selfData);
    }

    private function resize(...rest) : void {
        if (_treeRoot != null) {
            _treeRoot.x = (ui.sWidth - _treeRoot.width) / 2;
            _treeRoot.y = (ui.sHeight - _treeRoot.height) / 2;
        }
    }
}
}
