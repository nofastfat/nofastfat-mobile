package com.xy.interfaces {
import com.xy.model.PKDataProxy;

import org.puremvc.as3.patterns.command.SimpleCommand;

public class AbsCommand extends SimpleCommand {
	public function AbsCommand() {
		super();
	}
	
	public function get dataProxy() : PKDataProxy{
		return facade.retrieveProxy(PKDataProxy.NAME) as PKDataProxy;
	}
}
}
