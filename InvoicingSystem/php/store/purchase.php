<?php
	header("Content-Type: text/html; charset=UTF-8");
	
	$self = getParam("self");
	$selfPwd = getParam("selfPwd");
	$commonditySBN = getParam("commonditySBN");
	$commondityName = getParam("commondityName");
	$num = getParam("num");
	$realRetailPrice = getParam("realRetailPrice");
	$madeTime = getParam("madeTime");
	
	
	if(empty($self) ||empty($selfPwd) || empty($commondityName) || empty($num)|| empty($realRetailPrice)){
		echo makeJsonRs(false, "入库失败，参数不正确");
		closeConn($db);
		exit;
	}

	$sql = "select type from UsersTb where id='".$self."' and pwd='".$selfPwd."';";
	$rs = query($db, $sql);

	if(count($rs) == 0){
		echo makeJsonRs(false, "入库失败，账户不存在");
		closeConn($db);
		exit;
	}else{
		if(!Tools::canPurchase($rs[0][0])){
			echo makeJsonRs(false, "入库失败，权限不足");
			closeConn($db);
			exit;
		}
	}

	if(empty($madeTime)){
		$madeTime = 0;
	}
	$now = time() * 1000;
	
	if(empty($commonditySBN)){
		$commonditySBN = "";
	}

	execute($db, "BEGIN");
	$sql = "insert into Store(SBN, name, num, madeTime, operator, storeTime, retailPrice)
	values('$commonditySBN', '$commondityName', $num, $madeTime, '$self', $now, $realRetailPrice)";
	$rs = execute($db, $sql);
	if($rs == 1){
		$sql = "insert into PurchaseLog(logTime, commonditySBN, commondityName, num, realRetailPrice, madeTime, operator) 
		values($now, '$commonditySBN', '$commondityName', $num, $realRetailPrice, $madeTime, '$self')";
		$rs = execute($db, $sql);
		if($rs == 1){
			execute($db, "COMMIT");
			$sql = "select * from Store where id=(select max(id) from Store)";
			$rs = query($db, $sql);
			$rs = json_encode($rs);
			$rs = gzcompress($rs, 9);
			$rs = base64_encode($rs);
			echo makeJsonRs(true, $rs);
		}else{
			execute($db, "ROLLBACK");
			echo makeJsonRs(false, "入库失败,无法生成日志");
		}
	}else{
		execute($db, "ROLLBACK");
		echo makeJsonRs(false, "入库失败,请重试");
	}

	closeConn($db);
?>