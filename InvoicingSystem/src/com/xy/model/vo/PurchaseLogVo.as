package com.xy.model.vo {
import com.xy.util.STool;


public class PurchaseLogVo {
    public var id : int;
    public var logTime : Number;
    public var commonditySBN : String;
    public var commondityName : String;
    public var num : int;
    public var realRetailPrice : Number = 0;
    public var madeTime : Number;
    public var operator : String;


    private var _logTimeStr : String;
    private var _madeTimeStr : String;

    public function get logTimeStr() : String {
        if (_logTimeStr != null) {
            return _logTimeStr;
        }

        var date : Date = new Date();
        date.setTime(logTime);
        var str : String = "{0}年{1}月{2}日";
        _logTimeStr = STool.format(str, date.fullYear, (date.month + 1), date.date);
        return _logTimeStr;
    }

    public function get madeTimeStr() : String {
        if (_madeTimeStr != null) {
            return _madeTimeStr;
        }

        var date : Date = new Date();
        date.setTime(madeTime);
        var str : String = "{0}年{1}月{2}日";
        _madeTimeStr = STool.format(str, date.fullYear, (date.month + 1), date.date);
        return _madeTimeStr;
    }

    public static function fromArr(arr : Array) : PurchaseLogVo {
        var vo : PurchaseLogVo = new PurchaseLogVo();
        vo.id = int(arr[0]);
        vo.logTime = Number(arr[1]);
        vo.commonditySBN = arr[2];
        vo.commondityName = arr[3];
        vo.num = int(arr[4]);

        if (arr.length > 7) {
            vo.realRetailPrice = Number(arr[5]);
            vo.madeTime = Number(arr[6]);
            vo.operator = arr[7];
        } else {
            vo.madeTime = Number(arr[5]);
            vo.operator = arr[6];
        }

        return vo;
    }
}
}
