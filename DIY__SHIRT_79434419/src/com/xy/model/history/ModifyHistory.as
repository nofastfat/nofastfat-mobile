package com.xy.model.history {
import com.xy.model.vo.EditVo;
import com.xy.view.RightContainerMediator;

import org.puremvc.as3.patterns.facade.Facade;

public class ModifyHistory implements IHistory {
	private var _prevVo : EditVo;
	private var _doneVo : EditVo;
	
    public function ModifyHistory(prevVo : EditVo, doneVo : EditVo) {
    	_prevVo = prevVo;
    	_doneVo = doneVo;
    }

    public function redo() : void {
    	mediator.getDiyBaseById(_prevVo.id).setByEditVo(_prevVo);
    }

    public function undo() : void {
    	mediator.getDiyBaseById(_doneVo.id).setByEditVo(_doneVo);
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
