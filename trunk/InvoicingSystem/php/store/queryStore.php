<?php
	header("Content-Type: text/html; charset=UTF-8");
	$self = getParam("self");
	$selfPwd = getParam("selfPwd");
	
	if(empty($self) ||empty($selfPwd)){
		echo makeJsonRs(false, "查询库存失败，参数不正确");
		closeConn($db);
		exit;
	}

	$sql = "select type from UsersTb where id='".$self."' and pwd='".$selfPwd."';";
	$rs = query($db, $sql);

	if(count($rs) == 0){
		echo makeJsonRs(false, "查询库存失败，账户不存在");
		closeConn($db);
		exit;
	}

	if(Tools::canSeeRetailPrice($rs[0][0])){
		$sql = "select * from Store";
	}else{
		$sql = "select id,SBN,name,num,madeTime,operator,storeTime from Store";
	}
	$rs = query($db, $sql);
	$rs = json_encode($rs);
	$rs = gzcompress($rs, 9);
	$rs = base64_encode($rs);

	echo makeJsonRs(true, $rs);
	closeConn($db);

?>