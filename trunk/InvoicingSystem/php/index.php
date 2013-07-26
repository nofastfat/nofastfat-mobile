<?php
	header("Content-Type: text/html; charset=UTF-8");
	date_default_timezone_set('PRC');  
	if(!isset($_GET["method"])){
		echo "{status:false, data:'missing method!'}";
		exit;
	}
	$method = $_GET["method"];
	$map = array(
		//添加新用户
		//?method=addNewUser&self=admin&selfPwd=admin&newId=test3&newPwd=test3&newType=3
		"addNewUser" => "user/addNewUser.php",
		
		//修改密码
		//?method=changePwd&uid=admin&oldPwd=admin&newPwd=fff
		"changePwd"	 => "user/changePwd.php",

		//删除用户
		//?method=deleteUser&self=admin&selfPwd=admin&delId=test
		"deleteUser" => "user/deleteUser.php",

		//登录
		//?method=login&uid=admin&pwd=admin
		"login"		 => "user/login.php",

		//账户查询
		//?method=queryUsers&self=admin&selfPwd=admin
		//结果中的data为字符串，需要先反转BASE64，再zlib解压缩，才能还原为json
		//{"status":true,"data":[[id, type, creator], [id, type, creator], ...]}
		"queryUsers" => "user/queryUsers.php",
		

		
		//添加商品
		//?method=addCommodity&self=admin&selfPwd=admin&name=测试商品&description=说明&weight=1.9&SBNId=1&type=营养品
		"addCommodity"	  => "commodity/addCommodity.php",

		//删除商品
		//?method=deleteCommodity&self=admin&selfPwd=admin&delId=2
		"deleteCommodity" => "commodity/deleteCommodity.php",

		//修改商品
		//?method=modifyCommodity&self=admin&selfPwd=admin&modifyId=12&name=测试商品&description=说明&weight=1.9&SBNId=1&type=营养品
		"modifyCommodity" => "commodity/modifyCommodity.php",

		//查询商品列表
		//?method=queryCommodity&self=admin&selfPwd=admin
		//结果中的data为字符串，需要先反转BASE64，再zlib解压缩，才能还原为json
		//{"status":true,"data":[[id, name, description, weight, SBNId, type], [id, name, description, weight, SBNId, type], ...]}
		"queryCommodity"  => "commodity/queryCommodity.php",
		


		//添加快递
		//?method=addCourier&self=admin&selfPwd=admin&name=韵达
		"addCourier"	 => "courier/addCourier.php",

		//删除快递
		//?method=deleteCourier&self=admin&selfPwd=admin&id=2
		"deleteCourier"  => "courier/deleteCourier.php",

		//查询快递
		//?method=queryCourier&self=admin&selfPwd=admin
		//结果中的data为字符串，需要先反转BASE64，再zlib解压缩，才能还原为json
		//{"status":true,"data":[[id, name], [id, name], ...]}
		"queryCourier"   => "courier/queryCourier.php",

		

		//入库
		//?method=purchase&self=admin&selfPwd=admin&commondityName=lala&num=10&realRetailPrice=10.2
		"purchase"			  => "store/purchase.php",

		//出库
		//?method=sold&self=admin&selfPwd=admin&storeId=1,2&clientName=gaga&num=2,3&totalWeight=20.2&clientPay=312&sendPrice=17
		"sold"				  => "store/sold.php",

		//查询利润
		//?method=queryProfit&self=admin&selfPwd=admin&
		"queryProfit"		  => "store/queryProfit.php",

		//查询库存
		//?method=queryStore&self=admin&selfPwd=admin
		//结果中的data为字符串，需要先反转BASE64，再zlib解压缩，才能还原为json
		//拥有查询进货价的权限：{"status":true,"data":[[id,SBN,name,num,madeTime,operator,storeTime, retailPrice], [id,SBN,name,num,madeTime,operator,storeTime, retailPrice], ...]}
		//没有查询进货价的权限：{"status":true,"data":[[id,SBN,name,num,madeTime,operator,storeTime], [id,SBN,name,num,madeTime,operator,storeTime], ...]}
		"queryStore"		  => "store/queryStore.php",

		//查询入库日志
		//?method=queryPurchaseLog&self=admin&selfPwd=admin
		"queryPurchaseLog"    => "store/queryPurchaseLog.php",

		//查询出货日志
		//?method=querySoldLog&self=admin&selfPwd=admin
		"querySoldLog"		  => "store/querySoldLog.php"

	);

	if(!isset($map[$method])){
		echo "{status:false, data:'unknow method!'}";
		exit;
	}
	
	require_once "core/connection.php";
	require_once "core/purview.php";
	require_once $map[$method];
?>