package com.xy.model {

/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-8-22 下午03:02:54
 **/
public class ExecuteDataProxy {
	private static var _dataProxy : ExecuteDataProxy;
	
	
	/**
	 * 工作空间
	 */
	public var workspace : String;
	
	/**
	 * 导出目录
	 */
	public var release : String;
	
	/**
	 * 打包的文件目录 
	 */	
	public var mxmlcFile : String = '"D:\\Adobe Flash Builder4\\Adobe Flash Builder 4\\sdks\\4.0.0\\bin\\mxmlc.exe"';
	
	/**
	 * AS3项目名 
	 */	
	public var programNames : Array = [];
	
	public static function getInstance() : ExecuteDataProxy {
		if (_dataProxy == null) {
			_dataProxy = new ExecuteDataProxy();
		}

		return _dataProxy;
	}

}
}
