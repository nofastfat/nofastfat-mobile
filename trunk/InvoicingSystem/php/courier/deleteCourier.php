<?php
	header("Content-Type: text/html; charset=UTF-8");
	
	$self = getParam("self");
	$selfPwd = getParam("selfPwd");
	$id = getParam("delId");
	
	if(empty($self) ||empty($selfPwd) || empty($id)){
		echo makeJsonRs(false, "删除快递失败，参数不正确");
		closeConn($db);
		exit;
	}
	
	$sql = "select type from UsersTb where id='".$self."' and pwd='".$selfPwd."';";
	$rs = query($db, $sql);

	if(count($rs) == 0){
		echo makeJsonRs(false, "删除快递失败，用户不存在");
		closeConn($db);
		exit;
	}else{
		if(!Tools::canDelCourier($rs[0][0])){
			echo makeJsonRs(false, "删除快递失败，权限不足");
			closeConn($db);
			exit;
		}
	}

	$sql = "delete from SendCompany where id=$id";
	$rs = execute($db, $sql);
	if($rs == 1){
		echo makeJsonRs(true, "删除快递成功");
	}else{
		echo makeJsonRs(false, "删除快递失败");
	}

	closeConn($db);
?>