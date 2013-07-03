package com.xy.view.ui.componet {
import com.xy.util.STool;

import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

public class GroupResize extends Sprite {
    public function GroupResize() {
        super();
    }
	
	public function resize(w : Number, h : Number):void{
		graphics.clear();
		
		graphics.lineStyle(2, 0xE3A96C);
		graphics.drawRect(-2, -2, w + 4, h + 4);
		graphics.endFill();
	}
	
	public function showTo(parent : DisplayObjectContainer, childs : Array):void{
		parent.addChild(this);
		
		var rsRect : Rectangle = new Rectangle();
		for each(var diy : DiyBase in childs){
			rsRect = rsRect.union(diy.getBounds(parent));
		}
		this.x = rsRect.x;
		this.y = rsRect.y;
		resize(rsRect.width, rsRect.height);
	}
	
	public function hide():void{
		STool.remove(this);
	}
}
}
