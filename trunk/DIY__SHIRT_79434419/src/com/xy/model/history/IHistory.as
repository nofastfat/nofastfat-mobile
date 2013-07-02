package com.xy.model.history {

public interface IHistory {
    /**
     * 重做
     */
    function redo() : void;

    /**
     * 撤销
     */
    function undo() : void;

	/**
	 * 销毁 
	 */	
    function destroy() : void;
}
}
