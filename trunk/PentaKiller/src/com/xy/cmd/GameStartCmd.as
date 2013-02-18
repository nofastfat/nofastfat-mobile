package com.xy.cmd {
import com.xy.interfaces.AbsCommand;
import com.xy.view.GameMediator;
import com.xy.view.HeroMediator;

import org.puremvc.as3.interfaces.INotification;

import starling.core.Starling;

/**
 * 开始一波游戏
 * @author xy
 */
public class GameStartCmd extends AbsCommand {
	/**
	 * 开始游戏<br>
	 * 参数:游戏关卡:int
	 */
	public static const NAME : String = "GameStartCmd";

	public function GameStartCmd() {
		super();
	}

	override public function execute(notification : INotification) : void {
		var defaultMapId : int = 70001;
		Loading.getInstance().showLoading(0, false);

		Starling.juggler.delayCall(function() : void {
			var maps : Array = [70002, 70003, 70004];
			for each (var mapId : int in maps) {
				dataProxy.mapList.push(Assets.getMap(mapId));
			}

			sendNotification(SwitchMapCmd.NAME, defaultMapId);

			sendNotification(HeroMediator.INIT_HERO);
			
			
			Starling.juggler.delayCall(sendNotification, 1, GameMediator.INTI_GAME);
		}, 0.5);

	}
}
}
