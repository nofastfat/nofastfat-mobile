package com.xy.util.factories {

import starling.core.Starling;
import starling.display.MovieClip;

/**
 * 光效工厂
 * @author xy
 */
public class MovieClipFactory {
	private static var _pools : Array = [];

	/**
	 * 创建一个光效
	 * @param gdcode
	 * @param action
	 * @param fps
	 * @return
	 */
	public static function make(preKey : String, gdcode : int, action : String, fps : int = 12) : MovieClip {
		/*在总池中找指定KEY的池*/
		var poolKey : String = preKey + "_" + gdcode + "_" + action;

		var pool : Array;
		if (_pools[poolKey] == null) {
			pool = [];
			_pools[poolKey] = pool;
		} else {
			pool = _pools[poolKey];
		}

		/*在池里面找，是否有闲置的对象，如果有，直接使用*/
		for each (var vo : PoolVo in pool) {
			if (!vo.isUsing) {
				var content : MovieClip = vo.conetnt;
				vo.isUsing = true;
				content.currentFrame = 0;
				return content;
			}
		}

		var mc : MovieClip = Assets.makeMc(preKey, gdcode, action, fps);
		vo = new PoolVo(mc);
		pool.push(vo);
		vo.isUsing = true;
		return mc;
	}

	/**
	 * 回收至对象池
	 * @param mc
	 */
	public static function collectToPool(mc : MovieClip) : void {
		mc.stop();
		mc.removeFromParent();
		mc.removeEventListeners();
		Starling.juggler.remove(mc);
		for each (var pool : Array in _pools) {
			for each (var vo : PoolVo in pool) {
				if (vo.conetnt == mc) {
					vo.isUsing = false;
				}
			}
		}
	}
}
}
