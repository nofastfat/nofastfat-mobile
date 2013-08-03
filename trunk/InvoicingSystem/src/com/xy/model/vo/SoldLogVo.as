package com.xy.model.vo {
	import com.xy.util.STool;
	

public class SoldLogVo {
    public var id : int;
    public var soldTime : Number;
    public var clientName : String;
    public var SBN : String;
    public var name : String;
    public var num : String;
    public var totalWeight : String;
    public var soldAddress : String;
    public var senderCompany : String;
    public var sendId : String;
    public var sendPrice : Number;
    public var clientPay : Number;
    public var profit : Number = 0;
    
    private var _soldTimeStr : String;
    
    public function get soldTimeStr():String{
		if(_soldTimeStr != null){
			return _soldTimeStr;
		}
		
		var date : Date = new Date();
		date.setTime(soldTime);
		var str : String = "{0}年{1}月{2}日";
		_soldTimeStr = STool.format(str, date.fullYear, (date.month+1), date.date);
		return _soldTimeStr;
	}
    
    /**
     * id,soldTime,clientName,SBN,name,num,totalWeight,soldAddress,senderCompany,sendId,sendPrice,clientPay 
     * @param arr
     * @return 
     */    
    public static function fromArr(arr : Array) : SoldLogVo {
        var vo : SoldLogVo = new SoldLogVo();
        vo.id = int(arr[0]);
       	vo.soldTime = arr[1];
       	vo.clientName = arr[2];
       	vo.SBN = arr[3];
       	vo.name = arr[4];
       	vo.num = arr[5];
       	vo.totalWeight = arr[6];
       	vo.soldAddress = arr[7];
       	vo.senderCompany = arr[8];
       	vo.sendId = arr[9];
       	vo.sendPrice = arr[10];
       	vo.clientPay = arr[11];
       	
       	if(arr.length > 12){
       		vo.profit = arr[12];
       	}

        return vo;
    }
}
}
