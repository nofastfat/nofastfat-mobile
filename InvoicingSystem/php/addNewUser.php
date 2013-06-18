<?php
	header("Content-Type: text/html; charset=UTF-8");
	require_once "connection.php";
	$self = $_GET["self"];
	$selfPwd = $_GET["selfPwd"];
	$newId = $_GET["newId"];
	$newPwd = $_GET["newPwd"];
	$newType = $_GET["newType"];
	
	if(empty($self) ||empty($selfPwd) || empty($newId) || empty($newPwd)|| empty($newType)){
		echo "添加新用户失败，参数不正确";
		exit;
	}

	$sql = "select type from UsersTb where id='".$self."' and pwd='".$selfPwd."';";
	$rs = query($db, $sql);

	if(count($rs) == 0){
		echo "添加新用户失败，权限不足";
		exit;
	}else{
		if($rs[0][0] >= $newType){
			echo "添加新用户失败，权限不足";
			exit;
		}
	}
	$sql = "select count(*) from UsersTb where id='".$newId."';";
	$rs = query($db, $sql);
	if($rs[0][0] >= 1){
		echo "添加新用户失败，用户名已存在";
		exit;
	}

	$sql = "insert into UsersTb (id, pwd, type, creator) values ('".$newId."', '".$newPwd."', ".$newType.", '".$self."');";
	$rs = execute($db, $sql);
	if($rs == 1){
		echo "true";
	}else{
		echo "添加新用户失败";
	}

?>