package com.xy.view.sprite {
import com.xy.model.enum.DataConfig;
import com.xy.view.event.PortalEvent;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.HAlign;
import starling.utils.VAlign;

/**
 * 传送门面板
 * @author xy
 */
public class PortalPanel extends AbsPanel {
	private var _returnBtn : Button;
	private var _txt : TextField;
	private var _contents : Array = [];


	public function PortalPanel() {
		super();
		_bg = new Sprite();
		_bg.addChild(Assets.makeUI("PanelBg", 2, true));
		_restBgX = (DataConfig.WIDTH - _bg.width) / 2;
		_restBgY = (DataConfig.HEIGHT - _bg.height) / 2;

		_returnBtn = Assets.makeBtnUI("returnBtn");
		_bg.addChild(_returnBtn);
		_returnBtn.x = (_bg.width - _returnBtn.width) / 2;
		_returnBtn.y = _bg.height - _returnBtn.height - 30;

		_returnBtn.addEventListener(Event.TRIGGERED, __returnHandler);

		_txt = new TextField(_bg.width - 40, _bg.height - 40, "", "Verdana", 20, 0xFFFFFF, true);
		_bg.addChild(_txt);
		_txt.x = 20;
		_txt.y = 20;
		_txt.vAlign = VAlign.TOP;
		_txt.hAlign = HAlign.CENTER;
		_txt.touchable = false;

		addChild(_bg);
	}

	private function __returnHandler(e : Event) : void {
		hide();
	}

	public function setTxt(txt : String) : void {
		_txt.text = txt;
	}

	public function addContent(maps : Array) : void {
		for each (var img : MapThumb in _contents) {
			img.removeFromParent();
			img.dispose();
		}

		var bgWidth : int = _bg.width;
		var left : int = (bgWidth - 120 * 3 - 10 * 2) >> 1;
		var top : int = 60;
		_contents = maps;
		for (var i : int = 0; i < _contents.length; i++) {
			img = _contents[i];
			_bg.addChild(img);
			img.x = left + i * (120 + 10);
			img.y = top + int(i / 3) * (86 + 10);
			img.addEventListener(TouchEvent.TOUCH, __touchHandler);
		}
	}

	private function __touchHandler(e : TouchEvent) : void {
		var thumb : MapThumb = e.currentTarget as MapThumb;
		var touch : Touch = e.touches[0];

		if (touch.phase == TouchPhase.ENDED) {
			hide(function() : void {
				dispatchEventWith(PortalEvent.CHOOSE_MAP, false, thumb.vo);
			});
		}
	}

}
}
