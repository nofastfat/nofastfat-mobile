package com.xy.view.ui.componet {
import com.xy.ui.UserCtrlBar;
import com.xy.util.STool;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Point;

public class SUserCtrlBar extends UserCtrlBar {

    private var _systemImageBtns : Array;
    private var _fontImageBtns : Array;
    private var _parent : Sprite;

    public function SUserCtrlBar(parent : Sprite) {
        super();
        _parent = parent;
        _systemImageBtns = [
            effectBtn,
            lineBtn,
            colorBtn,
            fullBtn,
            alphaBtn,
            upLevelBtn,
            downLevelBtn,
            deleteBtn
            ];

        _fontImageBtns = [
			editTextBtn,
            fontFaceBtn,
            fontSizeBtn,
            colorBtn,
            boldMc,
            leftAlignMc,
            centerAlignMc,
            rightAlignMc,
            alphaBtn,
            upLevelBtn,
            downLevelBtn,
            deleteBtn
            ];
    }

    public function showByDiyBase(diy : DiyBase) : void {
        var p : Point = new Point(diy.x, diy.y);
        p = diy.parent.localToGlobal(p);
        p = _parent.globalToLocal(p);
        _parent.addChild(this);

        if (diy is DiySystemImage) {
            setAsSystemImageViewMode();
        } else if (diy is DiyFont) {
            setAsFontViewMode();
        }

        this.x = p.x;
        this.y = p.y + diy.height + 10;
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

    private function setVieMode(arr : Array) : void {
        var len : int = numChildren;
        for (var i : int = 0; i < len; i++) {
            var child : DisplayObject = getChildAt(i);
            if (child != bg) {
                if (arr.indexOf(child) == -1) {
                    child.visible = false;
                } else {
                    child.visible = true;
                }
            }
        }
		
		var startX : int = 10;
		for each( child in arr){
			child.x = startX;
			startX += child.width + 10;
		}
        bg.width = startX;
    }
}
}
