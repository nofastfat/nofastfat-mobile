package com.xy.interfaces {
import com.xy.model.PKDataProxy;
import com.xy.util.Map;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;

public class AbsMediator extends Mediator implements ISimpleMediator {
	protected var _funMaps : Map;

	public function AbsMediator(mediatorName : String = null, viewComponent : Object = null) {
		super(mediatorName, viewComponent);

		_funMaps = makeNoticeMap();
	}

	public function get dataProxy() : PKDataProxy {
		return facade.retrieveProxy(PKDataProxy.NAME) as PKDataProxy;
	}

	public function makeNoticeMap() : Map {
		return null;
	}


	override public function listNotificationInterests() : Array {
		return _funMaps.keys;
	}

	override public function handleNotification(notification : INotification) : void {
		var body : * = notification.getBody();
		var fun : Function = _funMaps.get(notification.getName());
		if (fun != null) {
			if (body == null) {
				fun();
			} else if (body is Array) {
				fun.apply(this, body);
			} else {
				fun(body);
			}
		}
	}
}
}
