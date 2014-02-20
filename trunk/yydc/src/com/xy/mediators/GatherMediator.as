package com.xy.mediators {
import com.xy.model.Global;
import com.xy.ui.views.Gather;
import com.xy.util.STool;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;

import spark.components.Group;


/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-18 下午6:15:29
 **/
public class GatherMediator extends Mediator {
	public static const NAME : String = "GatherMediator";
	
	public static const SHOW : String = NAME + "SHOW";
	
	private var _gatherUIs : Array = [];
	
	public function GatherMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}
	
	override public function listNotificationInterests():Array{
		return [
			SHOW
		];
	}
	
	override public function handleNotification(notification:INotification):void{
		switch(notification.getName()){
			case SHOW:
				show();
				break;
		}
	}
	
	private function show():void{
		var len : int = STool.random(1,4);
		container.removeAllElements();
		
		for(var i : int = 0 ;i < len; i++){
			var ga : Gather;
			
			if(i < _gatherUIs.length){
				ga = _gatherUIs[i];
			}else{
				ga = new Gather();
				ga.initialize();
				_gatherUIs.push(ga);
			}
			ga.setData(null);
			container.addElement(ga);
		}
		
		if(ga != null){
			ga.callLater(function():void{
				var offsetY : int = 10;
				for(var i : int = 0 ;i < len; i++){
					var ga : Gather;
					
					ga = _gatherUIs[i];
					ga.y = offsetY;
					ga.x = 10;
					offsetY += ga.height + 10;
				}
				Global.root.callLayer(offsetY);
			});
		}
	}
	
	public function get container():Group{
		return viewComponent as Group;
	}
}
}
