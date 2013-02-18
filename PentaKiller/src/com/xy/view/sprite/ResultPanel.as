package com.xy.view.sprite {
import com.greensock.TweenMax;
import com.xy.model.enum.DataConfig;
import com.xy.model.vo.RewardVo;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.HAlign;
import starling.utils.VAlign;

/**
 * 结算面板
 * @author xy
 */
public class ResultPanel extends Sprite {
	private var _bg : Sprite;
	private var _restBgX : int;
	private var _restBgY : int;
	private var _txt : TextField;

	private var _levelTxt : TextField;
	private var _rewardTxt : TextField;

	private var _stars : Array = [];
	private var _rewords : Array = [];

	private var _isComplete : Boolean;

	public function ResultPanel() {
		super();
		_bg = new Sprite();
		_bg.addChild(Assets.makeUI("PanelBg", 2, true));
		_restBgX = (DataConfig.WIDTH - _bg.width) / 2;
		_restBgY = (DataConfig.HEIGHT - _bg.height) / 2;


		_txt = new TextField(_bg.width - 40, 40, "战斗结果", "Verdana", 22, 0xFFFFFF, true);
		_bg.addChild(_txt);
		_txt.x = 20;
		_txt.y = 20;
		_txt.vAlign = VAlign.TOP;
		_txt.hAlign = HAlign.CENTER;

		_levelTxt = new TextField(100, 40, "评级：", "Verdana", 20, 0xFFFFFF, true);
		_bg.addChild(_levelTxt);
		_levelTxt.x = 66;
		_levelTxt.y = 112;
		_levelTxt.vAlign = VAlign.TOP;
		_levelTxt.hAlign = HAlign.LEFT;

		_rewardTxt = new TextField(100, 40, "奖励：", "Verdana", 20, 0xFFFFFF, true);
		_bg.addChild(_rewardTxt);
		_rewardTxt.x = 66;
		_rewardTxt.y = 208;
		_rewardTxt.vAlign = VAlign.TOP;
		_rewardTxt.hAlign = HAlign.LEFT;

		addChild(_bg);
	}

	public function setComplete(value : Boolean) : void {
		_isComplete = value;
	}

	public function setStarLevel(lvl : int) : void {
		if (lvl < 0) {
			lvl = 0;
		}

		if (lvl > 3) {
			lvl = 3;
		}
		for each (var img : Image in _stars) {
			img.removeFromParent();
			img.dispose();
		}
		_stars = [];

		for (var i : int = 1; i <= lvl; i++) {
			var star : Image = Assets.makeUI("star1");
			_stars.push(star);
		}

		for (i = 1; i <= 3 - lvl; i++) {
			star = Assets.makeUI("star0");
			_stars.push(star);
		}
		for (i = 0; i < _stars.length; i++) {
			star = _stars[i];
			_bg.addChild(star);
			star.x = 150 + i * (star.width + 15);
			star.y = 90;
		}
	}

	public function setRewards(rewards : Array) : void {
		for each (var txt : TextField in _rewords) {
			txt.removeFromParent();
			txt.dispose();
		}
		_rewords = [];

		if (rewards == null || rewards.length == 0) {
			txt = new TextField(_bg.width, 40, "无奖励", "Verdana", 18, 0xCCFF00, true);
			txt.x = 150;
			txt.y = 260;
			txt.vAlign = VAlign.TOP;
			txt.hAlign = HAlign.LEFT;
			_bg.addChild(txt);
			_rewords.push(txt);
		} else {
			for (var i : int = 0; i < rewards.length; i++) {
				var vo : RewardVo = rewards[i];
				txt = new TextField(_bg.width, 40, vo.toString(), "Verdana", 18, 0xCCFF00, true);
				txt.x = 150;
				txt.y = 260 + i * (30 + 20);
				txt.vAlign = VAlign.TOP;
				txt.hAlign = HAlign.LEFT;
				_bg.addChild(txt);
				_rewords.push(txt);
			}
		}
	}

	public function showTo(parent : Sprite) : void {
		addChildAt(Assets.mask, 0);
		parent.addChild(this);

		_bg.x = _restBgX;
		_bg.y = _restBgY;
		_bg.alpha = 1;

		TweenMax.from(_bg, 0.3, {y: _restBgY + 100, alpha: 0.2});
	}

	/**
	 * 带动画的隐藏
	 */
	public function hide(call : Function = null) : void {
		SoundManager.stop("taskComplete");
		SoundManager.stop("taskFaild");
		TweenMax.to(_bg, 0.2, {y: _restBgY - 100, alpha: 0.2, onComplete: function() : void {
			removeFromParent();
			if (call != null) {
				call();
			}
		}});
	}
}
}
