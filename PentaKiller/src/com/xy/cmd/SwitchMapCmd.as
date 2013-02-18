package com.xy.cmd {
import com.xy.interfaces.AbsCommand;
import com.xy.model.ConfigXml;
import com.xy.model.enum.DataConfig;
import com.xy.view.HeroMediator;
import com.xy.view.MapLayerMediator;
import com.xy.view.MonsterMediator;
import com.xy.view.NpcMediator;
import com.xy.view.PortalMediator;
import com.xy.view.UILayerMediator;

import flash.utils.getTimer;

import org.puremvc.as3.interfaces.INotification;

import starling.core.Starling;

/**
 * 切换地图
 * @author xy
 */
public class SwitchMapCmd extends AbsCommand {
	/**
	 * 切换地图
	 * 参数：mapVo
	 */
	public static const NAME : String = "SwitchMapCmd";

	private var _showTime : int;

	public function SwitchMapCmd() {
		super();
	}

	override public function execute(notification : INotification) : void {
		var mapId : int = notification.getBody() as int;
		if (dataProxy.currentMap != null && dataProxy.currentMap.id == mapId) {
			trace("同场景，无需切换," + mapId);
			return;
		}

		/*显示loading*/
		if (mapId == 70001) {
			Loading.getInstance().showLoading();
		} else {
			Loading.getInstance().showLoading(1);
		}
		_showTime = getTimer();

		/*延时初始化*/
		Starling.juggler.delayCall(function() : void {
			/*清空场景*/
			sendNotification(MapLayerMediator.CLEAR_MAP);
			sendNotification(NpcMediator.CLEAR_NPC);
			sendNotification(PortalMediator.CLEAR_PORTAL);
			sendNotification(HeroMediator.HIDE_HERO);
			sendNotification(UILayerMediator.HIDE_HERO_INFO_BAR);
			sendNotification(MonsterMediator.CLEAR_MONSTERS);

			/*计算地图数据*/
			dataProxy.currentMap = Assets.getMap(mapId);
			dataProxy.currentMap.monsters = ConfigXml.getMonstersInMap(mapId);
			dataProxy.currentMap.rewards = ConfigXml.getRewards(mapId);
			dataProxy.currentMap.bgSoundName = ConfigXml.getMapBgSound(mapId);


			Starling.juggler.delayCall(function() : void {
				/*主场景上，HP自动回满*/
				if (mapId == 70001) {
					sendNotification(HeroMediator.GAIN_HP, -1);
				}

				sendNotification(MapLayerMediator.INIT_MAP);
				sendNotification(NpcMediator.INIT_NPC);
				sendNotification(PortalMediator.INTI_PORTAL);
				sendNotification(HeroMediator.SHOW_HERO);
				sendNotification(MonsterMediator.INIT_MONSTERS);

				if (mapId == 70001) {
					sendNotification(UILayerMediator.HIDE_HERO_INFO_BAR);
					sendNotification(UILayerMediator.HIDE_CTRL_BAR);
				} else {
					sendNotification(UILayerMediator.SHOW_HERO_INFO_BAR);
					sendNotification(UILayerMediator.SHOW_CTRL_BAR);
				}

				if (getTimer() - _showTime < DataConfig.LOADING_SHOW_TIME) {
					Starling.juggler.delayCall(Loading.getInstance().hide, (DataConfig.LOADING_SHOW_TIME - (getTimer() - _showTime)) / 1000);
				} else {
					Loading.getInstance().hide();
				}

				dataProxy.saveUserVo();
			}, .3);
		}, 0.3);

	}
}
}
