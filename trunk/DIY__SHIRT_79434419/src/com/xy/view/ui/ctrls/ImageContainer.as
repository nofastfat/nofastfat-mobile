package com.xy.view.ui.ctrls {
	import com.xy.ui.BlackButton;
	import com.xy.util.Tools;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class ImageContainer extends AbsContainer {
		private var _addBtn : BlackButton;
		private var _sizeUI : SImageSizeUI;
		
		public function ImageContainer() {
			super();
			_addBtn = Tools.makeBlackButton("添加图片");
			_sizeUI = new SImageSizeUI();
			
			addChild(_addBtn);
			addChild(_sizeUI);
		}
		
		override public function resize(height:int) : void {
			super.resize(height);
			if (_addBtn != null) {
				_addBtn.x = (200-_addBtn.width)/2;
				_addBtn.y = 10;
			}
			
			if (_sizeUI != null) {
				_sizeUI.x = 200-_sizeUI.width - 10;
				_sizeUI.y = height - _sizeUI.height - 10;
			}
			
			
		}
	}
}
