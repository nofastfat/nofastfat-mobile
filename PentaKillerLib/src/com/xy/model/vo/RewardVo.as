package com.xy.model.vo {

/**
 * 奖励模型
 * @author xy
 */
public class RewardVo {
	/**
	 * 奖励内容
	 */
	public var item : ItemVo;

	/**
	 * 数量
	 */
	public var count : int = 1;


	public function toString() : String {
		return item.name + " +" + count;
	}
}
}
