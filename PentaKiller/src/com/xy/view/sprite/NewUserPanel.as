package com.xy.view.sprite {
import com.xy.model.enum.DataConfig;
import com.xy.util.EnterFrameCall;
import com.xy.view.event.NewUserPanelEvent;

import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import starling.core.Starling;
import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;

/**
 * 新用户
 * @author xy
 */
public class NewUserPanel extends AbsPanel {
	private var _yesBtn : Button;
	private var _noBtn : Button;
	private var _input : TextField;

	public function NewUserPanel() {
		super();

		_bg = new Sprite();
		_bg.addChild(Assets.makeUI("enterNameBg", 4));

		_yesBtn = Assets.makeBtnUI("yesBtn", 4);
		_noBtn = Assets.makeBtnUI("noBtn", 4);

		_input = new TextField();
		_input.type = TextFieldType.INPUT;
		_input.width = 370;
		_input.height = 40;
		_input.maxChars = 7;
		_input.defaultTextFormat = new TextFormat("Verdana", 25, 0xFFFFFF);

		_bg.addChild(_yesBtn);
		_bg.addChild(_noBtn);

		_yesBtn.x = 47 << 1;
		_yesBtn.y = 64 << 1;
		_noBtn.x = 151 << 1;
		_noBtn.y = 64 << 1;


		_restBgX = (DataConfig.WIDTH - _bg.width) / 2;
		_restBgY = (DataConfig.HEIGHT - _bg.height) / 2;

		_bg.x = _restBgX;
		addChild(_bg);

		_yesBtn.addEventListener(Event.TRIGGERED, __yesHandler);
		_noBtn.addEventListener(Event.TRIGGERED, __noHandler);
	}

	override public function showTo(parent : Sprite) : void {
		super.showTo(parent);

		_input.text = "";
		_input.x = 39 * 2 + _restBgX;
		_input.y = 32 * 2 + _restBgY;
		Starling.current.nativeStage.addChild(_input);
		EnterFrameCall.getStage().focus = _input;
	}

	override public function hide(call : Function = null) : void {
		Starling.current.nativeStage.removeChild(_input);
		super.hide(call);

	}

	private function __yesHandler(e : Event) : void {
		if (_input.text != "") {
			SoundManager.play("button");
			hide(function() : void {
				dispatchEventWith(NewUserPanelEvent.CREATE, false, _input.text);
			});
		}else{
			EnterFrameCall.getStage().focus = _input;
		}
	}

	private function __noHandler(e : Event) : void {
		SoundManager.play("button");
		hide(function() : void {
			dispatchEventWith(NewUserPanelEvent.CANCEL);
		});
	}
}
}
