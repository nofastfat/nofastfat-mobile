package com.xy.model {
import com.xy.model.vo.OrganizedStructVo;

import org.puremvc.as3.patterns.proxy.Proxy;

public class HelperDataProxy extends Proxy {
    public static const NAME : String = "HelperDataProxy";

	/**
	 * 初始化的自己的数据 
	 */	
    public var selfData : OrganizedStructVo;

    public function HelperDataProxy() {
        super(NAME);
    }

    /**
     * 初始化数据
     * @param data
     */
    public function initData(data : String) : void {
        if (data != null && data != "null" && data != "") {
            selfData = OrganizedStructVo.fromJsonStr(data);
            LoadingController.stopLoading();
        }
    }
}
}
