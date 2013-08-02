<?php
	//?self=admin&selfPwd=admin&uid=admin
	header("Content-Type: text/html; charset=UTF-8");
	
	$self = getParam("self");
	$selfPwd = getParam("selfPwd");
	$uid = getParam("uid");
	
	if(empty($self) ||empty($selfPwd) || empty($uid)){
		echo makeJsonRs(false, "参数不正确");
		closeConn($db);
		exit;
	}
	
	$sql = "select type from UsersTb where id='".$self."' and pwd='".$selfPwd."';";
	$rs = query($db, $sql);

	if(count($rs) == 0){
		echo makeJsonRs(false, "重置密码失败，当前账户不存在");
		closeConn($db);
		exit;
	}
	
	
	$sql = "select type from UsersTb where id='".$uid."';";
	$rs1 = query($db, $sql);
	if(count($rs1) == 0){
		echo makeJsonRs(false, "重置密码失败，用户不存在");
		closeConn($db);
		exit;
	}else{
		if($rs1[0][0] <= $rs[0][0] || !Tools::canModifyPwd($rs[0][0])){
			echo makeJsonRs(false, "重置密码失败，权限不足");
			closeConn($db);
			exit;
		}
	}
	
	
	$sql = "update UsersTb set pwd='21218cca77804d2ba1922c33e0151105' where id='$uid'";
	$rs = execute($db, $sql);
	if($rs == 1){
		echo makeJsonRs(true, "重置密码成功");
	}else{
		echo makeJsonRs(false, "重置密码失败");
	}
	closeConn($db);

?>