package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.model.enum.DataConfig;
import com.xy.util.Map;
import com.xy.view.sprite.UILayer;

import flash.utils.getTimer;

import starling.animation.DelayedCall;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.text.TextField;

/**
 * 伤害连击
 * @author xy
 */
public class BatterMediator extends AbsMediator {
	public static const NAME : String = "BatterMediator";

	/**
	 * 玩家伤害命中
	 * 参数 击中的个数:int
	 */
	public static const HERO_ATTACK_HIT : String = NAME + "HERO_ATTACK_HIT";

	/**
	 * 取消的定时器
	 */
	private var _delayCall : DelayedCall;

	/**
	 * 连击次数
	 */
	private var _batterCount : int;

	/**
	 * 显示的文本框
	 */
	private var _tf : TextField;

	/**
	 * 动画
	 */
	private var _tween : Tween;

	private var _isBattering : Boolean = false;

	public function BatterMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}

	override public function onRegister() : void {
		_tf = new TextField(300, 100, "", "ARKai", 48, 0xFFFFFF);
		_tf.pivotX = 150;
		_tf.pivotY = 50;
		_tf.x = 100;
		_tf.y = 140;
		_tf.touchable = false;
		_delayCall = new DelayedCall(batterBreakOff, DataConfig.ATTACK_HIT_BATTER_LIMIT / 1000);

		_tween = new Tween(_tf, 0);
	}

	override public function makeNoticeMap() : Map {
		var map : Map = new Map();
		map.put(HERO_ATTACK_HIT, heroAttackHit);

		return map;
	}

	/**
	 * 伤害命中
	 */
	private function heroAttackHit(hitCount : int) : void {
		var now : Number = getTimer();
		/*连击连上*/
		if (_isBattering) {
			Starling.juggler.remove(_delayCall);
			_batterCount += hitCount;
			showBatter();
		} else {
			_batterCount = hitCount;
			showBatter();
		}
		_delayCall.reset(batterBreakOff, DataConfig.ATTACK_HIT_BATTER_LIMIT / 1000);
		Starling.juggler.add(_delayCall);
	}

	/**
	 * 显示连击数
	 */
	private function showBatter() : void {
		_isBattering = true;
		var colorAndScale : Array = calColorAndScale();
		_tf.text = _batterCount + " Hit";
		_tf.color = colorAndScale[0];
		ui.addChild(_tf);
		_tf.alpha = 1;
		_tween.reset(_tf, 0.1, Transitions.EASE_OUT_BACK);
		_tween.scaleTo(colorAndScale[1]);
		_tween.onComplete = function() : void {
			_tween.reset(_tf, 0.1);
			_tween.scaleTo(1);
			Starling.juggler.add(_tween);
		}
		Starling.juggler.add(_tween);
	}

	/**
	 * 计算颜色和缩放值
	 * @return
	 */
	private function calColorAndScale() : Array {
		if (_batterCount < 20) {
			return [0xFFFFFF, 1.5];
		} else if (_batterCount < 40) {
			return [0xFFFF00, 2];
		} else {
			return [0xFF0000, 2.5];
		}
	}

	/**
	 * 隐藏连击数
	 */
	private function hideBatter() : void {
		_tween.reset(_tf, 0.3, Transitions.EASE_OUT_BACK);
		_tween.fadeTo(0.1);
		_tween.onComplete = _tf.removeFromParent;
		Starling.juggler.add(_tween);
	}

	/**
	 * 连击中止
	 */
	private function batterBreakOff() : void {
		_isBattering = false;
		hideBatter();
		_batterCount = 0;
	}

	public function get ui() : UILayer {
		return viewComponent as UILayer;
	}
}
}
