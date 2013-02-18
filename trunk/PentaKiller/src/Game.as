package {

import com.xy.PKFacade;
import com.xy.view.sprite.MapLayer;
import com.xy.view.sprite.RoleLayer;
import com.xy.view.sprite.UILayer;

import starling.display.Sprite;
import starling.events.Event;

public class Game extends Sprite {
	private var _mapLayer : MapLayer;

	private var _roleLayer : RoleLayer;

	private var _uiLayer : UILayer;

	/**
	 * MVC
	 */
	private var _facade : PKFacade;

	public function Game() {
		super();

		initLayers();

		_facade = new PKFacade();

		addEventListener(Event.ADDED_TO_STAGE, __addHandler);
	}

	private function initLayers() : void {
		_mapLayer = new MapLayer();
		_roleLayer = new RoleLayer();
		_uiLayer = new UILayer();
	}

	private function __addHandler() : void {
		addChild(_mapLayer);
		addChild(_roleLayer);
		addChild(_uiLayer);

		_facade.startUp(this);
	}

	/**
	 * 角色层，包括怪物、炮塔、光效、子弹、道具等
	 */
	public function get roleLayer() : RoleLayer {
		return _roleLayer;
	}

	/**
	 *　ＵＩ层
	 */
	public function get uiLayer() : UILayer {
		return _uiLayer;
	}

	/**
	 * 地图层，包括地图贴图和装饰
	 */
	public function get mapLayer() : MapLayer {
		return _mapLayer;
	}
}
}
