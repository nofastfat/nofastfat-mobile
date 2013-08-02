package com.xy.model {

public class Purview {
    //是否允许添加用户
    public static function canAddUser(type : int) : Boolean {
        return type <= 2;
    }

    //是否允许查询用户
    public static function canQueryUser(type : int) : Boolean {
        return type <= 2;
    }

    //是否允许删除用户
    public static function canDeleteUser(type : int) : Boolean {
        return type <= 2;
    }

    //是否可以添加商品
    public static function canAddCommodity(type : int) : Boolean {
        return type <= 2;
    }

    //是否可以查询商品
    public static function canQueryCommodity(type : int) : Boolean {
        return true;
    }

    //是否可以删除商品
    public static function canDeleteCommodity(type : int) : Boolean {
        return type <= 2;
    }

    //是否可以修改商品
    public static function canModifyCommodity(type : int) : Boolean {
        return type <= 2;
    }

    //是否可以添加快递
    public static function canAddCourier(type : int) : Boolean {
        return type <= 2;
    }

    //是否可以添加快递
    public static function canDelCourier(type : int) : Boolean {
        return type <= 2;
    }

    //是否可以入库
    public static function canPurchase(type : int) : Boolean {
        return type <= 2;
    }

    //是否可以查看进货价
    public static function canSeeRetailPrice(type : int) : Boolean {
        return type <= 2;
    }

    //是否可以查看出库日志
    public static function canQuerySoldLog(type : int) : Boolean {
        return type <= 2;
    }

    //是否可以重置密码
    public static function canModifyPwd(type : int) : Boolean {
        return type <= 2;
    }
}
}
