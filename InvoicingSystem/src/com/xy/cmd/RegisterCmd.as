package com.xy.cmd {
import com.xy.interfaces.AbsCommand;
import com.xy.model.InvoicingDataProxy;
import com.xy.view.AccountMediator;
import com.xy.view.FinanceMediator;
import com.xy.view.GoodManageMediator;
import com.xy.view.InGoodsMediator;
import com.xy.view.LeftMenuMediator;
import com.xy.view.LoginUIMediator;
import com.xy.view.OutGoodsMediator;
import com.xy.view.StorgeMediator;
import com.xy.view.WelcomeMediator;

import org.puremvc.as3.interfaces.INotification;

public class RegisterCmd extends AbsCommand {
    public static const NAME : String = "RegisterCmd";

    public function RegisterCmd() {
        super();
    }

    override public function execute(notification : INotification) : void {
        var root : InvoicingSystem = notification.getBody() as InvoicingSystem;

        facade.registerProxy(new InvoicingDataProxy());

        facade.registerMediator(new LoginUIMediator(root));
        facade.registerMediator(new LeftMenuMediator(root.leftMenuUI));
        facade.registerMediator(new WelcomeMediator(root));
        facade.registerMediator(new InGoodsMediator(root));
        facade.registerMediator(new OutGoodsMediator(root));
        facade.registerMediator(new StorgeMediator(root));
        facade.registerMediator(new FinanceMediator(root));
		facade.registerMediator(new AccountMediator(root));
		facade.registerMediator(new GoodManageMediator(root));

        facade.registerCommand(LoginCmd.NAME, LoginCmd);

    }
}
}
