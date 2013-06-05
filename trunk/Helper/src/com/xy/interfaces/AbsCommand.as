package com.xy.interfaces {
	import com.xy.model.HelperDataProxy;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.facade.Facade;

public class AbsCommand extends SimpleCommand {
    public function AbsCommand() {
        super();
    }

    public function get dataProxy() : HelperDataProxy {
        return facade.retrieveProxy(HelperDataProxy.NAME) as HelperDataProxy;
    }
}
}
