package com.xy.model.vo {
import com.adobe.serialization.json.JSON;
import com.xy.model.enum.AccountType;
import com.xy.util.Base64;

import flash.utils.ByteArray;

public class AccountVo {

    public var id : String;

    public var type : int;

    public var creator : String;

    private var _typeName : String;

    /**
     * [id, name, description, weight, SBNId]
     * @param data
     */
    public static function fromStr(data : String) : AccountVo {
        var ba : ByteArray = Base64.decode(data);
        ba.uncompress();
        ba.position = 0;
        var json : String = ba.readUTFBytes(ba.bytesAvailable);
        var arr : Array = JSON.decode(json);
        arr = arr[0];
        return fromArr(arr);
    }

    public static function fromArr(arr : Array) : AccountVo {
        var vo : AccountVo = new AccountVo();
        vo.id = arr[0];
        vo.type = int(arr[1]);
        vo.creator = arr[2];
        return vo;
    }

    public function get typeName() : String {
        if (_typeName == null) {
            _typeName = AccountType.ToString(type);
        }

        return _typeName;
    }
}
}
