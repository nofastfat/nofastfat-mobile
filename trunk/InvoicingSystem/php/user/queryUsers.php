<?php
	//queryUsers.php?self=admin&selfPwd=admin
	//{"status":true,"data":[{"test3","3","admin"},{"test","2","admin"}]}
	header("Content-Type: text/html; charset=UTF-8");
	
	$self = getParam("self");
	$selfPwd = getParam("selfPwd");

	if(empty($self) ||empty($selfPwd)){
		echo makeJsonRs(false, "查询用户，参数不正确");
		closeConn($db);
		exit;
	}

	$sql = "select type from UsersTb where id='".$self."' and pwd='".$selfPwd."';";
	$rs = query($db, $sql);

	if(count($rs) == 0){
		echo makeJsonRs(false, "查询用户失败，账户不存在");
		closeConn($db);
		exit;
	}else{
		if(!Tools::canQueryUser($rs[0][0])){
			echo makeJsonRs(false, "查询用户失败，权限不足");
			closeConn($db);
			exit;
		}
	}

	$sql = "select id,type,creator from UsersTb where id!='".$self."' and type>".$rs[0][0];
	$rs = query($db, $sql);
	$rs = json_encode($rs);
	$rs = gzcompress($rs, 9);
	$rs = base64_encode($rs);
	echo makeJsonRs(true, $rs);
?>