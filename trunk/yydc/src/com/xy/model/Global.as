package com.xy.model {
	import com.xy.comunication.Protocal;
	import com.xy.comunication.SAMFHttp;
	import com.xy.util.Base64;
	
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.patterns.facade.Facade;

/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2014-2-18 下午3:36:12
 **/
public class Global {
	public static const EVENT_SHOP_UPDATE : String="EVENT_SHOP_UPDATE";
	public static const EVENT_USER_UPDATE : String="EVENT_USER_UPDATE";
	public static const EVENT_MY_GOODS_UPDATE : String="EVENT_MY_GOODS_UPDATE";
	
	public static var root : yydc;
	
	public static var me : UserDTO;
	
	/**
	 * 是否是管理员 
	 */	
	public static var isAdmin:Boolean = false;
	
	public static var shops : Array = [];
	public static var users : Array = [];
	public static var myGoods : ReservationDetailDTO;
	
	public static function get userName():String{
		if(me != null){
			return me.name
		}
		
		return "";
	}
	
	public static function refreshShop():void{
		var pt : String;
		if(isAdmin){
			pt = Protocal.ADMIN_RESTAURANT_LIST;
		}else{
			pt = Protocal.RESTAURANT_LIST;
		}
		new SAMFHttp(pt, function(list : Array):void{
			shops = list;
			if(shops == null){
				shops = [];
			}
			
			Facade.getInstance().sendNotification(EVENT_SHOP_UPDATE);
		});
	}
	
	public static function refreshUserList():void{
		new SAMFHttp(Protocal.ADMIN_USER_LIST, function(list : Array):void{
			users = list;
			if(users == null){
				users = [];
			}
			
			Facade.getInstance().sendNotification(EVENT_USER_UPDATE);
		});
	}
	
	public static function refreshMyGoods():void{
		new SAMFHttp(Protocal.DETAIL_MY, function(rs : ReservationDetailDTO):void{
			myGoods = rs;
			Facade.getInstance().sendNotification(EVENT_MY_GOODS_UPDATE);
		});
	}
	
	public static function base64(str : String):String{
		var ba : ByteArray = new ByteArray();
		ba.writeUTF(str);
		return Base64.encode(ba);
	}
}
}
