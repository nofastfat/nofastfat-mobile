package com.xy.util.factories {

import starling.text.TextField;

/**
 * 文本框工厂
 * @author xy
 */
public class TextFieldFactory {
	private static var _pool : Array = new Array();

	/**
	 * 获取一个TextField 
	 * @return 
	 */	
	public static function make() : TextField {
		for each(var vo : PoolVo in _pool){
			if(!vo.isUsing){
				var tf : TextField = vo.conetnt as TextField;
				vo.isUsing = true;
				return tf;
			}
		}
		
		tf = new TextField(100, 30, "");
		vo = new PoolVo(tf);
		vo.isUsing = true;
		_pool.push(vo);
		
		return tf;
	}

	/**
	* 回收至对象池
	* @param mc
	*/
	public static function collectToPool(tf : TextField) : void {
		tf.removeFromParent();
		tf.removeEventListeners();
		for each (var vo : PoolVo in _pool) {
			if (vo.conetnt == tf) {
				vo.isUsing = false;
				tf.filter = null;
			}
		}
	}
}
}
