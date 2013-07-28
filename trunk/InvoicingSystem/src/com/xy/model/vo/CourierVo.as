package com.xy.model.vo {
import com.adobe.serialization.json.JSON;
import com.xy.util.Base64;

import flash.utils.ByteArray;


public class CourierVo {
    public var id : int;
    public var name : String;

    public function copyFrom(source : CourierVo) : void {
        id = source.id;
        name = source.name;
    }

    public function clone() : CourierVo {
        var vo : CourierVo = new CourierVo();
        vo.copyFrom(this);

        return vo;
    }

    /**
     * [id, name]
     * @param data
     */
    public static function fromStr(data : String) : CourierVo {
        var ba : ByteArray = Base64.decode(data);
        ba.uncompress();
        ba.position = 0;
        var json : String = ba.readUTFBytes(ba.bytesAvailable);
        var arr : Array = JSON.decode(json);
        arr = arr[0];
        
        return fromArr(arr);
    }
    
    public static function fromArr(arr : Array):CourierVo{
        var vo : CourierVo = new CourierVo();
        vo.id = int(arr[0]);
        vo.name = arr[1];
        return vo;
    }
}
}
