package com.xy.util.factories {
import starling.animation.Tween;
import starling.core.Starling;

public class TweenFactory {
	private static var _pool : Array = new Array();

	/**
	 * 获取一个TextField
	 * @return
	 */
	public static function make(obj : *, time : Number) : Tween {
		for each (var vo : PoolVo in _pool) {
			if (!vo.isUsing) {
				var t : Tween = vo.conetnt as Tween;
				t.reset(obj, time);
				vo.isUsing = true;
				return t;
			}
		}

		t = new Tween(obj, time);
		vo = new PoolVo(t);
		vo.isUsing = true;
		_pool.push(vo);

		return t;
	}

	/**
	 * 回收至对象池
	 * @param mc
	 */
	public static function collectToPool(t : Tween) : void {
		Starling.juggler.remove(t);
		t.removeEventListeners();
		for each (var vo : PoolVo in _pool) {
			if (vo.conetnt == t) {
				vo.isUsing = false;
			}
		}
	}
}
}
