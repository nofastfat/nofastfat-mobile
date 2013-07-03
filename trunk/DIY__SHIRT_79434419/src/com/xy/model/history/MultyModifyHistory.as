package com.xy.model.history {

public class MultyModifyHistory implements IHistory {
    private var _doFun : Function;
    private var _prevVos : Array;
    private var _doneVos : Array;

    public function MultyModifyHistory(redoFun : Function, prevVos : Array, donwVos : Array) {
        _doFun = redoFun;
        _prevVos = prevVos;
		_doneVos = donwVos;
    }

    public function redo() : void {
        _doFun(_doneVos);
    }

    public function undo() : void {
        _doFun(_prevVos);
    }

    public function destroy() : void {
		_doFun = null;
		_prevVos = null;
		_doneVos = null;
    }
}
}
