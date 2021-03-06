package com.xy.model {
import com.xy.model.vo.AccountVo;
import com.xy.model.vo.CourierVo;
import com.xy.model.vo.GoodsVo;
import com.xy.model.vo.SoldVo;
import com.xy.model.vo.StoreVo;
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
        var rs : String = HTTP_URL + "?method=login&uid={0}&pwd={1}" + "&r=" + Math.random();
        rs = STool.format(rs, uid, pwd);

        return rs;
    }

    /**
     * 添加商品
     * @param vo
     * @return
     */
    public static function makeAddCommodityUrl(vo : GoodsVo) : String {
        var rs : String = HTTP_URL + "?method=addCommodity&self={0}&selfPwd={1}&name={2}&description={3}&weight={4}&SBNId={5}&type={6}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd, vo.name, vo.info, vo.weight, vo.sbn, vo.type);
        return rs;
    }

    /**
     * 获取商品列表
     * @param vo
     * @return
     */
    public static function makeQueryCommodityUrl() : String {
        var rs : String = HTTP_URL + "?method=queryCommodity&self={0}&selfPwd={1}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd);
        return rs;
    }

    /**
     * 修改商品
     * @param vo
     * @return
     */
    public static function makeModifyCommodityUrl(vo : GoodsVo) : String {
        var rs : String = HTTP_URL + "?method=modifyCommodity&self={0}&selfPwd={1}&modifyId={2}&name={3}&description={4}&weight={5}&SBNId={6}&type={7}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd, vo.id, vo.name, vo.info, vo.weight, vo.sbn, vo.type);
        return rs;
    }

    /**
     * 删除商品
     * @param vo
     * @return
     */
    public static function makeDeleteCommodityUrl(vo : GoodsVo) : String {
        var rs : String = HTTP_URL + "?method=deleteCommodity&self={0}&selfPwd={1}&delId={2}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd, vo.id);
        return rs;
    }

    /**
     * 添加商品
     * @param vo
     * @return
     */
    public static function makeAddCourierUrl(vo : CourierVo) : String {
        var rs : String = HTTP_URL + "?method=addCourier&self={0}&selfPwd={1}&name={2}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd, vo.name);
        return rs;
    }

    /**
     * 获取商品列表
     * @param vo
     * @return
     */
    public static function makeQueryCourierUrl() : String {
        var rs : String = HTTP_URL + "?method=queryCourier&self={0}&selfPwd={1}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd);
        return rs;
    }

    /**
     * 删除商品
     * @param vo
     * @return
     */
    public static function makeDeleteCourierUrl(vo : CourierVo) : String {
        var rs : String = HTTP_URL + "?method=deleteCourier&self={0}&selfPwd={1}&delId={2}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd, vo.id);
        return rs;
    }

    /**
     * 修改商品
     * @param vo
     * @return
     */
    public static function makeModifyCourierUrl(vo : CourierVo) : String {
        var rs : String = HTTP_URL + "?method=modifyCourier&self={0}&selfPwd={1}&id={2}&name={3}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd, vo.id, vo.name);
        return rs;
    }

    /**
     * 入库
     * @param vo
     * @return
     */
    public static function makePurchaseUrl(vo : StoreVo) : String {
        var rs : String = HTTP_URL + "?method=purchase&self={0}&selfPwd={1}&commonditySBN={2}&commondityName={3}&num={4}&realRetailPrice={5}&madeTime={6}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd, vo.SBN, vo.name, vo.num, vo.retailPrice, vo.madeTime);
        return rs;
    }

    /**
     * 添加用户
     * @param vo
     * @return
     */
    public static function makeAddUserUrl(vo : AccountVo) : String {
        var rs : String = HTTP_URL + "?method=addNewUser&self={0}&selfPwd={1}&newId={2}&newType={3}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd, vo.id, vo.type);
        return rs;
    }

    /**
     * 获取用户列表
     * @param vo
     * @return
     */
    public static function makeQueryUserUrl() : String {
        var rs : String = HTTP_URL + "?method=queryUsers&self={0}&selfPwd={1}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd);
        return rs;
    }

    /**
     * 修改密码
     * @param oldPwd
     * @param newPwd
     * @return
     */
    public static function makeModifyPwdUrl(oldPwd : String, newPwd : String) : String {
        var rs : String = HTTP_URL + "?method=changePwd&uid={0}&oldPwd={1}&newPwd={2}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, oldPwd, newPwd);
        return rs;
    }

    /**
     * 删除用户
     * @param vo
     * @return
     */
    public static function makeDeleteUserUrl(vo : AccountVo) : String {
        var rs : String = HTTP_URL + "?method=deleteUser&self={0}&selfPwd={1}&delId={2}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd, vo.id);
        return rs;
    }

    /**
     * 重置密码
     * @param vo
     * @return
     */
    public static function makeResetPwdUrl(vo : AccountVo) : String {
        var rs : String = HTTP_URL + "?method=resetPwd&self={0}&selfPwd={1}&uid={2}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd, vo.id);
        return rs;
    }

    /**
     * 获取库存数据
     * @param vo
     * @return
     */
    public static function makeQueryStoreUrl() : String {
        var rs : String = HTTP_URL + "?method=queryStore&self={0}&selfPwd={1}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd);
        return rs;
    }

    /**
     * 出库
     * @param vo
     * @return
     */
    public static function makeSoldUrl(vo : SoldVo) : String {
        var rs : String = HTTP_URL + "?method=sold&self={0}&selfPwd={1}&storeId={2}&clientName={3}&num={4}&totalWeight={5}&soldAddress={6}&senderCompany={7}&sendId={8}&clientPay={9}&sendPrice={10}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd, vo.goodsIds, vo.clientName, vo.nums, vo.totalWeight, vo.address, vo.courier, vo.sendId, vo.userPay, vo.courierPay);
        return rs;
    }

    /**
     * 获取入库记录
     * @return
     */
    public static function makeQueryPurchaseLogUrl() : String {
        var rs : String = HTTP_URL + "?method=queryPurchaseLog&self={0}&selfPwd={1}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd);
        return rs;
    }

    /**
     * 获取出库记录
     * @return
     */
    public static function makeQuerySoldLogUrl() : String {
        var rs : String = HTTP_URL + "?method=querySoldLog&self={0}&selfPwd={1}" + "&r=" + Math.random();
        rs = STool.format(rs, dataProxy.uid, dataProxy.pwd);
        return rs;
    }

    public static function get dataProxy() : InvoicingDataProxy {
        return Facade.getInstance().retrieveProxy(InvoicingDataProxy.NAME) as InvoicingDataProxy;
    }
}
}
