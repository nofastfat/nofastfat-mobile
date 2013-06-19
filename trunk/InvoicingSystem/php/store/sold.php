<?php
	
	header("Content-Type: text/html; charset=UTF-8");
	
	$self = getParam("self");
	$selfPwd = getParam("selfPwd");
	$clientName = getParam("clientName");
	$storeId = getParam("storeId");
	$num = getParam("num");
	$totalWeight = getParam("totalWeight");
	$soldAddress = getParam("soldAddress");
	$senderCompany = getParam("senderCompany");
	$sendId = getParam("sendId");
	$sendPrice = getParam("sendPrice");
	$clientPay = getParam("clientPay");
	
	if(empty($self) ||empty($selfPwd) ||empty($storeId) || empty($clientName)|| empty($num)|| empty($totalWeight)|| empty($clientPay)){
		echo makeJsonRs(false, "出货失败，参数不正确");
		closeConn($db);
		exit;
	}

	$storeIdArr = explode(",", $storeId);
	$numArr = explode(",", $num);
	if(count($storeIdArr) != count($numArr)){
		echo makeJsonRs(false, "出货失败，货物参数不正确");
		closeConn($db);
		exit;
	}

	$sql = "select type from UsersTb where id='".$self."' and pwd='".$selfPwd."';";
	$rs = query($db, $sql);

	if(count($rs) == 0){
		echo makeJsonRs(false, "出货失败，账户不存在");
		closeConn($db);
		exit;
	}
	
	if(empty($soldAddress)){
		$soldAddress=null;
	}
	if(empty($sendId)){
		$sendId=0;
	}
	if(empty($sendPrice)){
		$sendPrice=0;
	}
	$sql = "select id,SBN,name,retailPrice,num from Store where id in($storeId)";
	$rs = query($db, $sql);

	$profit = $clientPay - $sendPrice;
	
	$SBNArr = array();
	$nameArr = array();
	$retailPriceArr = array();
	for($i = 0; $i < count($storeIdArr); $i++){
		$param = getParamFrom($storeIdArr[$i], $rs);
		if(empty($param)){
			echo makeJsonRs(false, "出库失败，第 ".($i+1)." 个货物已经售罄");
			closeConn($db);
			exit;
		}

		$SBNArr[$i] = $param[1];
		$nameArr[$i] = $param[2];
		$retailPriceArr[$i] = $param[3];
		
		if((int)$numArr[$i] > (int)$param[4]){
			echo makeJsonRs(false, "出库失败，".$param[2]." 当前库存为 ".$param[4]." ,不足 ".$numArr[$i]);
			closeConn($db);
			exit;
		}
		$profit = $profit - $param[3] * (int)$numArr[$i];
	}

	execute($db, "BEGIN");

	for($i = 0; $i < count($storeIdArr); $i++){
		$param = getParamFrom($storeIdArr[$i], $rs);
		$sql = "";

		if((int)$numArr[$i] == (int)$param[4]){
			$sql = "delete from Store where id=".$storeIdArr[$i];
		}else{
			$sql = "update Store set num=num-".$numArr[$i]." where id=".$storeIdArr[$i];
		}
		$rs = execute($db, $sql);
		if($rs == 0){
			echo makeJsonRs(false, "出库失败, 更新 ".$param[2]." 时发生错误, 请重试");
			execute($db, "ROLLBACK");
			closeConn($db);
			exit;
		}
	}

	$now = time() * 1000;
	$SBN = implode(",", $SBNArr);
	$name = implode(",", $nameArr);

	$sql = "insert into SoldLog(soldTime, clientName, SBN, name, num, totalWeight, soldAddress, senderCompany, sendId, sendPrice, clientPay, profit) 
	values($now, '$clientName', '$SBN', '$name', '$num', '$totalWeight', '$soldAddress', '$senderCompany', '$sendId', $sendPrice, $clientPay, $profit)";
	
	$rs = execute($db, $sql);
	if($rs = 0){
		echo makeJsonRs(false, "出库失败, 产生日志时发生错误, 请重试");
		execute($db, "ROLLBACK");
		closeConn($db);
		exit;
	}

	execute($db, "COMMIT");
	echo makeJsonRs(true, "出库成功");
	
	closeConn($db);

	function getParamFrom($id, $rs){
		for($i = 0; $i < count($rs); $i++){
			if((int)$rs[$i][0] == (int)$id){
				return $rs[$i];
			}
		}
	}
?>