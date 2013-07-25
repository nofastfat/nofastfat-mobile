package com.xy.view {
import com.xy.interfaces.AbsMediator;
import com.xy.view.events.LeftMenuUIEvent;
import com.xy.view.ui.LeftMenuUI;

import flash.events.Event;

/**
 * 左边菜单
 * @author xy
 */
public class LeftMenuMediator extends AbsMediator {
    public static const NAME : String = "LeftMenuMediator";

    public function LeftMenuMediator(ui : LeftMenuUI) {
        super(NAME, ui);

        ui.addEventListener(LeftMenuUIEvent.SHOW_IN_GOODS, __showInGoodsHandler);
        ui.addEventListener(LeftMenuUIEvent.SHOW_OUT_GOODS, __showOutGoodsHandler);
        ui.addEventListener(LeftMenuUIEvent.SHOW_STORGE, __showStorgeHandler);
        ui.addEventListener(LeftMenuUIEvent.SHOW_FINANCE, __showFinanceHandler);
        ui.addEventListener(LeftMenuUIEvent.SHOW_ACCOUNT, __showAccountHandler);
    }

    private function __showInGoodsHandler(e : Event) : void {
        sendNotification(InGoodsMediator.SHOW);
    }

    private function __showOutGoodsHandler(e : Event) : void {
        sendNotification(OutGoodsMediator.SHOW);

    }

    private function __showStorgeHandler(e : Event) : void {
        sendNotification(StorgeMediator.SHOW);

    }

    private function __showFinanceHandler(e : Event) : void {
        sendNotification(FinanceMediator.SHOW);

    }

    private function __showAccountHandler(e : Event) : void {
        sendNotification(AccountMediator.SHOW);

    }

    public function get ui() : LeftMenuUI {
        return viewComponent as LeftMenuUI;
    }
}
}
