<?php
	define("DB_NAME","../../jxc.db");
	define("IS_SQLITE3", class_exists("SQLite3"));
	//创建数据库文件,文件内容为空
	$justCeate = false;

	$initArray = array(
		"CREATE TABLE 'UsersTb' (
			'id' VARCHAR(200)  UNIQUE NOT NULL PRIMARY KEY,
			'pwd' VARCHAR(200) NOT NULL, 
			'type' int, 
			creator VARCHAR(200)
			);",
		//"insert into UsersTb (id, pwd, type, creator) values ('admin', '21232f297a57a5a743894a0e4a801fc3', 1, '');"
		"insert into UsersTb (id, pwd, type, creator) values ('admin', 'admin', 1, '');",
		"CREATE TABLE [Commodity] (
			[id] INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,
			[name] VARCHAR(200)  NOT NULL,
			[description] VARCHAR(200)  NULL,
			[weight] FLOAT DEFAULT '''''''0''''''' NULL,
			[SBNId] VARCHAR(200)  NOT NULL,
			[type] VARCHAR(200)  NOT NULL
			)",
		"CREATE TABLE [PurchaseLog] (
			[id] INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,
			[logTime] NUMERIC  NULL,
			[commonditySBN] VARCHAR(200)  NULL,
			[commondityName] VARCHAR(200)  NULL,
			[num] INTEGER  NULL,
			[realRetailPrice] FLOAT  NULL,
			[madeTime] NUMERIC  NULL,
			[operator] VARCHAR(200)  NULL
			)",
		"CREATE TABLE [Store] (
			[id] INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
			[SBN] VARCHAR(200)  NULL,
			[name] VARCHAR(200)  NULL,
			[num] INTEGER  NULL,
			[madeTime] NUMERIC  NULL,
			[operator] VARCHAR(200)  NULL,
			[storeTime] NUMERIC  NULL,
			[retailPrice] FLOAT  NULL
			)",
		"CREATE TABLE [SoldLog] (
			[id] INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
			[soldTime] NUMERIC  NULL,
			[clientName] VARCHAR(200)  NULL,
			[SBN] VARCHAR(400)  NULL,
			[name] VARCHAR(400)  NULL,
			[num] VARCHAR(200)  NULL,
			[totalWeight] VARCHAR(200)  NULL,
			[soldAddress] VARCHAR(200)  NULL,
			[senderCompany] VARCHAR(200)  NULL,
			[sendId] VARCHAR(200)  NULL,
			[sendPrice] FLOAT  NULL,
			[clientPay] FLOAT  NULL,
			[profit] FLOAT  NULL
			)",
		"CREATE TABLE [SendCompany] (
			[id] INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
			[name] VARCHAR(200)  NULL
			)"
	);

	//检查数据是否存在
	if(!file_exists(DB_NAME))
	{
		if(!($fp = fopen(DB_NAME, "w+"))) 
		{
			exit("创建数据库失败");
		}
		$justCeate = true;
		fclose($fp);
	}
	//打开数据库文件
	$db = makeConn();

	//设置初始数据
	if($justCeate){
		for($i = 0; $i < count($initArray); $i++){
			execute($db,$initArray[$i]);
		}
	}
	
	//建立数据库连接
	function makeConn(){
		if(IS_SQLITE3){
			return new SQLite3(DB_NAME);
		}else{
			return sqlite_open(DB_NAME);
		}
	}

	//查询SQL语句
	function query($db, $sql){
		$arr = array();
		if(IS_SQLITE3){
			$rs =$db->query($sql);
			$len = $rs->numColumns();
			while ($row = $rs->fetchArray()) {
				$tmpArr = array();
				for($i = 0; $i < $len; $i++){
					$tmpArr[$i] = $row[$i];
				}
				array_push($arr, $tmpArr);
			}

		}else{
			$rs =sqlite_query($db,$sql);
			//echo "<font color='red'>".$error."</font>";
			while ($row = sqlite_fetch_array($rs)) {
				array_push($arr, $row);
			}
		}
		return $arr;
	}

	//修改或者删除
	function execute($db, $sql){
		if(IS_SQLITE3){
			if ($db->query($sql)) {
				return $db->changes();
			 } else {
				return false;
			 }

		}else{
			if(sqlite_query($db,$sql, 0666, $error)){
				//echo "<font color='red'>".$error."</font>";
				return sqlite_changes($db);
			}else{
				return false;
			}
		}
	}

	//关闭连接
	function closeConn($db){
		
		if(IS_SQLITE3){
			$db->close();
		}else{
			sqlite_close($db);
		}
	}

	function getParam($keyStr){
		if(isset($_GET[$keyStr])){
			return $_GET[$keyStr];
		}

		return null;
	}

	function makeJsonRs($isOk, $data){
		$json = array(
			"status" => $isOk,
			"data" => $data
		);

		return json_encode($json);
	}
?>