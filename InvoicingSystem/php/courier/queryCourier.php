<?php
	header("Content-Type: text/html; charset=UTF-8");
	
	$self = getParam("self");
	$selfPwd = getParam("selfPwd");
	
	if(empty($self) ||empty($selfPwd)){
		echo makeJsonRs(false, "查询快递失败，参数不正确");
		closeConn($db);
		exit;
	}
	
	$sql = "select type from UsersTb where id='".$self."' and pwd='".$selfPwd."';";
	$rs = query($db, $sql);

	if(count($rs) == 0){
		echo makeJsonRs(false, "查询快递失败，用户不存在");
		closeConn($db);
		exit;
	}

	$sql = "select * from SendCompany";
	$rs = query($db, $sql);
	echo makeJsonRs(true, $rs);

	closeConn($db);
?>