package com.xy.model.history {
import com.xy.model.vo.EditVo;

public class DeleteHistory implements IHistory {
    private var _redoFun : Function;
    private var _undoFun1 : Function;
    private var _editVo : EditVo;

    public function DeleteHistory(redoFun : Function, undoFun1 : Function, editVo : EditVo) {
        _redoFun = redoFun;
        _undoFun1 = undoFun1;
        _editVo = editVo;
    }

    public function redo() : void {
		_redoFun(_editVo.id)
    }

    public function undo() : void {
		_undoFun1(_editVo);
    }

    public function destroy() : void {
        _redoFun = null;
        _undoFun1 = null;
        _editVo = null;
    }
}
}
