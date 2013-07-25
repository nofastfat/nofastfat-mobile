package {
import com.xy.LandlordsFacade;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import net.hires.debug.Stats;

/**
 * 斗地主入口 
 * @author xy
 */
public class Main extends Sprite {
	
	/**
	 * core 
	 */	
	private var _facade : LandlordsFacade;
	
	public function Main() {
		super();

		// 支持 autoOrients
		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		
		addEventListener(Event.ADDED_TO_STAGE, __addedToStageHandler);
	}
	
	private function __addedToStageHandler(e : Event):void{
		removeEventListener(Event.ADDED_TO_STAGE, __addedToStageHandler);
		
		_facade = new LandlordsFacade();
		
		_facade.startUp(this);
		
		//test
		stage.addChild(new Stats());
	}
}
}
