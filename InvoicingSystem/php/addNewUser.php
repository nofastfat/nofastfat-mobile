<?php
	//addNewUser.php?self=admin&selfPwd=admin&newId=test3&newPwd=test3&newType=3
	header("Content-Type: text/html; charset=UTF-8");
	require_once "connection.php";
	$self = getParam("self");
	$selfPwd = getParam("selfPwd");
	$newId = getParam("newId");
	$newPwd = getParam("newPwd");
	$newType = getParam("newType");
	
	
	if(empty($self) ||empty($selfPwd) || empty($newId) || empty($newPwd)|| empty($newType)){
		echo makeJsonRs(false, "添加新用户失败，参数不正确");
		closeConn($db);
		exit;
	}

	$sql = "select type from UsersTb where id='".$self."' and pwd='".$selfPwd."';";
	$rs = query($db, $sql);

	if(count($rs) == 0){
		echo makeJsonRs(false, "添加新用户失败，权限不足");
		closeConn($db);
		exit;
	}else{
		if($rs[0][0] >= $newType || !Tools::canAddUser($rs[0][0])){
			echo makeJsonRs(false, "添加新用户失败，权限不足");
			closeConn($db);
			exit;
		}
	}
	$sql = "select count(*) from UsersTb where id='".$newId."';";
	$rs = query($db, $sql);
	if($rs[0][0] >= 1){
		echo makeJsonRs(false, "添加新用户失败，用户名已存在");
		closeConn($db);
		exit;
	}

	$sql = "insert into UsersTb (id, pwd, type, creator) values ('".$newId."', '".$newPwd."', ".$newType.", '".$self."');";
	$rs = execute($db, $sql);
	if($rs == 1){
		echo makeJsonRs(true, "");
	}else{
		echo makeJsonRs(false, "添加新用户失败");
	}

	closeConn($db);
?>