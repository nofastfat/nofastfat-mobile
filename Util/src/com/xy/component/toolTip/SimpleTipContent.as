package com.xy.component.toolTip {
import com.xy.component.toolTip.interfaces.ITipViewContent;
import com.xy.util.STool;

import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;

/**
 * 最简单的文字TIP
 * @author xy
 */
public class SimpleTipContent extends Sprite implements ITipViewContent {
	private static var GF : Array = [new GlowFilter(0x0, 1, 3, 3, 5)];
	private var _tipText : TextField;
	private var _tipBg : Shape;

	public function SimpleTipContent() {
		super();
		_tipText = createText();
		_tipBg = createBG();
		addChild(_tipBg);
		addChild(_tipText);
	}

	public function setData(data : *) : void {
		_tipText.htmlText = data;

		_tipBg.width = _tipText.textWidth + 20;
		_tipBg.height = _tipText.textHeight + 20;
	}

	public function destroy() : void {
	}

	private function createText() : TextField {
		var textField : TextField = new TextField();
		textField.width = 220;
		textField.height = 400;
		textField.multiline = true;
		textField.wordWrap = true;
		var tfm : TextFormat = new TextFormat("宋体", 12, 0xFFFFFF);
		tfm.leading = 3;
		textField.defaultTextFormat = tfm;
		textField.x = 7;
		textField.y = 4;
		textField.filters = GF;
		return textField;
	}

	private function createBG() : Shape {
		var bgShape : Shape = new Shape();
		bgShape.graphics.lineStyle(1, 0x000000, 0.6);
		bgShape.graphics.beginFill(0x0, 0.5);
		bgShape.graphics.drawRoundRect(0, 0, 40, 40, 6, 6);
		var grid : Rectangle = new Rectangle(10, 10, 20, 20);
		bgShape.scale9Grid = grid;
		bgShape.x = bgShape.y = 0.5;
		bgShape.filters = [new DropShadowFilter(4, 45, 0x0, 0.9)];
		return bgShape;
	}

	override public function get width() : Number {
		return _tipBg.width;
	}

	override public function get height() : Number {
		return _tipBg.height;
	}
}
}
