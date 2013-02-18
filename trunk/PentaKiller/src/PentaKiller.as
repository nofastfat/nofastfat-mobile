package {
import com.xy.util.EnterFrameCall;
import com.xy.view.MenuMediator;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.getTimer;

import org.puremvc.as3.patterns.facade.Facade;

import starling.core.Starling;

[SWF(width = "960", height = "640", frameRate = "30", backgroundColor="#1f1f1f")]
public class PentaKiller extends Sprite {

	private static var _instance : PentaKiller;

	private var _starling : Starling;

	public static function getInstance() : PentaKiller {
		return _instance;
	}

	public function PentaKiller() {
		super();
		_instance = this;
		Loading.initParent(this);
		EnterFrameCall.initState(stage);

		Loading.getInstance().showLogo(start);

		Starling.handleLostContext = false;
		// 支持 autoOrient 
		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;

		_starling = new Starling(Game, stage, null, null, "auto", "baseline");
		_starling.antiAliasing = 1;
		_starling.showStats = true;

		_starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, function(e : Event) : void {
			_starling.start();
			//start();
		});
		
	}

	
	private var tf : TextField = new TextField();
	private var _intvl : uint;
	private function test():void{
		var t : int = getTimer();
		addChild(tf);
		tf.width = 900;
		tf.text ="0";
		tf.x = 10;
		tf.y = 100;
		EnterFrameCall.add(testAdd);
		tf.defaultTextFormat = new TextFormat("Verdana", 60, 0xFFFFFF);
		Assets.initTextureAsync("role", function():void{
			EnterFrameCall.del(testAdd);
			
			tf.text += ", Use time:" + (getTimer() - t) + "ms";
		});
	}
	
	private function testAdd():void{
		tf.text = (int(tf.text) + 1) + "";
	}
	
	private function start() : void {
		Facade.getInstance().sendNotification(MenuMediator.SHOW_MAIN_MENU);
	}

	public static function pause() : void {
		Starling.juggler.pause();
		EnterFrameCall.pause();
	}

	public static function run() : void {
		Starling.juggler.start();
		EnterFrameCall.run();
	}
}
}
