package com.xy.cmd {
import com.adobe.utils.StringUtil;
import com.xy.model.ExecuteDataProxy;
import com.xy.model.enum.Config;
import com.xy.util.Tools;

import flash.filesystem.File;
import flash.system.fscommand;


/**
 * 开始编译
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-8-22 下午04:15:06
 **/
public class CompileSwfCmd {

	private var index : int = 0;

	public function execute() : void {
		index = -1;
		next();
	}

	private function next() : void {
		index++;
		if (index >= dataProxy.programNames.length) {
			complete();
			return;
		}

		var progameName : String = dataProxy.programNames[index];

		/* 目录 */
		var path : String = dataProxy.workspace + File.separator + progameName + File.separator;

		/* CMD命令前半段 */
		var cmdPre : String = dataProxy.mxmlcFile + " ";
		var xml : XML = Tools.readXmlFrom(path + Config.ACTION_SCRIPT_PROPERTIES);

		/* 预设的编译参数 */
		var additionalCompilerArguments : String = String(xml..compiler.@additionalCompilerArguments);
		additionalCompilerArguments += " ";

		/* 项目结构的编译参数 */
		var endCompilerArguments : String = Config.OUT_PUT + " " + dataProxy.release + " " ;
		for each (var xl : XML in xml..libraryPath.libraryPathEntry) {

			var useRsl : Boolean = false;
			if (xl.@linkType == undefined || int(xl.@linkType) == 2) {
				useRsl = true;
			}

			if (xl.@useDefaultLinkType != undefined && String(xl.@useDefaultLinkType).toLocaleLowerCase() != "false") {

				useRsl = true;
			}

			var pp : String = String(xl.@path);
			pp = StringUtil.replace(pp, "/", "\\");
			if(pp != ""){
				if(pp.substr(0, 1) == "\\"){
					pp = dataProxy.workspace + pp;
				}
				endCompilerArguments += (useRsl ? Config.RSL : Config.INCLUDE_LIBRARIES) + " " + pp + " ";
			}
		}


		/* 需要编译的AS文件列表 */
		var asFiles : Array = [];
		for each (xl in xml..application) {
			asFiles.push(path + "src" + File.separator + String(xl.@path) + " ");
		}

		for each (var asFile : String in asFiles) {
			var cmd : String = cmdPre + asFile + additionalCompilerArguments + endCompilerArguments;
			cmd = StringUtil.replace(cmd, "${DOCUMENTS}", dataProxy.workspace);
			trace(cmd);
			fscommand(cmd);
		}
	}

	private function complete() : void {

	}

	public function get dataProxy() : ExecuteDataProxy {
		return ExecuteDataProxy.getInstance();
	}
}
}
