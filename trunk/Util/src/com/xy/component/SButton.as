package com.xy.component {
import flash.display.DisplayObject;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

/**
 * 按钮
 * @author xy
 */
public class SButton extends SimpleButton {
	public function SButton(txt : String) {
		var tf : TextField = new TextField();
		tf.defaultTextFormat = new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER);
		tf.text = txt;
		var w : int = tf.textWidth + 12;
		var h : int = tf.textHeight + 6;
		tf.width = w;
		tf.height = h;

		var upSp : Sprite = new Sprite();
		upSp.graphics.beginFill(0xbbbbbb);
		upSp.graphics.drawRoundRect(0, 0, w, h, 5, 5);
		upSp.graphics.endFill();
		upSp.addChild(tf);


		tf = new TextField();
		tf.defaultTextFormat = new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER);
		tf.text = txt;
		w = tf.textWidth + 12;
		h = tf.textHeight + 6;
		tf.width = w;
		tf.height = h;
		var overSp : Sprite = new Sprite();
		overSp.graphics.beginFill(0x888888);
		overSp.graphics.drawRoundRect(0, 0, w, h, 5, 5);
		overSp.graphics.endFill();
		overSp.addChild(tf);


		tf = new TextField();
		tf.defaultTextFormat = new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER);
		tf.text = txt;
		w = tf.textWidth + 12;
		h = tf.textHeight + 6;
		tf.width = w;
		tf.height = h;
		tf.y += 1;
		var downSp : Sprite = new Sprite();
		downSp.graphics.beginFill(0x555555);
		downSp.graphics.drawRoundRect(0, 0, w, h, 5, 5);
		downSp.graphics.endFill();
		downSp.addChild(tf);


		super(upSp, overSp, downSp, upSp);
	}
	
	public function setText(txt : String) : void {
		var tf : TextField = new TextField();
		tf.defaultTextFormat = new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER);
		tf.text = txt;
		var w : int = tf.textWidth + 12;
		var h : int = tf.textHeight + 6;
		tf.width = w;
		tf.height = h;
		
		var upSp : Sprite = new Sprite();
		upSp.graphics.beginFill(0xbbbbbb);
		upSp.graphics.drawRoundRect(0, 0, w, h, 5, 5);
		upSp.graphics.endFill();
		upSp.addChild(tf);
		
		
		tf = new TextField();
		tf.defaultTextFormat = new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER);
		tf.text = txt;
		w = tf.textWidth + 12;
		h = tf.textHeight + 6;
		tf.width = w;
		tf.height = h;
		var overSp : Sprite = new Sprite();
		overSp.graphics.beginFill(0x888888);
		overSp.graphics.drawRoundRect(0, 0, w, h, 5, 5);
		overSp.graphics.endFill();
		overSp.addChild(tf);
		
		
		tf = new TextField();
		tf.defaultTextFormat = new TextFormat(null, null, null, null, null, null, null, null, TextFormatAlign.CENTER);
		tf.text = txt;
		w = tf.textWidth + 12;
		h = tf.textHeight + 6;
		tf.width = w;
		tf.height = h;
		tf.y += 1;
		var downSp : Sprite = new Sprite();
		downSp.graphics.beginFill(0x555555);
		downSp.graphics.drawRoundRect(0, 0, w, h, 5, 5);
		downSp.graphics.endFill();
		downSp.addChild(tf);
		
		upState = upSp;
		overState = overSp;
		downState = downSp;
		hitTestState = upSp;
	}
}
}
