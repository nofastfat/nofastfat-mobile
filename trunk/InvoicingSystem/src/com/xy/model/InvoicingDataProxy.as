package com.xy.model {
import com.adobe.serialization.json.JSON;
import com.xy.model.enum.InvoicingDataNotice;
import com.xy.model.vo.CourierVo;
import com.xy.model.vo.GoodsVo;
import com.xy.util.Base64;

import flash.utils.ByteArray;

import org.puremvc.as3.patterns.proxy.Proxy;

public class InvoicingDataProxy extends Proxy {
    public static const NAME : String = "InvoicingDataProxy";

    private var _uid : String;

    private var _pwd : String;

    private var _goods : Array;

    private var _couriers : Array;

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
            var vo : GoodsVo = new GoodsVo();
            vo.id = int(ar[0]);
            vo.name = ar[1];
            vo.info = ar[2];
            vo.weight = Number(ar[3]);
            vo.sbn = ar[4];
            vo.type = ar[5];
            _goods.push(vo);
        }

        sendNotification(InvoicingDataNotice.GOODS_LIST_UPDATE);
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
            var vo : CourierVo = new CourierVo();
            vo.id = int(ar[0]);
            vo.name = ar[1];
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


}
}
