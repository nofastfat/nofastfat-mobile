package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.view.ui.InGoodsUI;

/**
 * 进货 
 * @author xy
 */
public class InGoodsMediator extends AbsMediator {
	public static const NAME : String = "InGoodsMediator";
	
	public static const SHOW : String = NAME + "SHOW";
	
	private var _panel : InGoodsUI;
	
	public function InGoodsMediator(root : InvoicingSystem) {
		super(NAME, root);
	}
	
	override public function makeNoticeMap() : Map {
		var map : Map = new Map();
		map.put(SHOW, show);
		return map;
	}
	
	private function show() : void {
		if(_panel == null){
			_panel = new InGoodsUI();
		}
		ui.setContent(_panel);
		
	}
	
	public function get ui() : InvoicingSystem {
		return viewComponent as InvoicingSystem;
	}
}
}
