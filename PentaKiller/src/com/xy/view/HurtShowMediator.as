package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.util.Map;
import com.xy.util.factories.TextFieldFactory;
import com.xy.util.factories.TweenFactory;
import com.xy.view.sprite.UILayer;

import starling.animation.Tween;
import starling.core.Starling;
import starling.text.TextField;

/**
 * 伤害显示TIP
 * @author xy
 */
public class HurtShowMediator extends AbsMediator {
	public static const NAME : String = "HurtShowMediator";

	/**
	 * 显示一个伤害数值
	 * 参数:[hurt : int, showX : int, showY : int]
	 */
	public static const SHOW_HURT : String = NAME + "SHOW_HURT";

	public function HurtShowMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}

	override public function makeNoticeMap() : Map {
		var map : Map = new Map();
		map.put(SHOW_HURT, showHurt);

		return map;
	}

	/**
	 * 显示掉血动画
	 * @param hurt
	 * @param showX
	 * @param showY
	 */
	private function showHurt(hurt : int, showX : int, showY : int) : void {
		showX += dataProxy.layerOffsetX;
		showY += dataProxy.layerOffsetY;
		var tf : TextField = TextFieldFactory.make();
		var tween : Tween = TweenFactory.make(tf, 0.8);
		ui.addChild(tf);
		tf.text = hurt +"";
		tf.width = 100;
		tf.height = 50;
		tf.fontSize = 36;
		tf.fontName = "ARKai";
		tf.color = 0xFFFFFF;
		tf.x = showX;
		tf.y = showY;
		tween.moveTo(showX, showY - 48);
		tween.onComplete = function() : void {
			tf.removeFromParent();
			TextFieldFactory.collectToPool(tf);
			TweenFactory.collectToPool(tween);
		}
		Starling.juggler.add(tween);
	}

	public function get ui() : UILayer {
		return viewComponent as UILayer;
	}
}
}
