package com.xy.model.enum {

public class InvoicingDataNotice {
    /**
     * 商品列表更新
     */
    public static const GOODS_LIST_UPDATE : String = "GOODS_LIST_UPDATE";
    
    /**
     * 快递列表更新
     */
    public static const COURIER_LIST_UPDATE : String = "COURIER_LIST_UPDATE";
	
	/**
	 * 库存列表更新 
	 */    
	public static const STORE_LIST_UPDATE : String = "STORE_LIST_UPDATE";
	
	/**
	 * 用户列表更新 
	 */    
	public static const USER_LIST_UPDATE : String = "USER_LIST_UPDATE";
	
	/**
	 * 出库日志列表更新 
	 */    
	public static const SOLD_LOG_UPDATE : String = "SOLD_LOG_UPDATE";
	/**
	 * 入库日志列表更新 
	 */    
	public static const PURCHASE_LOG_UPDATE : String = "PURCHASE_LOG_UPDATE";

}
}
