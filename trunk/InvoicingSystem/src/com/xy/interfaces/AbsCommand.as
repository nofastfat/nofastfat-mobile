package com.xy.interfaces {
	import com.xy.model.InvoicingDataProxy;
	
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.facade.Facade;

public class AbsCommand extends SimpleCommand {
    public function AbsCommand() {
        super();
    }

    public function get dataProxy() : InvoicingDataProxy {
        return facade.retrieveProxy(InvoicingDataProxy.NAME) as InvoicingDataProxy;
    }
}
}
