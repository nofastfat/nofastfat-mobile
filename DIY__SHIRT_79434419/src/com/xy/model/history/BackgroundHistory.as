package com.xy.model.history {
import flash.sampler.NewObjectSample;

public class BackgroundHistory implements IHistory {
    private var _fun : Function;
    private var _oldData : *;
    private var _newData : *;

    public function BackgroundHistory(fun : Function, oldData : *, newData : *) {
        _fun = fun;
        _oldData = oldData;
        _newData = newData;
    }

    public function redo() : void {
        _fun(_newData);
    }

    public function undo() : void {
        _fun(_oldData);
    }

    public function destroy() : void {
        _fun = null;
        _oldData = null;
        _newData = null;
    }
}
}
