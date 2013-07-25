<?php
	//?uid=admin&pwd=admin
	header("Content-Type: text/html; charset=UTF-8");
	
	$uid = getParam("uid");
	$pwd = getParam("pwd");
	
	if(empty($uid) || empty($pwd)){
		echo makeJsonRs(false, "参数不正确，登录失败");
		closeConn($db);
		exit;
	}
	
	$sql = "select type from UsersTb where id='".$uid."' and pwd='".$pwd."';";
	$rs = query($db, $sql);
	if(count($rs) == 0){
		echo makeJsonRs(false, "登录失败,用户名或密码不正确");
	}else{
		echo makeJsonRs(true, $rs[0][0]);
	}
	
	closeConn($db);
?>