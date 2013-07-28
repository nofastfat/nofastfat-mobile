package com.xy.model.vo {
import com.adobe.serialization.json.JSON;
import com.xy.util.Base64;

import flash.utils.ByteArray;


public class GoodsVo {
    public var id : int;
    public var sbn : String;
    public var name : String;
    public var weight : Number;
    public var type : String;
    public var info : String;

    public function copyFrom(source : GoodsVo) : void {
        id = source.id;
        sbn = source.sbn;
        name = source.name;
        weight = source.weight;
        type = source.type;
        info = source.info;
    }

    public function clone() : GoodsVo {
        var vo : GoodsVo = new GoodsVo();
        vo.copyFrom(this);

        return vo;
    }

    /**
     * [id, name, description, weight, SBNId]
     * @param data
     */
    public static function fromStr(data : String) : GoodsVo {
        var ba : ByteArray = Base64.decode(data);
        ba.uncompress();
        ba.position = 0;
        var json : String = ba.readUTFBytes(ba.bytesAvailable);
        var arr : Array = JSON.decode(json);
        arr = arr[0];
        return fromArr(arr);
    }

    public static function fromArr(arr : Array) : GoodsVo {
        var vo : GoodsVo = new GoodsVo();
        vo.id = int(arr[0]);
        vo.name = arr[1];
        vo.info = arr[2];
        vo.weight = Number(arr[3]);
        vo.sbn = arr[4];
        vo.type = arr[5];

        return vo;
    }
}
}
