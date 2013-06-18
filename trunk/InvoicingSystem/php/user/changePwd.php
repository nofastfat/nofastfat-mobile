<?php
	//?uid=admin&oldPwd=admin&newPwd=fff
	header("Content-Type: text/html; charset=UTF-8");
	
	$uid = getParam("uid");
	$oldPwd = getParam("oldPwd");
	$newPwd = getParam("newPwd");
	
	if(empty($uid) || empty($oldPwd) || empty($newPwd)){
		echo makeJsonRs(false, "参数不正确");
		closeConn($db);
		exit;
	}
	
	$sql = "update UsersTb set pwd='".$newPwd."' where id='".$uid."' and pwd='".$oldPwd."'";
	$rs = execute($db, $sql);
	if($rs == 1){
		echo makeJsonRs(true, "true");
	}else{
		echo makeJsonRs(false, "修改密码失败");
	}
	closeConn($db);

?>