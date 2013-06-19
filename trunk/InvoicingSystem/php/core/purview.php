<?php
	//权限管理
	class Tools{
		//是否允许添加用户
		static public function canAddUser($type){
			return $type <= 2;
		}

		//是否允许查询用户
		static public function canQueryUser($type){
			return $type <= 2;
		}

		//是否允许删除用户
		static public function canDeleteUser($type){
			return $type <= 2;
		}

		//是否可以添加商品
		static public function canAddCommodity($type){
			return $type <= 2;
		}

		//是否可以查询商品
		static public function canQueryCommodity($type){
			return true;
		}

		//是否可以删除商品
		static public function canDeleteCommodity($type){
			return $type <= 2;
		}

		//是否可以修改商品
		static public function canModifyCommodity($type){
			return $type <= 2;
		}

		//是否可以添加快递
		static public function canAddCourier($type){
			return $type <= 2;
		}

		//是否可以添加快递
		static public function canDelCourier($type){
			return $type <= 2;
		}

		//是否可以入库
		static public function canPurchase($type){
			return $type <= 2;
		}

		//是否可以查看进货价
		static public function canSeeRetailPrice($type){
			return $type <= 2;
		}

		//是否可以查看出库日志
		static public function canQuerySoldLog($type){
			return $type <= 2;
		}
	}
?>