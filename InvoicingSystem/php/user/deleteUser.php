<?php
	//deleteUser.php?self=admin&selfPwd=admin&delId=test
	header("Content-Type: text/html; charset=UTF-8");
	
	$self = getParam("self");
	$selfPwd = getParam("selfPwd");
	$delId = getParam("delId");
	
	if(empty($self) ||empty($selfPwd) || empty($delId)){
		echo makeJsonRs(false, "删除用户失败，参数不正确");
		closeConn($db);
		exit;
	}

	$sql = "select type from UsersTb where id='".$self."' and pwd='".$selfPwd."';";
	$rs = query($db, $sql);

	if(count($rs) == 0){
		echo makeJsonRs(false, "删除用户失败，当前账户不存在");
		closeConn($db);
		exit;
	}
	$sql = "select type from UsersTb where id='".$delId."';";
	$rs1 = query($db, $sql);
	if(count($rs1) == 0){
		echo makeJsonRs(false, "删除用户失败，用户不存在");
		closeConn($db);
		exit;
	}else{
		if($rs1[0][0] <= $rs[0][0] || !Tools::canDeleteUser($rs[0][0])){
			echo makeJsonRs(false, "删除用户失败，权限不足");
			closeConn($db);
			exit;
		}
	}

	$sql = "delete from UsersTb where id='".$delId."'";
	$rs = execute($db, $sql);
	if($rs == 1){
		echo makeJsonRs(true, "删除用户成功");
	}else{
		echo makeJsonRs(false, "删除用户失败");
	}
	closeConn($db);

?>