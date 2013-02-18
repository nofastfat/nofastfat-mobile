package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.model.enum.DataConfig;
import com.xy.util.EnterFrameCall;
import com.xy.util.Map;
import com.xy.view.roles.Hero;
import com.xy.view.roles.Monster;
import com.xy.view.sprite.MapLayer;
import com.xy.view.sprite.RoleLayer;

import flash.geom.Rectangle;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.DisplayObject;

/**
 * 主场景
 * @author xy
 */
public class GameMediator extends AbsMediator {
	public static const NAME : String = "GameMediator";

	public static const SHAKE_VALUE : int = 3;

	/**
	 * 初始化场景
	 * 参数：mapId
	 */
	public static const INTI_GAME : String = NAME + "INTI_GAME";
	public static const SHAKE_STAGE : String = NAME + "SHAKE_STAGE";

	private var _tween : Tween;
	private var _index : int = 0;

	/**
	 * 当前屏幕
	 */
	private var _screenRect : Rectangle;

	private var _enterFrameCount : int;

	public function GameMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}


	override public function makeNoticeMap() : Map {
		var map : Map = new Map();
		map.put(SHAKE_STAGE, shakeStage);
		map.put(INTI_GAME, initGame);
		return map;
	}

	public function initGame() : void {
		_tween = new Tween(ui, 0.1);

		EnterFrameCall.add(checkActiveObjs);
		EnterFrameCall.add(lockHeroCenter);

		/*监测范围比屏幕尺寸要大100*/
		_screenRect = new Rectangle(0, 0, DataConfig.WIDTH + 200, DataConfig.HEIGHT + 200);
	}

	/**
	 * 震屏
	 */
	private function shakeStage() : void {
		_index = -1;
		ui.y = 0;
		tweenComplete();
	}

	private function tweenComplete() : void {
		var arr : Array = [SHAKE_VALUE, 0, -SHAKE_VALUE];
		_index++;
		if (_index >= 3) {
			ui.y = 0;
			return;
		}

		var target : int = arr[_index];
		_tween.reset(ui, 0.1);
		_tween.moveTo(0, target);
		Starling.juggler.add(_tween);
		_tween.onComplete = tweenComplete;
	}

	/**
	 * 检查当前活动的障碍、怪物
	 */
	private function checkActiveObjs() : void {

		if (_enterFrameCount % 10 == 0) {
			var roleLayer : RoleLayer = ui.roleLayer;

			var mapLayer : MapLayer = ui.mapLayer;
			_screenRect.x = -mapLayer.x - 100;
			_screenRect.y = -mapLayer.y - 100;
			var activePkRects : Array = [dataProxy.hero.bodyRect];
			var hero : Hero = dataProxy.hero;

			/*设置怪物是否激活*/
			for each (var monster : Monster in dataProxy.liveMonsters) {
				/*屏幕之外的怪物，设置为休眠状态*/
				if (_screenRect.intersects(monster.bodyRect)) {
					monster.isActive = true;
					activePkRects.push(monster.bodyRect);

					if (!roleLayer.contains(monster)) {
						roleLayer.addChild(monster);
					}
				} else {
					monster.isActive = false;
					monster.removeFromParent();
				}
			}

			for each (var dis : DisplayObject in dataProxy.baffles) {
				if (_screenRect.contains(dis.x, dis.y)) {
					if (!roleLayer.contains(dis)) {
						roleLayer.addChild(dis);
					}
				} else {
					dis.removeFromParent();
				}
			}

			/*当前活动的区域*/
			DataConfig.activeBaffles = activePkRects;
		}

		_enterFrameCount++;
	}

	private function lockHeroCenter() : void {
		var shakeValue : int = SHAKE_VALUE;
		if (dataProxy.currentMap.height == DataConfig.HEIGHT) {
			shakeValue = 0;
		}

		var roleLayer : RoleLayer = ui.roleLayer;
		var mapLayer : MapLayer = ui.mapLayer;
		var hero : Hero = dataProxy.hero;
		var px : Number = -hero.x + DataConfig.HALF_WIDTH;
		var py : Number = -hero.y + DataConfig.VIEW_HEIGHT;
		var minX : int = DataConfig.WIDTH - dataProxy.currentMap.width;
		var minY : int = DataConfig.HEIGHT - dataProxy.currentMap.height + shakeValue;

		px = px > 0 ? 0 : px;
		py = py > -shakeValue ? -shakeValue : py;
		px = px < minX ? minX : px;
		py = py < minY ? minY : py;

		dataProxy.layerOffsetX = mapLayer.x = roleLayer.x = px;
		dataProxy.layerOffsetY = mapLayer.y = roleLayer.y = py;

	}

	public function get ui() : Game {
		return viewComponent as Game;
	}
}
}
