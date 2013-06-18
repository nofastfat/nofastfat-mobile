<?php
	//addCommodity.php?self=admin&selfPwd=admin&name=测试商品&description=说明&weight=1.9&SBNId=1
	header("Content-Type: text/html; charset=UTF-8");
	
	$self = getParam("self");
	$selfPwd = getParam("selfPwd");
	$name = getParam("name");
	$description = getParam("description");
	$weight = getParam("weight");
	$SBNId = getParam("SBNId");
	
	if(empty($self) ||empty($selfPwd) || empty($name)){
		echo makeJsonRs(false, "添加新商品失败，参数不正确");
		closeConn($db);
		exit;
	}
	
	$sql = "select type from UsersTb where id='".$self."' and pwd='".$selfPwd."';";
	$rs = query($db, $sql);

	if(count($rs) == 0){
		echo makeJsonRs(false, "添加新商品失败，用户不存在");
		closeConn($db);
		exit;
	}else{
		if(!Tools::canAddCommodity($rs[0][0])){
			echo makeJsonRs(false, "添加新商品失败，权限不足");
			closeConn($db);
			exit;
		}
	}

	if(empty($description)){
		$description = "";
	}
	if(empty($weight)){
		$weight = 0;
	}
	if(empty($SBNId)){
		$SBNId = "0";
	}

	$sql = "insert into Commodity(name, description, weight, SBNId) values('$name', '$description', $weight, '$SBNId')";
	$rs = execute($db, $sql);
	if($rs == 1){
		echo makeJsonRs(true, "");
	}else{
		echo makeJsonRs(false, "添加新商品失败");
	}

	closeConn($db);

?>