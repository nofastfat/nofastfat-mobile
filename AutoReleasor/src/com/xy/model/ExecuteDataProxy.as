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

	/**
	 * 不需要编译的
	 */
	public var banList : Array = [];
		
//	[
//		"Arena.swf",
//		"BG180001Map.swf",
//		"BG180002Map.swf",
//		"BG180003Map.swf",
//		"BG180004Map.swf",
//		"BG180005Map.swf",
//		"BG180006Map.swf",
//		"BG180007Map.swf",
//		"BG182499Map.swf",
//		"BG182500Map.swf",
//		"BG182501Map.swf",
//		"BG182502Map.swf",
//		"BG182503Map.swf",
//		"BG182504Map.swf",
//		"BG182505Map.swf",
//		"BG182506Map.swf",
//		"BG184498Map.swf",
//		"BG184499Map.swf",
//		"BG184501Map.swf",
//		"BG184502Map.swf",
//		"BG184503Map.swf",
//		"BG184504Map.swf",
//		"BG184505Map.swf",
//		"BG184506Map.swf",
//		"BG185000Map.swf",
//		"BG185001Map.swf",
//		"BG185002Map.swf",
//		"BG185003Map.swf",
//		"BG185004Map.swf",
//		"BG185005Map.swf",
//		"BG185006Map.swf",
//		"BG187501Map.swf",
//		"BG187502Map.swf",
//		"BG187503Map.swf",
//		"BlackMarket.swf",
//		"CoinTree.swf",
//		"DailyActivities.swf",
//		"DailyAttendance.swf",
//		"DevFight.swf",
//		"FriendSystem.swf",
//		"GodCommon_dll.swf",
//		"Preloader.swf",
//		"GodModeGame.swf",
//		"GodTools_dll.swf",
//		"Greensock_dll.swf",
//		"Hayate_dll.swf",
//		"League.swf",
//		"MiniFight.swf",
//		"PureMVC_dll.swf",
//		"Raider.swf",
//		"undefined",
//		"Recruiter.swf",
//		"RoleCreator.swf",
//		"test_deflate_inflate.swf",
//		"Test.swf",
//		"UIMain.swf",
//		"VipIntroduction.swf",
//		"VipMallStore.swf",
//		"WorldMap.swf"
//		];

	public static function getInstance() : ExecuteDataProxy {
		if (_dataProxy == null) {
			_dataProxy = new ExecuteDataProxy();
		}

		return _dataProxy;
	}

}
}
