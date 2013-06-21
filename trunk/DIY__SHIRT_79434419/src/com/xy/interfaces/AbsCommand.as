package com.xy.interfaces {
	import com.xy.model.DiyDataProxy;
	
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.facade.Facade;

public class AbsCommand extends SimpleCommand {
    public function AbsCommand() {
        super();
    }

    public function get dataProxy() : DiyDataProxy {
        return facade.retrieveProxy(DiyDataProxy.NAME) as DiyDataProxy;
    }
}
}
