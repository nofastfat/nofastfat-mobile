package com.xy.view.ui.componet {
import com.xy.component.buttons.ToggleButton;
import com.xy.component.buttons.event.ToggleButtonEvent;
import com.xy.component.toolTip.ToolTip;
import com.xy.component.toolTip.enum.ToolTipMode;
import com.xy.model.vo.BitmapDataVo;
import com.xy.ui.ImageThumbUI;
import com.xy.util.SMouse;
import com.xy.util.STool;
import com.xy.view.ui.events.SImageThumbUIEvent;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.utils.setTimeout;

public class SImageThumbUI extends ImageThumbUI {
    private var _container : Sprite;

    private var _toggleBtn : ToggleButton;

    private var _w : int = 100;
    private var _h : int = 100;

    public var vo : BitmapDataVo;

    private var _type : int;

    public function SImageThumbUI(w : int = 100, h : int = 100, type : int = 0) {
        super();
        _type = type;
        _container = new Sprite();
        _toggleBtn = new ToggleButton(selectMc);

        addChildAt(_container, 1);
        setSize(w, h);

        setChildIndex(selectMc, numChildren - 1);

        if (type == 0) {
            selectMc.hitArea = this;
            closeBtn.visible = false;
            bg2.visible = false;
        }

        if (type == 1) {
            bg.visible = false;
            selectMc.visible = false;
            sizeTf.visible = false;
            bg2.visible = false;
            bg2.x = bg2.y = -1;
            closeBtn.visible = false;
            setChildIndex(bg2, 0);
            addEventListener(MouseEvent.ROLL_OVER, __overHandler);
            addEventListener(MouseEvent.ROLL_OUT, __outHandler);
        }

        _toggleBtn.addEventListener(ToggleButtonEvent.STATE_CHANGE, __changeHandler);
        closeBtn.addEventListener(MouseEvent.CLICK, __closeHandler);
		
		addEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
    }

    public function setSize(w : int, h : int) : void {
        _w = w;
        _h = h;

        bg.width = _w;
        bg.height = _h;
        selectMc.y = _h - selectMc.height;
        sizeTf.x = _w - sizeTf.width;
        sizeTf.y = _h - sizeTf.height;

        bg2.width = _w + 3;
        bg2.height = _h + 3;
        closeBtn.x = _w - closeBtn.width - 3;
    }

    public function setData(vo : BitmapDataVo) : void {
        this.vo = vo;
        STool.clear(_container);
        var bmp : Bitmap = new Bitmap(vo.bmd);
        _container.addChild(bmp);

        var scaleX : Number = _w / bmp.width;
        var scaleY : Number = _h / bmp.height;
        var scale : Number;

        if (scaleX < 1 || scaleY < 1 || (scaleX > 1 && scaleY > 1)) {
            scale = Math.min(scaleX, scaleY);
        } else {
            scale = Math.max(scaleX, scaleY);
        }

        bmp.scaleX = bmp.scaleY = scale;
        bmp.x = (_w - bmp.width) / 2;
        bmp.y = (_h - bmp.height) / 2;

        _toggleBtn.selected = vo.show;
        sizeTf.text = int(vo.bmd.width) + "×" + int(vo.bmd.height);

        ToolTip.setTip(this, ImageTip.getInstance(), vo.bmd, ToolTipMode.RIGHT_BOTTOM_CENTER);
    }

    override public function get width() : Number {
        return _w;
    }

    override public function get height() : Number {
        return _h;
    }

    private function __changeHandler(e : ToggleButtonEvent) : void {
		vo.show = _toggleBtn.selected;
        dispatchEvent(new SImageThumbUIEvent(SImageThumbUIEvent.STATUS_CHANGE, _toggleBtn.selected));
    }

    private function __closeHandler(e : MouseEvent) : void {
        dispatchEvent(new SImageThumbUIEvent(SImageThumbUIEvent.STATUS_CHANGE, false));
    }
	
	private function __downHandler(e:MouseEvent):void{
		SMouse.getInstance().setMouseBmd(vo, e.localX, e.localY);
	}

    private function __overHandler(e : MouseEvent) : void {
        closeBtn.visible = bg2.visible = true;
    }

    private function __outHandler(e : MouseEvent) : void {
        closeBtn.visible = bg2.visible = false;
    }


}
}