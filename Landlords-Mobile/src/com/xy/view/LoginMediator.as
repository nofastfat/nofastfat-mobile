package com.xy.view {
import com.xy.interfaces.AbsMediator;

/**
 * 登录 
 * @author xy
 */
public class LoginMediator extends AbsMediator {
	public static const NAME : String = "LoginMediator";
	
	public function LoginMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}
}
}
