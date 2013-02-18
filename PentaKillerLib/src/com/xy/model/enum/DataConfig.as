package com.xy.model.enum {

/**
 * 数据内置配置
 * @author xy
 *
 */
public class DataConfig {
	public static const LOADING_SHOW_TIME : int = 1000;

	/**
	 * 缩放比例
	 */
	public static const SCALE : int = 2;

	/**
	 * 屏幕大小 宽
	 */
	public static var WIDTH : int = 960;

	/**
	 * 屏幕大小 高
	 */
	public static var HEIGHT : int = 640;

	/**
	 * 屏幕大小 宽
	 */
	public static var HALF_WIDTH : int = WIDTH >> 1;

	/**
	 * 屏幕大小 高
	 */
	public static var HALF_HEIGHT : int = HEIGHT >> 1;

	/**
	 * 屏幕大小 高
	 */
	public static var VIEW_HEIGHT : int = HEIGHT * 3 / 5;

	/**
	 * 地图快的大小
	 */
	public static var TILE_SIZE : int = 128;

	/**
	 * 普通攻击连击的时间限制
	 * 单位：MS
	 */
	public static var NORMAL_ATTACK_BATTER_LIMIT : int = 500;

	/**
	 * 伤害连击的时间限制
	 * 单位：MS
	 */
	public static var ATTACK_HIT_BATTER_LIMIT : int = 2000;

	/**
	 * 怪物隔巡逻检查时间间隔，
	 * 单位：ms
	 */
	public static var ROAM_INTERVAL : int = 1000;

	/**
	 * 动作光效的添加时机
	 */
	private static var _effectFrames : Array = [];

	/**
	 * 当前激活的障碍矩形
	 * [PkRectangle, PkRectangle, ...]
	 */
	public static var activeBaffles : Array = [];

	/**
	* 设置动作光效的添加时机
	* @param action
	* @param effectFrame
	*/
	public static function setEffectFrame(gdcode : int, action : String, effectFrame : int) : void {
		_effectFrames[gdcode + action] = effectFrame;
	}

	public static function getEffectFrame(gdcode : int, action : String) : int {
		if (_effectFrames[gdcode + action] == null) {
			return 0;
		}
		return _effectFrames[gdcode + action];
	}

	/**
	 * 是否是怪物
	 * @param gdcode
	 * @return
	 */
	public static function isMonster(gdcode : int) : Boolean {
		return 20000 <= gdcode && gdcode <= 29999;
	}
}
}
