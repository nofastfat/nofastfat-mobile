<?php
	header("Content-Type: text/html; charset=UTF-8");
	require_once "connection.php";
	$uid = $_GET["uid"];
	$oldPwd = $_GET["oldPwd"];
	$newPwd = $_GET["newPwd"];
	
	if(empty($uid) || empty($oldPwd) || empty($newPwd)){
		echo "参数不正确";
		exit;
	}
	
	$sql = "update UsersTb set pwd='".$newPwd."' where id='".$uid."' and pwd='".$oldPwd."'";
	$rs = execute($db, $sql);
	if($rs == 1){
		echo "true";
	}else{
		echo "修改密码失败";
	}

?>