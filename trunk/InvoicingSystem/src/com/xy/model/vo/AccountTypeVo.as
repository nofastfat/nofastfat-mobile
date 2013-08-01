package com.xy.model.vo {
	import com.xy.model.enum.AccountType;
	
public class AccountTypeVo {
    public var type : int;
    public var name : String;
	
	public function AccountTypeVo(type : int){
		this.type = type;
		this.name = AccountType.ToString(type);
	}
}
}
