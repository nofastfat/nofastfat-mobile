package com.xy.model.vo {
import flash.geom.Rectangle;

/**
 * *如果需要在模版中预设图片，添加如下配置文件，可同时添加多个：
		<defaultImage id="0" x="0" y="" width="100" height="100" />
		id	预设图片的ID，必须在配置文件中存在
		rect 预设图片的位置及大小，英文逗号分隔，
			 格式:"ix,iy,iw,ih"
			 其中,ix表示预设图片相对于【编辑区域】的x坐标
			 	  iy表示预设图片相对于【编辑区域】的y坐标
			 	  iw表示预设图片的初始宽度
			 	  ih表示预设图片的初始高度 
 * @author xy
 * 
 */
public class DefaultImageVo {
    public var id : String;
    public var rect : Rectangle;
}
}
