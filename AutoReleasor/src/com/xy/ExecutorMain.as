package com.xy {
import com.xy.cmd.CompileSwfCmd;
import com.xy.cmd.ScanWorkspaceCmd;
import com.xy.model.ExecuteDataProxy;

import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;


/**
 * 处理核心
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-8-22 下午02:44:58
 **/
public class ExecutorMain extends EventDispatcher {
	public function ExecutorMain() {
		super();
	}
	
	/**
	 * 开始处理 
	 * @param workspace 工作空间目录
	 * @param release 发布文件的目录
	 */	
	public function startUp(workspace:String, release:String):void{
		dataProxy.workspace = workspace;
		dataProxy.release = release;
		
		/* 扫描工作空间 */
		var scan : ScanWorkspaceCmd = new ScanWorkspaceCmd();
		scan.execute();
		
		/* 开始打包swf文件*/
		var compile : CompileSwfCmd = new CompileSwfCmd();
		compile.execute();
	}
	
	public function get dataProxy():ExecuteDataProxy{
		return ExecuteDataProxy.getInstance();
	}
}
}
