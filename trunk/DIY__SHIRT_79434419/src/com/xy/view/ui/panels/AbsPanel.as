package com.xy.view.ui.panels {
import com.xy.ui.PanelUI;
import com.xy.util.EnterFrameCall;
import com.xy.util.STool;
import com.xy.view.ui.events.AbsPanelEvent;

import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

/**
 * 公用面板
 * @author xy
 */
public class AbsPanel extends PanelUI {
    private var _container : Sprite;
    protected var _mask : Shape;

    private var _offsetW : int;
    private var _offsetH : int;

    public function AbsPanel(w : int = 300, h : int = 200, title : String = "") {
        super();

        titleTf.mouseEnabled = false;

        _offsetW = bg.width - bg.scale9Grid.right + bg.scale9Grid.left;
        _offsetH = bg.height - bg.scale9Grid.bottom + +bg.scale9Grid.top;

        _container = new Sprite();
        _container.x = bg.scale9Grid.left + 10;
        _container.y = bg.scale9Grid.top + 10;
        addChild(_container);

        _mask = new Shape();
        _mask.graphics.beginFill(0xFFFFFF);
        _mask.graphics.drawRect(0, 0, 1, 1);
        _mask.graphics.endFill();
        addChild(_mask);
        _container.mask = _mask;
        _mask.x = _container.x;
        _mask.y = _container.y;

        this.width = w;
        this.height = h;
        setTitle(title);

        closeBtn.addEventListener(MouseEvent.CLICK, __closeHandler);
        bg.addEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_UP, __upHandler);
    }

    public function resize() : void {
        this.x = (EnterFrameCall.getStage().stageWidth - this.width) / 2;
        this.y = (EnterFrameCall.getStage().stageHeight - this.height) / 2;
    }

    public function showTo(parent : DisplayObjectContainer) : void {
        parent.addChild(this);
        resize();
    }

    public function close() : void {
        STool.remove(this);
    }

    protected function __closeHandler(e : MouseEvent) : void {
        close();
        dispatchEvent(new AbsPanelEvent(AbsPanelEvent.CLOSE));
    }

    private function __downHandler(e : MouseEvent) : void {
        if (e.localY <= 30) {
            this.startDrag();
        }
    }

    private function __upHandler(e : MouseEvent) : void {
        this.stopDrag();
    }

    public function get container() : Sprite {
        return _container;
    }

    public function setTitle(title : String) : void {
        titleTf.text = title;
    }

    override public function set width(iw : Number) : void {
        bg.width = iw;
        closeBtn.x = iw - 15 - closeBtn.width;
        _mask.width = iw - _offsetW - 20;
    }

    override public function set height(ih : Number) : void {
        bg.height = ih;
        _mask.height = ih - _offsetH - 20;
    }

    override public function get width() : Number {
        return bg.width;
    }

    override public function get height() : Number {
        return bg.height;
    }

}
}
