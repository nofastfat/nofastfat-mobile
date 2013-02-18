package com.xy.view.sprite {
import com.greensock.TweenMax;
import com.xy.model.enum.DataConfig;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.HAlign;
import starling.utils.VAlign;

/**
 * 对话面板
 * @author xy
 */
public class TalkPanel extends Sprite {
	private var _mask : Quad;
	private var _bg : Image;
	private var _txt : TextField;

	private var _restBgY : int;
	private var _restTxtY : int;

	public function TalkPanel() {
		super();

		_bg = Assets.makeUI("talkPanelBg", 3);
		addChild(_bg);

		_bg.x = (DataConfig.WIDTH - _bg.width) >> 1;
		_restBgY = DataConfig.HEIGHT - _bg.height - 10;

		_txt = new TextField(_bg.width - 20, _bg.height - 20, "", "Verdana", 20, 0xFFFFFF);
		_txt.vAlign = VAlign.TOP;
		_txt.hAlign = HAlign.LEFT;
		addChild(_txt);
		_txt.x = _bg.x + 20;
		_restTxtY = _restBgY + 20;

	}

	/**
	 * 更改文字
	 * @param txt
	 */
	public function setTxt(txt : String) : void {
		_txt.text = txt;
	}

	/**
	 * 带动画的显示
	 * @param parent
	 */
	public function showTo(parent : Sprite) : void {
		addChildAt(Assets.mask, 0);
		parent.addChild(this);
		_bg.y = _restBgY;
		_txt.y = _restTxtY;

		TweenMax.from(_bg, 0.3, {y: _restBgY + 60});
		TweenMax.from(_txt, 0.3, {y: _restTxtY + 60});
		
		SoundManager.play("panel");
	}

	/**
	 * 带动画的隐藏
	 */
	public function hide() : void {
		SoundManager.play("panel");
		TweenMax.to(_bg, 0.2, {y: _restBgY + 150});
		TweenMax.to(_txt, 0.2, {y: _restTxtY + 150, onComplete: function() : void {
			removeFromParent();
		}});
	}

}
}
