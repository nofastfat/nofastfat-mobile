package com.xy.cmd {
import com.xy.model.ExecuteDataProxy;
import com.xy.model.enum.Config;
import com.xy.util.Tools;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

/**
 * 扫描合法的工作空间
 * 只支持actionScript项目，不包含AIR
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-8-22 下午03:07:47
 **/
public class ScanWorkspaceCmd {

	/**
	 * 开始扫描
	 */
	public function execute() : void {
		var workspace : File = new File(dataProxy.workspace);
		var fileList : Array = workspace.getDirectoryListing();
		var as3Programs : Array = [];
		for each (var f : File in fileList) {
			var tmp : String = f.nativePath + File.separator + Config.ACTION_SCRIPT_PROPERTIES;

			/* 有.actionScriptProperties文件就是as3项目 */
			if (Tools.fileExists(tmp)) {

				/* AIR项目中是有 airExcludes 这个标记的*/
				var xml : XML = Tools.readXmlFrom(tmp);
				var list : XMLList = xml..airExcludes;
				if (list.length() != 0) {
					continue;
				}

				/* 库项目是有.flexLibProperties文件的 */
				var tmp2 : String = f.nativePath + File.separator + Config.FLEX_LIB_PROPERTIES;
				if (Tools.fileExists(tmp2)) {
					continue;
				}

				as3Programs.push(f.name);
			}
		}
		dataProxy.programNames = as3Programs;
	}

	public function get dataProxy() : ExecuteDataProxy {
		return ExecuteDataProxy.getInstance();
	}
}

}
