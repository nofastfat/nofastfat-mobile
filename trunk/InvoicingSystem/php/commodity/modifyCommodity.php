<?php
	//modifyCommodity.php?self=admin&selfPwd=admin&modifyId=5&name=123&weight=10
	header("Content-Type: text/html; charset=UTF-8");
	
	$self = getParam("self");
	$selfPwd = getParam("selfPwd");
	$modifyId = getParam("modifyId");
	$name = getParam("name");
	$description = getParam("description");
	$weight = getParam("weight");
	$SBNId = getParam("SBNId");

	if(empty($self) ||empty($selfPwd) || empty($modifyId)){
		echo makeJsonRs(false, "修改商品失败，参数不正确");
		closeConn($db);
		exit;
	}
	
	if(empty($name) &&empty($description) && empty($weight)&& empty($SBNId)){
		echo makeJsonRs(false, "修改商品失败，参数异常");
		closeConn($db);
		exit;
	}
	$sql = "select type from UsersTb where id='".$self."' and pwd='".$selfPwd."';";
	$rs = query($db, $sql);

	if(count($rs) == 0){
		echo makeJsonRs(false, "修改商品失败，当前账户不存在");
		closeConn($db);
		exit;
	}else{
		if(!Tools::canModifyCommodity($rs[0][0])){
			echo makeJsonRs(false, "修改商品失败，权限不足");
			closeConn($db);
			exit;
		}
	}

	$sql = "update Commodity set ";
	if(!empty($name)){
		$sql .= "name=$name,";
	}
	if(!empty($description)){
		$sql .= "description=$description,";
	}
	if(!empty($weight)){
		$sql .= "weight=$weight,";
	}
	if(!empty($SBNId)){
		$sql .= "SBNId=$SBNId,";
	}

	$sql = substr($sql, 0, strlen($sql)-1);
	$sql .= " where id=$modifyId";
	$rs = execute($db, $sql);
	if($rs == 1){
		echo makeJsonRs(true, "true");
	}else{
		echo makeJsonRs(false, "修改商品成功");
	}
	closeConn($db);

?>