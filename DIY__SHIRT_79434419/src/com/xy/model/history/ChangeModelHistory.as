package com.xy.model.history {
	import com.xy.model.DiyDataProxy;
	
	import org.puremvc.as3.patterns.facade.Facade;

public class ChangeModelHistory implements IHistory {
    private var _oldId : String;
    private var _newId : String;

    public function ChangeModelHistory(oldModelId : String, newModelId : String) {
        _oldId = oldModelId;
        _newId = newModelId;
    }

    public function redo() : void {
		dataProxy.chooseModel(dataProxy.getModelById(_newId), false);
    }

    public function undo() : void {
		dataProxy.chooseModel(dataProxy.getModelById(_oldId), false);
    }

    public function destroy() : void {
		_oldId = null;
		_newId = null;
    }

    private function get dataProxy() : DiyDataProxy {
        return Facade.getInstance().retrieveProxy(DiyDataProxy.NAME) as DiyDataProxy;
    }
}
}
