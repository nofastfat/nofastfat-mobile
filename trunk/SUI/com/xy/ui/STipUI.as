package com.xy.ui {
import com.greensock.TweenLite;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.geom.Point;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;


/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-9-27 下午2:47:53
 **/
public class STipUI extends Sprite{
	protected static var _instance : STipUI;
	protected var _pt : Point = new Point();
	protected var _timeout : uint;

	public static function getInstance() : STipUI {
		if (_instance == null) {
			_instance = new STipUI();
		}

		return _instance;
	}

	public function STipUI() {
		super();
		tf.mouseEnabled=false;
	}

	/**
	 * 显示
	 */
	public function show(source : DisplayObject, content : String) : void {
		TweenLite.killTweensOf(this);
		clearTimeout(_timeout);
		tf.htmlText = content;
		tf.width = tf.textWidth + 20;
		bg.width = tf.width + 20;
		_pt.x = source.x;
		_pt.y = source.y - this.height;
		_pt = source.parent.localToGlobal(_pt);
		this.x = _pt.x;
		this.y = _pt.y;
		_timeout = setTimeout(_hide, 3000);
		SUIRoot.stage.addChild(this);
		this.alpha = 1;
		TweenLite.from(this, 0.4, {alpha: 0.1}); 
	}

	public function hide() : void {
		clearTimeout(_timeout);
		TweenLite.killTweensOf(this);
	}
	
	private function _hide():void{
		clearTimeout(_timeout);
		TweenLite.killTweensOf(this);
		TweenLite.to(this, 0.4, {alpha: 0.1, onComplete: remove});
	}
	
	private function remove():void{
		if(SUIRoot.stage.contains(this)){
			SUIRoot.stage.removeChild(this);
		}
	}
}
}
