package com.xy.interfaces {
	import com.xy.model.LandlordsDataProxy;
	
	import org.puremvc.as3.patterns.command.SimpleCommand;

public class AbsCommand extends SimpleCommand {
    public function AbsCommand() {
        super();
    }

    public function get dataProxy() : LandlordsDataProxy {
        return facade.retrieveProxy(LandlordsDataProxy.NAME) as LandlordsDataProxy;
    }
}
}
