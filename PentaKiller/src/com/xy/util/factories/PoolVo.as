package com.xy.util.factories {

public class PoolVo {
	public var conetnt : *;
	public var isUsing : Boolean;
	
	public function PoolVo(conetnt : *){
		this.conetnt = conetnt;
		this.isUsing = false;
	}
}
}
