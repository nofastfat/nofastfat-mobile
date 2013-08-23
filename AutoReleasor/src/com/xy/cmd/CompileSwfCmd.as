package com.xy.cmd {
import com.adobe.utils.StringUtil;
import com.xy.model.ExecuteDataProxy;
import com.xy.model.enum.Config;
import com.xy.util.Tools;

import flash.desktop.NativeProcess;
import flash.desktop.NativeProcessStartupInfo;
import flash.events.ProgressEvent;
import flash.filesystem.File;
import flash.system.fscommand;
import flash.utils.IDataInput;
import flash.utils.IDataOutput;
import flash.utils.flash_proxy;

import mx.skins.halo.ScrollTrackSkin;


/**
 * 开始编译
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-8-22 下午04:15:06
 **/
public class CompileSwfCmd {

	private var index : int = 0;

	private var _native : NativeProcess;

	private var _asFiles : Array = [];
	private var _cmdlines : Array = [];

	public function CompileSwfCmd() {
		_native = new NativeProcess();
		_native.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, __outHandler);
		_native.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, __errorHandler);

	}

	public function execute() : void {
		fetchAllAsFiles();

		var startInfo : NativeProcessStartupInfo = new NativeProcessStartupInfo();
		startInfo.executable = new File("C:/Windows/system32/cmd.exe");
		_native.start(startInfo);

		trace(_cmdlines.length);
		index = -1;
	}

	/**
	 * 找出所有需要编译的AS入口类
	 */
	private function fetchAllAsFiles() : void {
		for each (var progameName : String in dataProxy.programNames) {
			/* 目录 */
			var path : String = dataProxy.workspace + File.separator + progameName + File.separator;

			/* CMD命令前半段 */
			var cmdPre : String = dataProxy.mxmlcFile + " ";
			var xml : XML = Tools.readXmlFrom(path + Config.ACTION_SCRIPT_PROPERTIES);

			/* 预设的编译参数 */
			var additionalCompilerArguments : String = String(xml..compiler.@additionalCompilerArguments);
			additionalCompilerArguments += " ";
			additionalCompilerArguments = checkAdditionalCompilerArguments(additionalCompilerArguments);

			/* 项目结构的编译参数 */
			var endCompilerArguments : String = "";
			for each (var xl : XML in xml..libraryPath.libraryPathEntry) {

				var useRsl : Boolean = false;
				if (xl.@linkType == undefined || int(xl.@linkType) == 2) {
					useRsl = true;
				}

				if (xl.@useDefaultLinkType != undefined && String(xl.@useDefaultLinkType).toLocaleLowerCase() != "false") {

					useRsl = true;
				}

				var pp : String = String(xl.@path);
				pp = StringUtil.replace(pp, "/", File.separator);
				pp = StringUtil.replace(pp, "${DOCUMENTS}", dataProxy.workspace);
				if (pp != "") {
					/* 相对路径的话，需要完善成绝对路径 */
					if (pp.indexOf(":") == -1) {
						if (pp.substr(0, 1) == File.separator) {
							pp = dataProxy.workspace + pp;
						}else{
							pp = dataProxy.workspace + File.separator + progameName + File.separator + pp;
						}
					}
					endCompilerArguments += (useRsl ? Config.RSL : Config.INCLUDE_LIBRARIES) + " " + pp + " ";
				}
			}

			endCompilerArguments += Config.OUT_PUT + " " + dataProxy.release + File.separator;

			/* 是否引用其他目录src */
			var sourcePathArgs : String = "";
			for each (xl in xml..compilerSourcePath.compilerSourcePathEntry) {
				if (xl.@linkType != undefined || int(xl.@linkType) == 1) {
					sourcePathArgs += Config.SOURCE_PATH + " " + String(xl.@path) + " ";
				}
			}

			/* 需要编译的AS文件列表 */
			for each (xl in xml..application) {
				var asFile : String = path + "src" + File.separator + String(xl.@path) + " ";
				var fName : String = String(xl.@path).substr(0, String(xl.@path).indexOf(".")) + ".swf";

				if (dataProxy.banList.indexOf(fName) == -1) {
					var cmd : String = cmdPre + asFile + additionalCompilerArguments + endCompilerArguments + fName + " " + sourcePathArgs + Config.STATIC_RSLS;
					cmd = StringUtil.replace(cmd, "${DOCUMENTS}", dataProxy.workspace);
					cmd = StringUtil.replace(cmd, "/", File.separator);

					/* 进入到工作空间目录下 */
					cmd = "cd " + dataProxy.workspace + "\n" + dataProxy.workspace.substr(0, dataProxy.workspace.indexOf("\\")) + "\n" + cmd;
					_asFiles.push(fName);
					_cmdlines.push(cmd);
				}
			}
		}
	}

	/**
	 * 检查预制参数中的相对路径
	 * @param args
	 * @return 
	 */	
	private function checkAdditionalCompilerArguments(args : String) : String{
		args = StringUtil.replace(args, "${DOCUMENTS}", dataProxy.workspace);
		args = StringUtil.trim(args);
		args = StringUtil.replace(args, "/", File.separator);
		args = StringUtil.replace(args, " " + File.separator, " " + dataProxy.workspace + File.separator);
		return args + " ";
	}
	
	/**
	 * 执行下一条命令 
	 * 
	 */	
	private function next() : void {
		index++;
		if (index >= _cmdlines.length) {
			complete();
			return;
		}

		var cmdline : String = _cmdlines[index]
		_native.standardInput.writeMultiByte(cmdline + "\n", "GBK");
	}

	/**
	 * 控制台输出 
	 * @param e
	 */	
	private function __outHandler(e : ProgressEvent) : void {
		var out : IDataInput = _native.standardOutput;
		var info : String = out.readMultiByte(out.bytesAvailable, "GBK");
		trace("info->" + info);

		var keys : Array = [
			_asFiles[index] + "（",
			"Microsoft Corporation"
			];
		var hasKey : Boolean = false;
		for each (var str : String in keys) {
			if (info.indexOf(str) != -1) {
				hasKey = true;
			}
		}

		if (hasKey) {
			trace(_asFiles[index]);
			next();
		}
	}

	/**
	 * 控制台错误 
	 * @param e
	 */	
	private function __errorHandler(e : ProgressEvent) : void {
		var out : IDataInput = _native.standardError;
		trace("error->" + out.readMultiByte(out.bytesAvailable, "GBK"));
		_native.exit(true);
	}

	private function complete() : void {
		trace("完成！");
	}

	public function get dataProxy() : ExecuteDataProxy {
		return ExecuteDataProxy.getInstance();
	}
}
}
