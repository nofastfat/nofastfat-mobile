package com.xy.model.history {
import com.adobe.serialization.json.JSON;
import com.xy.model.vo.EditVo;
import com.xy.view.RightContainerMediator;

import org.puremvc.as3.patterns.facade.Facade;

public class ModifyHistory implements IHistory {
	private var _prevVo : EditVo;
	private var _doneVo : EditVo;
	
    public function ModifyHistory(prevVo : EditVo, doneVo : EditVo) {
    	_prevVo = prevVo;
    	_doneVo = doneVo;
//		
//		trace(JSON.encode(_prevVo));
//		trace(JSON.encode(_doneVo));
    }

    public function redo() : void {
    	mediator.getDiyBaseById(_prevVo.id).setByEditVo(_doneVo);
		mediator.updateDiyBar();
    }

    public function undo() : void {
    	mediator.getDiyBaseById(_doneVo.id).setByEditVo(_prevVo);
		mediator.updateDiyBar();
    }

    public function destroy() : void {
    	_prevVo = null
    	_doneVo = null;
    }

	public function get mediator() : RightContainerMediator{
		return Facade.getInstance().retrieveMediator(RightContainerMediator.NAME) as RightContainerMediator;
	}
}
}
