package com.xy.model.history {

public class MulityDeleteHistory implements IHistory {
    private var _redoFun : Function;
    private var _undoFun : Function;
    private var _vos : Array

    public function MulityDeleteHistory(redoFun : Function, undoFun : Function, vos : Array) {
        _redoFun = redoFun;
        _undoFun = undoFun;
        _vos = vos;
    }

    public function redo() : void {
        _redoFun(_vos);
    }

    public function undo() : void {
		_undoFun(_vos);
    }

    public function destroy() : void {
        _redoFun = null;
        _undoFun = null;
        _vos = null;
    }
}
}
