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

	$sql = "insert into Store(SBN, name, num, madeTime, operator, storeTime, retailPrice)
	values('$commonditySBN', '$commondityName', $num, $madeTime, '$self', $now, $realRetailPrice)";
	$rs = execute($db, $sql);
	if($rs == 1){
		$sql = "insert into PurchaseLog(logTime, commonditySBN, commondityName, num, realRetailPrice, madeTime, operator) 
		values($now, '$commonditySBN', '$commondityName', $num, $realRetailPrice, $madeTime, '$self')";
		$rs = execute($db, $sql);
		if($rs == 1){
			echo makeJsonRs(true, "true");
		}else{
			echo makeJsonRs(false, "入库失败");
		}
	}else{
		echo makeJsonRs(false, "入库失败");
	}

	closeConn($db);
?>