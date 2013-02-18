package com.xy.view.component {
import flash.geom.Rectangle;

import starling.display.Image;
import starling.textures.Texture;

/**
 * 裁切式缩放的image
 * @author xy
 */
public class ScaleImage extends Image {
	private var _tmpTexture : Texture;
	private var _tmpRect : Rectangle;
	private var _tmpWidth : int;
	private var _tmpHeight : int;

	public function ScaleImage(texture : Texture) {
		super(texture);
		_tmpTexture = texture;
		_tmpWidth = _tmpTexture.width;
		_tmpHeight = _tmpTexture.height;
		_tmpRect = new Rectangle(0, 0, _tmpWidth, _tmpHeight);
	}

	/**
	 * 横向缩放
	 * @param percent
	 */
	public function setWidthPercent(percent : Number) : void {
		if (percent < 0) {
			percent = 0;
		}

		if (percent > 1) {
			percent = 1;
		}
		_tmpRect.width = percent * _tmpWidth;
		var subTexture : Texture = Texture.fromTexture(_tmpTexture, _tmpRect);
		texture = subTexture;
		readjustSize();
	}

	/**
	 * 纵向缩放
	 * @param percent
	 */
	public function setHeightPercent(percent : Number) : void {
		if (percent < 0) {
			percent = 0;
		}

		if (percent > 1) {
			percent = 1;
		}
		_tmpRect.height = percent * _tmpHeight;
		var subTexture : Texture = Texture.fromTexture(_tmpTexture, _tmpRect);
		texture = subTexture;
		readjustSize();
	}

	override public function dispose() : void {
		_tmpTexture = null;
		_tmpRect = null;
		super.dispose();
	}
}
}
