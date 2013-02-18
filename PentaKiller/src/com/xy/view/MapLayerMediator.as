package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.model.enum.DataConfig;
import com.xy.model.vo.MapVo;
import com.xy.util.EnterFrameCall;
import com.xy.util.Map;
import com.xy.util.MapUtil;
import com.xy.util.Tools;
import com.xy.view.roles.Monster;
import com.xy.view.sprite.MapLayer;
import com.xy.view.sprite.RoleLayer;

import flash.events.KeyboardEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;

import starling.display.Image;
import starling.display.QuadBatch;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

/**
 * 地图层
 * @author xy
 */
public class MapLayerMediator extends AbsMediator {
	public static const NAME : String = "MapLayerMediator";
	/**
	 * 初始化地图 <br>
	 */
	public static const INIT_MAP : String = NAME + "INIT_MAP";

	/**
	 * 清空地图
	 */
	public static const CLEAR_MAP : String = NAME + "CLEAR_MAP";

	private var _image : Image;

	private var _movePlacement : Point;

	private var _tileBg : Image;

	public function MapLayerMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}

	override public function onRegister() : void {
		_movePlacement = new Point();
	}

	override public function makeNoticeMap() : Map {
		var map : Map = new Map();

		map.put(INIT_MAP, initMap);
		map.put(CLEAR_MAP, clearMap);

		return map;
	}

	private function clearMap() : void {
		Tools.remove(ui, _tileBg);
		var roleLayer : RoleLayer = facade.retrieveMediator(RoleLayerMediator.NAME).getViewComponent() as RoleLayer;
		Tools.clear(roleLayer);

		dataProxy.baffles = [];

		if (dataProxy.currentMap != null) {
			SoundManager.stop(dataProxy.currentMap.bgSoundName);
		}
	}

	/**
	 * 初始化地图
	 */
	private function initMap() : void {
		var mapVo : MapVo = dataProxy.currentMap;
		var imageCache : Array = [];
		var mapArr : Array = mapVo.underMapData;
		Tools.remove(ui, _tileBg);

		//地表层绘制
		var qb : QuadBatch = new QuadBatch();
		var img : Image;
		var textureAtlas : TextureAtlas = Assets.getTextureAtlas("roleTexture", "roleXml");
		for (var i : int = 0; i < mapArr.length; i++) {
			for (var j : int = 0; j < mapArr[0].length; j++) {
				var tileIndex : int = mapArr[i][j];
				var tileName : String = MapUtil.makeTileName(tileIndex);
				if (imageCache[tileName] == null) {
					var texture : Texture = textureAtlas.getTexture(tileName);
					img = new Image(texture);
					imageCache[tileName] = img;
				} else {
					img = imageCache[tileName];
				}
				img.x = i * DataConfig.TILE_SIZE;
				img.y = j * DataConfig.TILE_SIZE;

				qb.addImage(img);
			}
		}

		//地表装饰绘制
		for each (var deck : * in mapVo.mapDeckMapData) {
			var gdcode : int = deck.gdcode;
			var deckName : String = "ui" + gdcode;
			if (imageCache[deckName] == null) {
				texture = textureAtlas.getTexture(deckName);
				img = new Image(texture);
				img.scaleX = img.scaleY = 2;
				imageCache[deckName] = img;
			} else {
				img = imageCache[deckName];
			}
			var rect : Rectangle = Assets.getUIRect(gdcode);
			img.pivotX = rect.x;
			img.pivotY = rect.y;
			img.x = deck.px;
			img.y = deck.py;

			qb.addImage(img);

			/*传送门*/
			if (gdcode == 50019) {
				rect.setTo(deck.px - rect.x, deck.py - rect.y, img.width, img.height);

				dataProxy.portalRect = rect;
			}
		}

		_tileBg = Tools.clone(qb);

		ui.addChild(_tileBg);

		ui.addEventListener(TouchEvent.TOUCH, __touchHandler);
		EnterFrameCall.getStage().addEventListener(KeyboardEvent.KEY_UP, __keyUpHandler);

		//添加障碍,障碍参与层级排序，添加到角色层
		var roleLayer : RoleLayer = facade.retrieveMediator(RoleLayerMediator.NAME).getViewComponent() as RoleLayer;
		for each (var baffle : * in mapVo.baffleMapData) {
			gdcode = baffle.gdcode;
			var baffleName : String = "ui" + gdcode;
			texture = textureAtlas.getTexture(baffleName);
			img = new Image(texture);
			img.scaleX = img.scaleY = 2;
			rect = Assets.getUIRect(gdcode);
			img.pivotX = rect.x;
			img.pivotY = rect.y;
			img.x = baffle.px;
			img.y = baffle.py;
			img.touchable = false;
			roleLayer.addChild(img);
			dataProxy.baffles.push(img);
		}

		SoundManager.play(mapVo.bgSoundName, -1);

		//showMonsterMask();
	}

	private function showMonsterMask() : void {
		for each (var mon : Monster in dataProxy.liveMonsters) {
			//出生点
			var img : Image = Tools.makeImg(5, 0x110000);
			img.pivotX = img.pivotY = 5;
			ui.addChild(img);
			img.x = mon.vO.birthLocation.x;
			img.y = mon.vO.birthLocation.y;

			//巡逻范围
			var img2 : Image = Tools.makeImg(mon.vO.roamRadius, 0x111100);
			img2.pivotX = img2.pivotY = mon.vO.roamRadius;
			ui.addChild(img2);
			img2.x = mon.vO.birthLocation.x;
			img2.y = mon.vO.birthLocation.y;

			//追击范围
			var img3 : Image = Tools.makeImg(mon.vO.pursueAttackRadius, 0x001100);
			img3.pivotX = img3.pivotY = mon.vO.pursueAttackRadius;
			ui.addChild(img3);
			img3.x = mon.vO.birthLocation.x;
			img3.y = mon.vO.birthLocation.y;

			//友军警戒范围
			var img4 : Image = Tools.makeImg(mon.vO.friendWarnRadius, 0x000088);
			img4.pivotX = img4.pivotY = mon.vO.friendWarnRadius;
			ui.addChild(img4);
			img4.x = mon.vO.birthLocation.x;
			img4.y = mon.vO.birthLocation.y;
		}
	}

	private function __touchHandler(e : TouchEvent) : void {
		var touch : Touch = e.touches[0];
		if (touch.phase == TouchPhase.ENDED || touch.phase == TouchPhase.MOVED) {
			sendNotification(HeroMediator.MOVE_TO, touch.getLocation(ui));
		}

	}

	private function __keyUpHandler(e : KeyboardEvent) : void {
		switch (e.keyCode) {
			case Keyboard.J:
				sendNotification(HeroMediator.ATTACK_ACTION);
				break;
		}
	}

	public function get ui() : MapLayer {
		return viewComponent as MapLayer;
	}
}
}
