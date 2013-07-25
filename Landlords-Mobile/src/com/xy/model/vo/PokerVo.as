package com.xy.model.vo {
import com.xy.model.enum.PokerColor;
import com.xy.model.enum.PokerPoints;

public class PokerVo {

	/**
	 * 扑克牌的牌值
	 * @see PokerPoints
	 */
	public var points : int;

	/**
	 * 扑克牌的花色
	 * @see PokerColor
	 */
	public var color : int;

	public function toString() : String {
		var rs : String = "";
		switch (color) {
			case PokerColor.C_SPADE:
				rs = "黑桃";
				break;
			case PokerColor.C_HEART:
				rs = "红心";
				break;
			case PokerColor.C_CLUB:
				rs = "梅花";
				break;
			case PokerColor.C_DIAMOND:
				rs = "方块";
				break;
		}
		
		if(points < PokerPoints.P_J){
			rs += points;
		}else{
			switch(points){
				case PokerPoints.P_J:
					rs += "J";
					break;
				case PokerPoints.P_Q:
					rs += "Q";
					break;
				case PokerPoints.P_K:
					rs += "K";
					break;
				case PokerPoints.P_A:
					rs += "A";
					break;
				case PokerPoints.P_2:
					rs += "2";
					break;
				case PokerPoints.P_BLACK_JOKER:
					rs = "小王";
					break;
				case PokerPoints.P_RED_JOKER:
					rs = "大王";
					break;
			}
		}
		
		return rs;
	}
}
}
