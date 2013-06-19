<?php
	//queryCommodity.php?self=admin&selfPwd=admin
	//{"status":true,"data":[{"0":1,"id":1,"1":"\u6d4b\u8bd5\u5546\u54c1","name":"\u6d4b\u8bd5\u5546\u54c1","2":"\u8bf4\u660e","description":"\u8bf4\u660e","3":1.9,"weight":1.9,"4":"1","SBNId":"1"},{"0":2,"id":2,"1":"\u6d4b\u8bd5\u5546\u54c1","name":"\u6d4b\u8bd5\u5546\u54c1","2":"\u8bf4\u660e","description":"\u8bf4\u660e","3":1.9,"weight":1.9,"4":"1","SBNId":"1"},{"0":3,"id":3,"1":"\u6d4b\u8bd5\u5546\u54c1","name":"\u6d4b\u8bd5\u5546\u54c1","2":"\u8bf4\u660e","description":"\u8bf4\u660e","3":1.9,"weight":1.9,"4":"1","SBNId":"1"},{"0":4,"id":4,"1":"\u6d4b\u8bd5\u5546\u54c1","name":"\u6d4b\u8bd5\u5546\u54c1","2":"\u8bf4\u660e","description":"\u8bf4\u660e","3":1.9,"weight":1.9,"4":"1","SBNId":"1"},{"0":5,"id":5,"1":"\u6d4b\u8bd5\u5546\u54c1","name":"\u6d4b\u8bd5\u5546\u54c1","2":null,"description":null,"3":0,"weight":0,"4":"0","SBNId":"0"}]}
	header("Content-Type: text/html; charset=UTF-8");
	
	$self = getParam("self");
	$selfPwd = getParam("selfPwd");

	if(empty($self) ||empty($selfPwd)){
		echo makeJsonRs(false, "查询商品列表失败，参数不正确");
		closeConn($db);
		exit;
	}

	$sql = "select type from UsersTb where id='".$self."' and pwd='".$selfPwd."';";
	$rs = query($db, $sql);

	if(count($rs) == 0){
		echo makeJsonRs(false, "查询商品列表失败，账户不存在");
		closeConn($db);
		exit;
	}else{
		if(!Tools::canQueryCommodity($rs[0][0])){
			echo makeJsonRs(false, "查询商品列表失败，权限不足");
			closeConn($db);
			exit;
		}
	}

	$sql = "select * from Commodity";
	$rs = query($db, $sql);
	$rs = json_encode($rs);
	$rs = gzcompress($rs, 9);
	$rs = base64_encode($rs);
	echo makeJsonRs(true, $rs);
?>