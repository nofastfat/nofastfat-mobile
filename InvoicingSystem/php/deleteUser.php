<?php
	header("Content-Type: text/html; charset=UTF-8");
	require_once "connection.php";
	$self = $_GET["self"];
	$selfPwd = $_GET["selfPwd"];
	$delId = $_GET["delId"];
	
	if(empty($self) ||empty($selfPwd) || empty($delId)){
		echo "删除用户失败，参数不正确";
		exit;
	}

	$sql = "select type from UsersTb where id='".$self."' and pwd='".$selfPwd."';";
	$rs = query($db, $sql);

	if(count($rs) == 0){
		echo "删除用户失败，当前账户不存在";
		exit;
	}
	$sql = "select type from UsersTb where id='".$delId."';";
	$rs1 = query($db, $sql);
	if(count($rs1) == 0){
		echo "删除用户失败，用户不存在";
		exit;
	}else{
		if($rs1[0][0] <= $rs[0][0]){
			echo "删除用户失败，权限不足";
			exit;
		}
	}

	$sql = "delete from UsersTb where id='".$delId."'";
	$rs = execute($db, $sql);
	if($rs == 1){
		echo "true";
	}else{
		echo "删除用户失败";
	}

?>