package com.xy.model.vo {
	import com.adobe.serialization.json.JSON;
	import com.xy.util.Base64;
	
	import flash.utils.ByteArray;
	

public class StoreVo {
    public var id : int;
    public var SBN : String;
    public var name : String;
    public var num : int;
    public var madeTime : Number = 0;
    public var operator : String;
    public var storeTime : Number = 0;
    public var retailPrice : Number = 0;

    public function copyFrom(source : StoreVo) : void {
        id = source.id;
        SBN = source.SBN;
        name = source.name;
        num = source.num;
        madeTime = source.madeTime;
        operator = source.operator;
        storeTime = source.storeTime;
        retailPrice = source.retailPrice;
    }

    public function clone() : StoreVo {
        var vo : StoreVo = new StoreVo();
        vo.copyFrom(this);

        return vo;
    }

    /**
     * [id,SBN,name,num,madeTime,operator,storeTime, retailPrice]
     * @param arr
     * @return
     *
     */
    public static function fromStr(data : String) : StoreVo {
        var ba : ByteArray = Base64.decode(data);
        ba.uncompress();
        ba.position = 0;
        var json : String = ba.readUTFBytes(ba.bytesAvailable);
        var arr : Array = JSON.decode(json);
        arr = arr[0];
        var vo : StoreVo = new StoreVo();
        vo.id = arr[0];
        vo.SBN = arr[1];
        vo.name = arr[2];
        vo.num = arr[3];
        vo.madeTime = arr[4];
        vo.operator = arr[5];
        vo.storeTime = arr[6];

        if (arr.length == 8) {
            vo.retailPrice = arr[7];
        }
        return vo;
    }
}
}
