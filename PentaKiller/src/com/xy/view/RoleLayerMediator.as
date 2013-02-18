package com.xy.view {
import com.xy.cmd.GameStartCmd;
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.ISimpleMediator;
import com.xy.util.EnterFrameCall;
import com.xy.util.Map;
import com.xy.view.sprite.RoleLayer;

import starling.display.DisplayObject;

/**
 * 处理RoleLayer上的排序 
 * @author xy
 */
public class RoleLayerMediator extends AbsMediator implements ISimpleMediator {
	public static const NAME : String = "RoleLayerMediator";

	public function RoleLayerMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}

	override public function makeNoticeMap() : Map {
		var map : Map = new Map();
		//TODO 这里排序有问题
		map.put(GameStartCmd.NAME, startSort);
		return map;
	}

	private function startSort(...rest) : void {
		EnterFrameCall.add(sort);
	}

	private function stopSort(...rest) : void {
		EnterFrameCall.del(sort);
	}

	private function sort() : void {
		ui.sortChildren(sortFun);
	}

	/**
	 * 排序规则 
	 * @param child1
	 * @param child2
	 * @return 
	 */	
	private function sortFun(child1 : DisplayObject, child2 : DisplayObject) : int {
		if (child1.y < child2.y) {
			return -1;
		} else if (child1.y > child2.y) {
			return 1;
		} else {
			if (child1.x < child2.x) {
				return -1;
			} else {
				return 1;
			}
		}

		return 0;
	}

	public function get ui() : RoleLayer {
		return viewComponent as RoleLayer;
	}
}
}
