package com.xy.view {
import com.xy.interfaces.AbsMediator;

/**
 * 注册 
 * @author xy
 */
public class RegisteMediator extends AbsMediator {
	public static const NAME : String = "RegisteMediator";
	
	public function RegisteMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}
}
}
