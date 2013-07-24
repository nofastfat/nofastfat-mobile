package com.xy.model {
	import com.xy.util.STool;

public class Config {

    /**
     * 数据地址
     */
    public static var HTTP_URL : String;


	/**
	 * 登录请求 
	 * @param uid
	 * @param pwd
	 * @return 
	 */	
    public static function makeLoginUrl(uid : String, pwd : String) : String {
        var rs : String = HTTP_URL + "?method=login&uid={0}&pwd={1}";
		rs = STool.format(rs, uid, pwd);

        return rs;
    }
}
}
