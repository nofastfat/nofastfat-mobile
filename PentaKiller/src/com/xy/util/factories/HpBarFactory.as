package com.xy.util.factories {
import com.xy.view.sprite.HpBar;

public class HpBarFactory {
	private static var _pool : Array = new Array();

	/**
	 * 获取一个HpBar
	 * @return
	 */
	public static function make() : HpBar {
		for each (var vo : PoolVo in _pool) {
			if (!vo.isUsing) {
				var hpBar : HpBar = vo.conetnt as HpBar;
				vo.isUsing = true;
				hpBar.scaleX = 1;
				return hpBar;
			}
		}

		hpBar = new HpBar();
		vo = new PoolVo(hpBar);
		vo.isUsing = true;
		_pool.push(vo);

		return hpBar;
	}

	/**
	 * 回收至对象池
	 * @param mc
	 */
	public static function collectToPool(hpBar : HpBar) : void {
		hpBar.removeFromParent();
		for each (var vo : PoolVo in _pool) {
			if (vo.conetnt == hpBar) {
				vo.isUsing = false;
				hpBar.scaleX = 1;
			}
		}
	}
}
}
