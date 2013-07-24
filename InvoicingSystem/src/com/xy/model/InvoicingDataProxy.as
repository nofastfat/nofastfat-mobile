package com.xy.model {
import org.puremvc.as3.patterns.proxy.Proxy;

public class InvoicingDataProxy extends Proxy {
    public static const NAME : String = "InvoicingDataProxy";

    private var _uid : String;

    private var _pwd : String;

    public function InvoicingDataProxy() {
        super(NAME);
    }

    /**
     * 登录成功
     * @param uid
     * @param pwd
     */
    public function loginComplete(uid : String, pwd : String) : void {
        _uid = uid;
        _pwd = pwd;
    }

    /**
     * 帐号
     */
    public function get uid() : String {
        return _uid;
    }

    /**
     * 密码
     */
    public function get pwd() : String {
        return _pwd;
    }


}
}
