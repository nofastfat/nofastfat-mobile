package com.xy.view {
import com.xy.interfaces.AbsMediator;

/**
 * 游戏房间，核心逻辑 
 * @author xy
 */
public class GameRoomMediator extends AbsMediator {
	public static const NAME : String = "GameRoomMediator";
	
	public function GameRoomMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}
}
}
