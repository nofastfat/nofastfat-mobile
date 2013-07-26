package com.xy.model {
import com.xy.model.vo.GoodsVo;
import com.xy.util.STool;

import org.puremvc.as3.patterns.facade.Facade;

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

    /**
     * 添加商品
     * @param vo
     * @return
     */
    public static function makeAddCommodityUrl(vo : GoodsVo) : String {
        var rs : String = HTTP_URL + "?method=addCommodity&self={0}&selfPwd={1}&name={2}&description={3}&weight={4}&SBNId={5}&type={6}";
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd, vo.name, vo.info, vo.weight, vo.sbn, vo.type);
        return rs;
    }

    /**
     * 获取商品列表
     * @param vo
     * @return
     */
    public static function makeQueryCommodityUrl() : String {
        var rs : String = HTTP_URL + "?method=queryCommodity&self={0}&selfPwd={1}";
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd);
        return rs;
    }

    /**
     * 修改商品
     * @param vo
     * @return
     */
    public static function makeModifyCommodityUrl(vo : GoodsVo) : String {
        var rs : String = HTTP_URL + "?method=modifyCommodity&self={0}&selfPwd={1}&modifyId={2}&name={3}&description={4}&weight={5}&SBNId={6}&type={7}";
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd, vo.id, vo.name, vo.info, vo.weight, vo.sbn, vo.type);
        return rs;
    }

    /**
    * 删除商品
    * @param vo
    * @return
    */
    public static function makeDeleteCommodityUrl(vo : GoodsVo) : String {
        var rs : String = HTTP_URL + "?method=deleteCommodity&self={0}&selfPwd={1}&delId={2}";
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd, vo.id);
        return rs;
    }



    public static function get dataProxy() : InvoicingDataProxy {
        return Facade.getInstance().retrieveProxy(InvoicingDataProxy.NAME) as InvoicingDataProxy;
    }
}
}
