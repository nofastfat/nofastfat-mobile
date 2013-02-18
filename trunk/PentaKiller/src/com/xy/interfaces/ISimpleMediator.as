package com.xy.interfaces {
	import com.xy.util.Map;

/**
 * 简化Mediator的初始化 
 * @author xy
 */	
public interface ISimpleMediator {
	/**
	 * 返回一个Array，这个值以前写在listNotificationInterests中 
	 * @return 
	 */	
	function makeNoticeMap():Map;
}
}
