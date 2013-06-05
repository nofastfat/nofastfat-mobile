package com.xy.component.alert.interfaces {

/**
 * 添加到alert中进行显示的接口 
 * @author xy
 */	
public interface IAlertContent{
	/**
	 * 获取当前面板中用于提交的数据 
	 * 格式自定义
	 * @return 
	 */	
	function getResult() : *;
	
	/**
	 * 获取当前的按钮操作类型
	 * @return 
	 * 
	 */	
	function getAlertType() : int;
	
	/**
	 * 获取当前面板的title类型 
	 * @return 
	 */	
	function getTitleType() : int;
	
	/**
	 * 销毁 
	 */	
	function dispose() : void;
}
}
