package com.xy.view.events {
import com.xy.model.vo.AccountVo;
import com.xy.view.ui.AccountUI;

import flash.events.Event;

public class AccountUIEvent extends Event {

    public static const SHOW_QUERY_USER : String = "SHOW_QUERY_USER";
    public static const SHOW_USER_SEARCH : String = "SHOW_USER_SEARCH";
    public static const SHOW_ADD_USER : String = "SHOW_ADD_USER";
    public static const SHOW_MODIDY_PWD : String = "SHOW_MODIDY_PWD";

    public static const DELETE_USER : String = "DELETE_USER";
    public static const RESET_PWD : String = "RESET_PWD";

    public var ui : AccountUI;
    public var vo : AccountVo;

    public function AccountUIEvent(type : String, ui : AccountUI, vo : AccountVo = null, bubbles : Boolean = false, cancelable : Boolean = false) {
        super(type, bubbles, cancelable);
        this.ui = ui;
        this.vo = vo;
    }

}
}
