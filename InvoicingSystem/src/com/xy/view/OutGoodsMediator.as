package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.view.ui.OutGoodUI;

/**
 * 出货 
 * @author xy
 */
public class OutGoodsMediator extends AbsMediator {
	public static const NAME : String = "OutGoodsMediator";
	
	public static const SHOW : String = NAME + "SHOW";
	
	private var _panel : OutGoodUI;
	
	public function OutGoodsMediator(root : InvoicingSystem) {
		super(NAME, root);
	}
	
	override public function makeNoticeMap() : Map {
		var map : Map = new Map();
		map.put(SHOW, show);
		return map;
	}
	
	private function show() : void {
		if(_panel == null){
			_panel = new OutGoodUI();
		}
		ui.setContent(_panel);
		
	}
	
	public function get ui() : InvoicingSystem {
		return viewComponent as InvoicingSystem;
	}
}
}
