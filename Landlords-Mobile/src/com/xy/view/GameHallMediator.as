package com.xy.view {
import com.xy.interfaces.AbsMediator;

/**
 * 游戏大厅 
 * @author xy
 */
public class GameHallMediator extends AbsMediator {
	public static const NAME : String = "GameHallMediator";
	
	public function GameHallMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}
}
}
