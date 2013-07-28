<?php
	header("Content-Type: text/html; charset=UTF-8");
	
	$self = getParam("self");
	$selfPwd = getParam("selfPwd");
	$id = getParam("id");
	$name = getParam("name");
	
	if(empty($self) ||empty($selfPwd) || empty($name)|| empty($id)){
		echo makeJsonRs(false, "添加快递失败，参数不正确");
		closeConn($db);
		exit;
	}
	
	$sql = "select type from UsersTb where id='".$self."' and pwd='".$selfPwd."';";
	$rs = query($db, $sql);

	if(count($rs) == 0){
		echo makeJsonRs(false, "添加快递失败，用户不存在");
		closeConn($db);
		exit;
	}else{
		if(!Tools::canAddCourier($rs[0][0])){
			echo makeJsonRs(false, "添加快递失败，权限不足");
			closeConn($db);
			exit;
		}
	}

	$sql = "update SendCompany set name='$name' where id=$id";
	$rs = execute($db, $sql);
	if($rs == 1){
		echo makeJsonRs(true, "修改快递成功");
	}else{
		echo makeJsonRs(false, "修改快递失败");
	}

	closeConn($db);
?>