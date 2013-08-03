package com.xy.model {
import com.adobe.serialization.json.JSON;
import com.xy.model.enum.InvoicingDataNotice;
import com.xy.model.vo.AccountTypeVo;
import com.xy.model.vo.AccountVo;
import com.xy.model.vo.CourierVo;
import com.xy.model.vo.GoodsVo;
import com.xy.model.vo.PurchaseLogVo;
import com.xy.model.vo.SoldLogVo;
import com.xy.model.vo.StoreVo;
import com.xy.util.Base64;

import flash.utils.ByteArray;

import org.puremvc.as3.patterns.proxy.Proxy;

public class InvoicingDataProxy extends Proxy {
    public static const NAME : String = "InvoicingDataProxy";

    private var _uid : String;

    private var _pwd : String;

    private var _type : int;

    private var _goods : Array;

    private var _couriers : Array;

    private var _stores : Array;

    private var _soldLogs : Array;

    private var _purchaseLogs : Array;

    private var _users : Array;

    public function InvoicingDataProxy() {
        super(NAME);
    }

    /**
     * 登录成功
     * @param uid
     * @param pwd
     */
    public function loginComplete(uid : String, pwd : String, type : int) : void {
        _uid = uid;
        _pwd = pwd;
        _type = type;
    }

    public function changePwd(pwd : String) : void {
        _pwd = pwd;
    }

    /**
     * 初始化商品列表
     * [[id, name, description, weight, SBNId, type], [id, name, description, weight, SBNId, type], ...]
     * @param arr
     */
    public function initGoods(data : String) : void {
        _goods = [];
        var ba : ByteArray = Base64.decode(data);
        ba.uncompress();
        ba.position = 0;
        var json : String = ba.readUTFBytes(ba.bytesAvailable);
        var arr : Array = JSON.decode(json);

        for each (var ar : Array in arr) {
            var vo : GoodsVo = GoodsVo.fromArr(ar);
            _goods.push(vo);
        }

        sendNotification(InvoicingDataNotice.GOODS_LIST_UPDATE);
    }

    public function clearGoods() : void {
        _goods = null;
    }

    /**
     * 添加一个商品
     * @param vo
     */
    public function addGoods(vo : GoodsVo) : void {
        if (_goods == null) {
            return;
        }

        _goods.push(vo);

        sendNotification(InvoicingDataNotice.GOODS_LIST_UPDATE, vo.id);
    }

    /**
     * 获取商品类别
     * @return
     */
    public function getGoodsTypes() : Array {
        var arr : Array = [];
        for each (var vo : GoodsVo in _goods) {
            if (arr.indexOf(vo.type) == -1) {
                arr.push(vo.type);
            }
        }

        return arr;
    }

    /**
     * 更新数据
     * @param vo
     */
    public function updateGoods(vo : GoodsVo) : void {
        for each (var vv : GoodsVo in _goods) {
            if (vv.id == vo.id) {
                vv.copyFrom(vo);
            }
        }

        sendNotification(InvoicingDataNotice.GOODS_LIST_UPDATE, vo.id);
    }

    public function deleteGoods(vo : GoodsVo) : void {
        for (var i : int = 0; i < _goods.length; i++) {
            if (_goods[i].id == vo.id) {
                _goods.splice(i, 1);
                break;
            }
        }

        sendNotification(InvoicingDataNotice.GOODS_LIST_UPDATE);
    }

    public function clearCourier() : void {
        _couriers = null;
    }

    public function addCourier(vo : CourierVo) : void {
        if (_couriers == null) {
            return;
        }

        _couriers.push(vo);

        sendNotification(InvoicingDataNotice.COURIER_LIST_UPDATE, vo.id);
    }

    /**
     * 初始化快递列表
     * [[id, name], [id, name], ...]
     * @param arr
     */
    public function initCouriers(data : String) : void {
        _couriers = [];
        var ba : ByteArray = Base64.decode(data);
        ba.uncompress();
        ba.position = 0;
        var json : String = ba.readUTFBytes(ba.bytesAvailable);
        var arr : Array = JSON.decode(json);

        for each (var ar : Array in arr) {
            var vo : CourierVo = CourierVo.fromArr(ar);
            _couriers.push(vo);
        }

        sendNotification(InvoicingDataNotice.COURIER_LIST_UPDATE);
    }

    public function deleteCourier(vo : CourierVo) : void {
        for (var i : int = 0; i < _couriers.length; i++) {
            if (_couriers[i].id == vo.id) {
                _couriers.splice(i, 1);
                break;
            }
        }

        sendNotification(InvoicingDataNotice.COURIER_LIST_UPDATE);
    }

    /**
     * 更新数据
     * @param vo
     */
    public function updateCourier(vo : CourierVo) : void {
        for each (var vv : CourierVo in _couriers) {
            if (vv.id == vo.id) {
                vv.copyFrom(vo);
            }
        }

        sendNotification(InvoicingDataNotice.COURIER_LIST_UPDATE, vo.id);
    }

    public function clearStore() : void {
        _stores = null;
    }

    public function addStore(vo : StoreVo) : void {
        if (_stores == null) {
            return;
        }

        _stores.push(vo);
        sendNotification(InvoicingDataNotice.STORE_LIST_UPDATE, vo.id);
    }

    public function getAccountTypes() : Array {
        var rs : Array = [];
        for (var i : int = 1; i <= 3; i++) {
            if (i > _type) {
                rs.push(new AccountTypeVo(i));
            }
        }
        return rs;
    }

    public function addUser(vo : AccountVo) : void {
        if (_users == null) {
            return;
        }

        _users.push(vo);
        sendNotification(InvoicingDataNotice.USER_LIST_UPDATE);
    }

    public function initUsers(data : String) : void {
        _users = [];
        var ba : ByteArray = Base64.decode(data);
        ba.uncompress();
        ba.position = 0;
        var json : String = ba.readUTFBytes(ba.bytesAvailable);
        var arr : Array = JSON.decode(json);

        for each (var ar : Array in arr) {
            var vo : AccountVo = AccountVo.fromArr(ar);
            _users.push(vo);
        }

        sendNotification(InvoicingDataNotice.USER_LIST_UPDATE);
    }

    public function deleteUser(id : String) : void {
        for (var i : int = 0; i < _users.length; i++) {
            if (_users[i].id == id) {
                _users.splice(i, 1);
                break;
            }
        }

        sendNotification(InvoicingDataNotice.USER_LIST_UPDATE);
    }

    /**
     * 初始化商品列表
     * [[id,SBN,name,num,madeTime,operator,storeTime, retailPrice], [id,SBN,name,num,madeTime,operator,storeTime, retailPrice], ...]
     * @param arr
     */
    public function initStore(data : String) : void {
        _stores = [];
        var ba : ByteArray = Base64.decode(data);
        ba.uncompress();
        ba.position = 0;
        var json : String = ba.readUTFBytes(ba.bytesAvailable);
        var arr : Array = JSON.decode(json);

        for each (var ar : Array in arr) {
            var vo : StoreVo = StoreVo.fromArr(ar);
            _stores.push(vo);
        }

        sendNotification(InvoicingDataNotice.STORE_LIST_UPDATE);
    }

    public function initSoldLog(data : String) : void {
        _soldLogs = [];

        var ba : ByteArray = Base64.decode(data);
        ba.uncompress();
        ba.position = 0;
        var json : String = ba.readUTFBytes(ba.bytesAvailable);
        var arr : Array = JSON.decode(json);

        for each (var ar : Array in arr) {
            var vo : SoldLogVo = SoldLogVo.fromArr(ar);
            _soldLogs.push(vo);
        }

        sendNotification(InvoicingDataNotice.SOLD_LOG_UPDATE);
    }

    public function initPurchaseLog(data : String) : void {
        _purchaseLogs = [];

        var ba : ByteArray = Base64.decode(data);
        ba.uncompress();
        ba.position = 0;
        var json : String = ba.readUTFBytes(ba.bytesAvailable);
        var arr : Array = JSON.decode(json);

        for each (var ar : Array in arr) {
            var vo : PurchaseLogVo = PurchaseLogVo.fromArr(ar);
            _purchaseLogs.push(vo);
        }

        sendNotification(InvoicingDataNotice.PURCHASE_LOG_UPDATE);
    }

	public function clearSoldLog():void{
		_soldLogs = null;
	}
	
	public function clearPurchaseLog():void{
		_purchaseLogs = null;
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

    public function get goods() : Array {
        return _goods;
    }

    public function get couriers() : Array {
        return _couriers;
    }

    public function get users() : Array {
        return _users;
    }

    public function get type() : int {
        return _type;
    }

    public function get stores() : Array {
        return _stores;
    }

    public function get soldLogs() : Array {
        return _soldLogs;
    }

    public function get purchaseLogs() : Array {
        return _purchaseLogs;
    }

}
}
