package com.xy.view.ui.componet {
import com.xy.component.buttons.ToggleButton;
import com.xy.component.buttons.event.ToggleButtonEvent;
import com.xy.component.colorPicker.ColorPicker;
import com.xy.component.colorPicker.ColorPikerEvent;
import com.xy.component.colorPicker.enum.PreSwatches;
import com.xy.component.menu.Menu;
import com.xy.component.toolTip.ToolTip;
import com.xy.component.toolTip.enum.ToolTipMode;
import com.xy.model.DiyDataProxy;
import com.xy.model.enum.DiyImageType;
import com.xy.model.vo.EditVo;
import com.xy.ui.UserCtrlBar;
import com.xy.util.EnterFrameCall;
import com.xy.util.STool;
import com.xy.util.Tools;
import com.xy.view.ui.events.SSelectAlphaUIEvent;
import com.xy.view.ui.events.SUserCtrlBarEvent;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

import org.puremvc.as3.patterns.facade.Facade;

public class SUserCtrlBar extends UserCtrlBar {

    private var _systemImageBtns : Array;
    private var _fontImageBtns : Array;
    private var _parent : Sprite;
    private var _color : ColorPicker;

    private var _fullBtn : ToggleButton;
    private var _selectAlphaUI : SSelectAlphaUI;
    private var _diyImageType : int;

    public function SUserCtrlBar(parent : Sprite) {
        super();
        _parent = parent;
        _systemImageBtns = [
            //effectBtn,
            lineBtn,
            colorBtn,
            fullBtn,
            alphaBtn,
            upLevelBtn,
            downLevelBtn,
            deleteBtn
            ];

        ToolTip.setSimpleYellowTip(fullBtn, "最大图片/实际图片", ToolTipMode.RIGHT_BOTTOM_CENTER);
        ToolTip.setSimpleYellowTip(alphaBtn, "透明度", ToolTipMode.RIGHT_BOTTOM_CENTER);
        ToolTip.setSimpleYellowTip(upLevelBtn, "上移一层", ToolTipMode.RIGHT_BOTTOM_CENTER);
        ToolTip.setSimpleYellowTip(downLevelBtn, "下移一层", ToolTipMode.RIGHT_BOTTOM_CENTER);
        ToolTip.setSimpleYellowTip(deleteBtn, "删除", ToolTipMode.RIGHT_BOTTOM_CENTER);

        _fontImageBtns = [
            editTextBtn,
            fontFaceBtn,
            fontSizeBtn,
            colorBtn,
            boldMc,
            //leftAlignMc,
            //centerAlignMc,
            //rightAlignMc,
            alphaBtn,
            upLevelBtn,
            downLevelBtn,
            deleteBtn
            ];

        lineBtn.tf.mouseEnabled = false;
        lineBtn.tf.text = "无描边";
        lineBtn.buttonMode = true;
        _color = new ColorPicker(16, 8, new Point(11, 11), PreSwatches.PS_COLORS);
        _color.addEventListener(ColorPikerEvent.SELECT_COLOR, __selectColorHandler);
        _fullBtn = new ToggleButton(fullBtn);
        _selectAlphaUI = new SSelectAlphaUI();

        lineBtn.addEventListener(MouseEvent.CLICK, __showLineHandler);
        colorBtn.addEventListener(MouseEvent.CLICK, __showColorHandler);
        _fullBtn.addEventListener(ToggleButtonEvent.STATE_CHANGE, __fullStatusHandler);
        alphaBtn.addEventListener(MouseEvent.CLICK, __showAlphaHandler);
        _selectAlphaUI.addEventListener(SSelectAlphaUIEvent.ALPHA_CHANGE, __alphaChangeHandler);
        upLevelBtn.addEventListener(MouseEvent.CLICK, __upLevelHandler);
        downLevelBtn.addEventListener(MouseEvent.CLICK, __downLevelHandler);
        deleteBtn.addEventListener(MouseEvent.CLICK, __delHandler);

        EnterFrameCall.getStage().addEventListener(MouseEvent.CLICK, __stageClickHandler);
    }

    private function __showLineHandler(e : MouseEvent) : void {
        if (Menu.isShowed()) {
            Menu.hide();
            return;
        }

        e.stopImmediatePropagation();
        e.stopPropagation();
        var p : Point = new Point(lineBtn.x, lineBtn.y + lineBtn.height);
        p = localToGlobal(p);

        Menu.show(
            p,
            [
            Tools.makeListButton(0),
            Tools.makeListButton(1),
            Tools.makeListButton(2),
            Tools.makeListButton(3),
            Tools.makeListButton(4),
            Tools.makeListButton(5)
            ],
            function(name : String) : void {
                if (name == "0") {
                    lineBtn.tf.text = "无描边";
                } else {
                    lineBtn.tf.text = name + "像素描边";
                }
                dispatchEvent(new SUserCtrlBarEvent(SUserCtrlBarEvent.LINE_CHANGE, int(name)));

                _editVo.lineSickness = int(name);
                updateIcons();
            },
            [0, 0, 0, 0]
            );
    }

    private function __showColorHandler(e : MouseEvent) : void {
        if (_color.stage != null) {
            STool.remove(_color);
            return;
        }

        EnterFrameCall.getStage().addChild(_color);
        var p : Point = new Point(colorBtn.x, colorBtn.y + colorBtn.height);
        p = localToGlobal(p);
        _color.x = p.x;
        _color.y = p.y;
        switch (_diyImageType) {
            case DiyImageType.SYSTEM_IMAGE:
                _color.setDefaultColor(_editVo.lineColor);
                break;
            case DiyImageType.FONT:
                break;
        }
    }

    private function __selectColorHandler(e : ColorPikerEvent) : void {
        STool.remove(_color);
        switch (_diyImageType) {
            case DiyImageType.SYSTEM_IMAGE:
                dispatchEvent(new SUserCtrlBarEvent(SUserCtrlBarEvent.LINE_COLOR, e.color));
                break;
            case DiyImageType.FONT:
                dispatchEvent(new SUserCtrlBarEvent(SUserCtrlBarEvent.FONT_COLOR, e.color));
                break;
        }
    }

    private function __fullStatusHandler(e : ToggleButtonEvent) : void {
        dispatchEvent(new SUserCtrlBarEvent(SUserCtrlBarEvent.FULL_STATUS, _fullBtn.selected));
    }

    private function __showAlphaHandler(e : MouseEvent) : void {
        if (_selectAlphaUI.stage != null) {
            STool.remove(_selectAlphaUI);
            return;
        }

        e.stopImmediatePropagation();
        e.stopPropagation();
        EnterFrameCall.getStage().addChild(_selectAlphaUI);
        var p : Point = new Point(alphaBtn.x, alphaBtn.y + alphaBtn.height);
        p = localToGlobal(p);
        _selectAlphaUI.x = p.x;
        _selectAlphaUI.y = p.y;
        _selectAlphaUI.setAlpha(_editVo.alpha);
    }

    private function __alphaChangeHandler(e : SSelectAlphaUIEvent) : void {
        dispatchEvent(new SUserCtrlBarEvent(SUserCtrlBarEvent.ALPHA, e.alpha));
    }

    private function __upLevelHandler(e : MouseEvent) : void {
        dispatchEvent(new SUserCtrlBarEvent(SUserCtrlBarEvent.UP_LEVEL));
    }

    private function __downLevelHandler(e : MouseEvent) : void {
        dispatchEvent(new SUserCtrlBarEvent(SUserCtrlBarEvent.DOWN_LEVEL));
    }

    private function __delHandler(e : MouseEvent) : void {
        dispatchEvent(new SUserCtrlBarEvent(SUserCtrlBarEvent.DELETE));
    }

    private function __stageClickHandler(e : MouseEvent) : void {
        if (e.target != _selectAlphaUI && e.target != _selectAlphaUI.sliderBg && e.target != _selectAlphaUI.sliderBtn) {
            STool.remove(_selectAlphaUI);
        }

        if (e.target != colorBtn && e.target != _color) {
            STool.remove(_color);
        }
    }

    private var _editVo : EditVo;

    private function updateShowByEditVo() : void {
        if (_editVo.lineSickness == 0) {
            lineBtn.tf.text = "无描边";
        } else {
            lineBtn.tf.text = _editVo.lineSickness + "像素描边";
        }

        _fullBtn.selected = _editVo.isFull;
    }

    public function showByDiyBase(diy : DiyBase) : void {
        _editVo = diy.editVo;
        var p : Point = new Point(diy.x + diy.childX, diy.y + diy.childY);
        p = diy.parent.localToGlobal(p);
        p = _parent.globalToLocal(p);
        _parent.addChild(this);

        if (diy is DiySystemImage) {
            _diyImageType = DiyImageType.SYSTEM_IMAGE;

        } else if (diy is DiyFont) {
            _diyImageType = DiyImageType.FONT;
        }

        updateIcons();

        this.x = p.x;
        this.y = p.y + diy.height + 20;
        updateShowByEditVo();
    }

    public function hide() : void {
        STool.remove(this);
    }

    private function setAsSystemImageViewMode() : void {
        setVieMode(_systemImageBtns);
    }

    private function setAsFontViewMode() : void {
        setVieMode(_fontImageBtns);
    }

    public function updateIcons() : void {
        switch (_diyImageType) {
            case DiyImageType.SYSTEM_IMAGE:
                setAsSystemImageViewMode();
                ToolTip.setSimpleYellowTip(colorBtn, "描边颜色", ToolTipMode.RIGHT_BOTTOM_CENTER);
                break;
            case DiyImageType.FONT:
                setVieMode(_fontImageBtns);
                ToolTip.setSimpleYellowTip(colorBtn, "字体颜色", ToolTipMode.RIGHT_BOTTOM_CENTER);
                break;
        }
    }

    private function setVieMode(arr : Array) : void {
        var len : int = numChildren;
        var hideLineColor : Boolean = false;
        var hideFull : Boolean = false;

        for (var i : int = 0; i < len; i++) {
            var child : DisplayObject = getChildAt(i);
            if (child != bg) {
                if (arr.indexOf(child) == -1) {
                    child.visible = false;
                } else {
                    child.visible = true;

                    if (_diyImageType == DiyImageType.SYSTEM_IMAGE && _editVo.lineSickness == 0 && child == colorBtn) {
                        hideLineColor = true;
                        child.visible = false;
                    }
                    if (_diyImageType == DiyImageType.SYSTEM_IMAGE && _editVo.lineSickness == 0 && child == fullBtn) {
                        hideLineColor = true;
                        child.visible = false;
                    }
                }
            }
        }

        var startX : int = 10;
        for each (child in arr) {
            if (hideLineColor && child == colorBtn) {

            } else {
                child.x = startX;
                startX += child.width + 10;
            }
        }
        bg.width = startX;
    }

    private function get dataProxy() : DiyDataProxy {
        return Facade.getInstance().retrieveProxy(DiyDataProxy.NAME) as DiyDataProxy;
    }
}
}
