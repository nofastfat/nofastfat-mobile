package {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class WebGameAutoScale extends Sprite {
		
		private var _hero : Shape;
		private var _topLeftUI : Sprite;
		private var _topRightUI : Sprite;
		private var _bottomLeftUI : Sprite;
		private var _bottomRightUI : Sprite;
		
		private var _txt : TextField;
		
		public function WebGameAutoScale() {
			stage.align = StageAlign.TOP_LEFT;//test
			stage.scaleMode = StageScaleMode.NO_SCALE;
			graphics.lineStyle(1, 0xFF0000);
			var stageWidth : int = ExternalInterface.call("getWebWidth");
			var stageHeight : int = ExternalInterface.call("getWebHeight");
			graphics.drawRect(0, 0, stageWidth-1, stageHeight-1);
			
			initUI();
			resizeUI(stageWidth, stageHeight);
			
			ExternalInterface.addCallback("resizeHandler", resizeHandler);
		}
		
		private function initUI() : void {
			_hero= new Shape();
			
			addChild(_hero);
			_hero.graphics.beginFill(0x151515);
			_hero.graphics.drawCircle(150, 150, 50);
			_hero.graphics.endFill();
			
			_txt = new TextField();
			addChild(_txt);
			_txt.width = 400;
			_txt.x = _txt.y = 300;
			
			_topLeftUI = new Sprite();
			_topLeftUI.graphics.beginFill(0x353545);
			_topLeftUI.graphics.drawRect(0, 0, 200, 80);
			var txt : TextField = new TextField();
			txt.defaultTextFormat = new TextFormat(null, 20, 0xFFFFFF);
			txt.text = "_topLeftUI";
			_topLeftUI.addChild(txt);
			txt.width = _topLeftUI.width;
			txt.height = 80;
			addChild(_topLeftUI);
			
			_topRightUI = new Sprite();
			_topRightUI.graphics.beginFill(0x353545);
			_topRightUI.graphics.drawRect(0, 0, 250, 150);
			txt = new TextField();
			txt.defaultTextFormat = new TextFormat(null, 20, 0xFFFFFF);
			txt.text = "_topRightUI";
			_topRightUI.addChild(txt);
			txt.width = _topRightUI.width;
			txt.height = 150;
			addChild(_topRightUI);
			
			_bottomLeftUI = new Sprite();
			_bottomLeftUI.graphics.beginFill(0x353545);
			_bottomLeftUI.graphics.drawRect(0, 0, 150, 50);
			txt = new TextField();
			txt.defaultTextFormat = new TextFormat(null, 20, 0xFFFFFF);
			txt.text = "_bottomLeftUI";
			_bottomLeftUI.addChild(txt);
			txt.width = _bottomLeftUI.width;
			txt.height = 50;
			addChild(_bottomLeftUI);
			
			_bottomRightUI = new Sprite();
			_bottomRightUI.graphics.beginFill(0x353545);
			_bottomRightUI.graphics.drawRect(0, 0, 200, 80);
			txt = new TextField();
			txt.defaultTextFormat = new TextFormat(null, 20, 0xFFFFFF);
			txt.text = "_bottomRightUI";
			_bottomRightUI.addChild(txt);
			txt.width = _bottomRightUI.width;
			txt.height = 80;
			addChild(_bottomRightUI);
		}
		
		private function resizeUI(stageWidth : int, stageHeight : int):void{
			_topRightUI.x = stageWidth - _topRightUI.width;
			
			_bottomLeftUI.y = stageHeight - _bottomLeftUI.height;
			
			_bottomRightUI.x =  stageWidth - _bottomRightUI.width;
			_bottomRightUI.y =   stageHeight - _bottomRightUI.height;
		}
		
		/**
		 * call by js 
		 * @param stageWidth
		 * @param stageHeight
		 */	
		public function resizeHandler(stageWidth : int, stageHeight : int):void{
			_txt.text = "__resizeHandler" + stageWidth + "," + stageHeight;
			
			graphics.clear();
			graphics.lineStyle(1, 0xFF0000);
			graphics.drawRect(0, 0, stageWidth-1, stageHeight-1);
			resizeUI(stageWidth, stageHeight);
		}
	}
}
