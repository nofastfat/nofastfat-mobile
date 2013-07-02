package com.xy.model.history {
import com.xy.model.vo.BitmapDataVo;

public class AddHistory implements IHistory {

    private var _addFun : Function;
    private var _delFun : Function;
    private var _params : Array;

    public function AddHistory(addFun : Function, delFun : Function, vo : *, stageX : Number, stageY : Number, id : String) {
        _addFun = addFun;
        _delFun = delFun;
        _params = [vo, stageX, stageY, id, false];
    }

    public function redo() : void {
        _addFun.apply(null, _params);
    }

    public function undo() : void {
        _delFun.apply(null, [_params[3]]);
    }

    public function destroy() : void {
        _addFun = null;
        _delFun = null;
        _params = null;
    }
}
}
