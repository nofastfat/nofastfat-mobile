package com.xy.model {
import com.xy.model.vo.HeroVo;
import com.xy.model.vo.MapVo;
import com.xy.util.Cache;
import com.xy.view.roles.Hero;
import com.xy.view.roles.Monster;

import flash.geom.Rectangle;

import org.puremvc.as3.patterns.proxy.Proxy;

/**
 * 数据代理
 * @author xy
 */
public class PKDataProxy extends Proxy {
	public static const NAME : String = "PKDataProxy";

	private var _liveMonsters : Array = [];

	private var _baffles : Array = [];

	/**
	 * 当前的地图数据
	 */
	private var _currentMap : MapVo;

	private var _portalRect : Rectangle;

	private var _roadOfScene : Array = [];

	private var _hero : Hero;

	private var _npcs : Array = [];

	public var layerOffsetX : Number = 0;
	public var layerOffsetY : Number = 0;

	public var mapList : Array = [];

	public var heroVo : HeroVo;

	public function PKDataProxy() {
		super(NAME);
	}


	/**
	 * 添加一个怪物
	 * @param monster
	 */
	public function addMonster(monster : Monster) : void {
		if (monster == null) {
			return;
		}

		_liveMonsters.push(monster);
	}

	/**
	 * 获取当前剩余怪物的个数
	 * @return
	 */
	public function getMonsterCount() : int {
		if (_liveMonsters == null) {
			return 0;
		}

		return _liveMonsters.length;
	}

	/**
	 * 删除怪物
	 * @param id
	 */
	public function delMonster(id : int) : void {
		for (var i : int = 0; i < _liveMonsters.length; i++) {
			var mon : Monster = _liveMonsters[i];
			if (mon.id == id) {
				_liveMonsters.splice(i, 1);
				return;
			}
		}
	}

	/**
	 * 查询一个怪物
	 * @param id
	 * @return
	 */
	public function getMonster(id : int) : Monster {
		for (var i : int = 0; i < _liveMonsters.length; i++) {
			var mon : Monster = _liveMonsters[i];
			if (mon.id == id) {
				return mon;
			}
		}

		return null;
	}

	/**
	 * 当前关卡的地图信息
	 */
	public function get currentMap() : MapVo {
		return _currentMap;
	}

	/**
	 * @private
	 */
	public function set currentMap(value : MapVo) : void {
		_currentMap = value;
	}

	/**
	 * 怪物的行走路线 [Point, Point, ...] ,值为场景点，可以直接使用
	 */
	public function get roadOfScene() : Array {
		return _roadOfScene;
	}

	/**
	 * 当前活着的的怪物<br>
	 * [Monster, Monster, ...]
	 */
	public function get liveMonsters() : Array {
		return _liveMonsters;
	}

	/**
	 * 当前的角色
	 */
	public function get hero() : Hero {
		return _hero;
	}

	/**
	 * @private
	 */
	public function set hero(value : Hero) : void {
		_hero = value;
	}

	/**
	 * 当前的NPC
	 */
	public function get npcs() : Array {
		return _npcs;
	}

	/**
	 * @private
	 */
	public function set npcs(value : Array) : void {
		_npcs = value;
	}

	/**
	 * 传送门的出发区域
	 */
	public function get portalRect() : Rectangle {
		return _portalRect;
	}

	/**
	 * @private
	 */
	public function set portalRect(value : Rectangle) : void {
		_portalRect = value;
	}

	public function set liveMonsters(value : Array) : void {
		_liveMonsters = value;
	}

	/**
	 * 障碍物
	 */
	public function get baffles() : Array {
		return _baffles;
	}

	/**
	 * @private
	 */
	public function set baffles(value : Array) : void {
		_baffles = value;
	}

	/**
	 * 存档
	 */
	public function saveUserVo() : void {
		if (_hero != null) {
			Cache.write(_hero.VO);
		}
	}

}
}
