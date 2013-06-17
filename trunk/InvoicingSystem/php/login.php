<?php
	header("Content-Type: text/html; charset=UTF-8");
	require_once "connection.php";
	$uid = $_GET["uid"];
	$pwd = $_GET["pwd"];
	
	if(empty($uid) || empty($pwd)){
		echo "参数不正确，登录失败";
		exit;
	}
	
	$sql = "select type from UsersTb where id='".$uid."' and pwd='".$pwd."';";
	$rs = query($db, $sql);
	if(count($rs) == 0){
		echo "登录失败";
	}else{
		echo "true|".$rs[0][0];
	}
?>