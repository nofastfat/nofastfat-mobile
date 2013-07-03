package com.xy.model.history {

public class ChildIndexHistory implements IHistory {
    private var _redoFun : Function;
    private var _undoFun : Function;
    private var _childId : String;

    public function ChildIndexHistory(redoFun : Function, undoFun : Function, childId : String) {
        _redoFun = redoFun;
        _undoFun = undoFun;
        _childId = childId;
    }

    public function redo() : void {
		_redoFun(_childId);
    }

    public function undo() : void {
		_undoFun(_childId);
    }

    public function destroy() : void {
		_redoFun = null;
		_undoFun = null;
		_childId = null;
    }
}
}
