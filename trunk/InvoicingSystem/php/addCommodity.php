<?php
	header("Content-Type: text/html; charset=UTF-8");
	require_once "connection.php";
	$self = getParam("self");
	$selfPwd = getParam("selfPwd");
	$newId = getParam("newId");
	$newPwd = getParam("newPwd");
	$newType = getParam("newType");
	
	if(empty($self) ||empty($selfPwd) || empty($newId) || empty($newPwd)|| empty($newType)){
		echo makeJsonRs(false, "添加新用户失败，参数不正确");
		exit;
	}
?>