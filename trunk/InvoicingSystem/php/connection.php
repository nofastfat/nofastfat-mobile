<?php
	define("DB_NAME","jxc.db");
	define("IS_SQLITE3", class_exists("SQLite3"));
	//创建数据库文件,文件内容为空
	$justCeate = false;

	$initArray = array(
		"CREATE TABLE 'UsersTb' ('id' VARCHAR(200)  UNIQUE NOT NULL PRIMARY KEY,'pwd' VARCHAR(200) NOT NULL);",
		"insert into UsersTb (id, pwd) values ('admin', '21232f297a57a5a743894a0e4a801fc3');"
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

	//执行SQL语句
	function execute($db, $sql){
		$arr = array();
		if(IS_SQLITE3){
			$rs =$db->query($sql);
			while ($row = $rs->fetchArray()) {
				array_push($arr, $row);
			}

		}else{
			$rs =sqlite_query($db,$sql, 0666, $error);
			echo "<font color='red'>".$error."</font>";
			while ($row = sqlite_fetch_array($rs)) {
				array_push($arr, $row);
			}
		}
		return $arr;
	}

	//关闭连接
	function closeConn($db){
		
		if(IS_SQLITE3){
			$db->close();
		}else{
			sqlite_close($db);
		}
	}
?>