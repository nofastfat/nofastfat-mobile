<?php
	//deleteCommodity.php?self=admin&selfPwd=admin&delId=2
	header("Content-Type: text/html; charset=UTF-8");
	
	$self = getParam("self");
	$selfPwd = getParam("selfPwd");
	$delId = getParam("delId");
	
	if(empty($self) ||empty($selfPwd) || empty($delId)){
		echo makeJsonRs(false, "删除商品失败，参数不正确");
		closeConn($db);
		exit;
	}

	$sql = "select type from UsersTb where id='".$self."' and pwd='".$selfPwd."';";
	$rs = query($db, $sql);

	if(count($rs) == 0){
		echo makeJsonRs(false, "删除商品失败，当前账户不存在");
		closeConn($db);
		exit;
	}else{
		if(!Tools::canDeleteCommodity($rs[0][0])){
			echo makeJsonRs(false, "删除商品失败，权限不足");
			closeConn($db);
			exit;
		}
	}
	
	$sql = "delete from Commodity where id=$delId";
	$rs = execute($db, $sql);
	if($rs == 1){
		echo makeJsonRs(true, "删除商品成功");
	}else{
		echo makeJsonRs(false, "删除商品失败,商品不存在");
	}
	closeConn($db);

?>