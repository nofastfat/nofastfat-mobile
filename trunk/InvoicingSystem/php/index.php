<?php
	header("Content-Type: text/html; charset=UTF-8");
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
		//{"status":true,"data":[{id, type, creator}, {id, type, creator}, ...]}
		"queryUsers" => "user/queryUsers.php",
		

		
		//添加商品
		//?method=addCommodity&self=admin&selfPwd=admin&name=测试商品&description=说明&weight=1.9&SBNId=1
		"addCommodity"	  => "commodity/addCommodity.php",

		//删除商品
		//?method=deleteCommodity&self=admin&selfPwd=admin&delId=2
		"deleteCommodity" => "commodity/deleteCommodity.php",

		//修改商品
		//?method=modifyCommodity&self=admin&selfPwd=admin&modifyId=5&name=123&weight=10
		"modifyCommodity" => "commodity/modifyCommodity.php",

		//查询商品列表
		//?method=queryCommodity&self=admin&selfPwd=admin
		//{"status":true,"data":[{id, name, description, weight, SBNId}, {id, name, description, weight, SBNId}, ...]}
		"queryCommodity"  => "commodity/queryCommodity.php",
		

		//添加快递
		//?method=addCourier&self=admin&selfPwd=admin&name=韵达
		"addCourier"	 => "courier/addCourier.php",

		//删除快递
		//?method=deleteCourier&self=admin&selfPwd=admin&id=2
		"deleteCourier"  => "courier/deleteCourier.php",

		//查询快递
		//?method=queryCourier&self=admin&selfPwd=admin
		//{"status":true,"data":[{id, name}, {id, name}, ...]}
		"queryCourier"   => "courier/queryCourier.php",


	);

	if(!isset($map[$method])){
		echo "{status:false, data:'unknow method!'}";
		exit;
	}
	
	require_once "core/connection.php";
	require_once "core/purview.php";
	require_once $map[$method];
?>