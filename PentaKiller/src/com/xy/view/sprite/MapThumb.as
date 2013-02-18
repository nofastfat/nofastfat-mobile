package com.xy.view.sprite {
import com.xy.model.vo.MapVo;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.HAlign;
import starling.utils.VAlign;

/**
 * 地图缩略图
 * @author xy
 */
public class MapThumb extends Sprite {

	private var _img : Image;

	private var _nameTxt : TextField;

	private var _vo : MapVo;

	public function MapThumb(vo : MapVo) {
		super();

		_vo = vo;

		_img = Assets.makeUI("thumb" + vo.id, 2, true);
		_nameTxt = new TextField(_img.width, 30, vo.name, "Verdana", 18, 0xFFFFFF, true);
		_nameTxt.vAlign = VAlign.TOP;
		_nameTxt.hAlign = HAlign.CENTER;

		addChild(_img);
		addChild(_nameTxt);

		_nameTxt.y = _img.height + 5;
	}

	public function get vo() : MapVo {
		return _vo;
	}

	public function set vo(value : MapVo) : void {
		_vo = value;
	}
	
}
}
