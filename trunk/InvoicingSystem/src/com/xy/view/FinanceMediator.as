package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.view.ui.FinanceUI;

/**
 * 库存 
 * @author xy
 */
public class FinanceMediator extends AbsMediator {
	public static const NAME : String = "FinanceMediator";
	
	public static const SHOW : String = NAME + "SHOW";
	
	private var _panel : FinanceUI;
	
	public function FinanceMediator(root : InvoicingSystem) {
		super(NAME, root);
	}
	
	override public function makeNoticeMap() : Map {
		var map : Map = new Map();
		map.put(SHOW, show);
		return map;
	}
	
	private function show() : void {
		if(_panel == null){
			_panel = new FinanceUI();
		}
		ui.setContent(_panel);
		
	}
	
	public function get ui() : InvoicingSystem {
		return viewComponent as InvoicingSystem;
	}
}
}
