package com.xy.model {
import com.xy.model.vo.ItemVo;
import com.xy.model.vo.MonsterVo;
import com.xy.model.vo.NpcVo;
import com.xy.model.vo.RewardVo;

public class ConfigXml {
	[Embed(source = "../../../config/npc.xml", mimeType = "application/octet-stream")]
	public static const npcXml : Class;

	public static const npc : XML = new XML(new npcXml());

	[Embed(source = "../../../config/monster.xml", mimeType = "application/octet-stream")]
	public static const monsterXml : Class;

	public static const monster : XML = new XML(new monsterXml());

	[Embed(source = "../../../config/mapEvent.xml", mimeType = "application/octet-stream")]
	public static const mapEventXml : Class;

	public static const mapEvent : XML = new XML(new mapEventXml());


	[Embed(source = "../../../config/item.xml", mimeType = "application/octet-stream")]
	public static const itemXml : Class;

	public static const item : XML = new XML(new itemXml());

	/**
	 * 获取NPC
	 * @param gdcode
	 * @return
	 */
	public static function getNpc(gdcode : int) : NpcVo {
		var xml : XML = npc.npc.(@gdcode == gdcode.toString())[0];
		var vo : NpcVo = new NpcVo();
		vo.gdcode = gdcode;
		vo.word = String(xml.@defaultWord);
		vo.name = String(xml.@name);

		return vo;
	}

	/**
	 * 获取怪物
	 * @param atCode
	 * @return
	 */
	public static function getMonster(atcode : int) : MonsterVo {
		var xml : XML = monster.monster.(@atcode == atcode.toString())[0];
		var vo : MonsterVo = new MonsterVo();

		if (xml != null) {
			for each (var xx : XML in xml.attributes()) {
				var key : String = xx.name();
				if (vo.hasOwnProperty(key)) {
					if (vo[key] is int) {
						vo[key] = int(xx);
					} else if (vo[key] is Number) {
						vo[key] = Number(xx);
					} else if (vo[key] is Boolean) {
						vo[key] = Boolean(xx);
					} else {
						vo[key] = String(xx);
					}
				}
			}
		}

		return vo;
	}

	/**
	 * 获取地图的刷怪数据
	 * @param gdcode
	 * @return {atcode:count, atcode:count,... }
	 */
	public static function getMonstersInMap(gdcode : int) : Array {
		var rs : Array = [];

		var xmlList : XMLList = mapEvent.map.(@gdcode == gdcode.toString());
		if (xmlList == null || xmlList.length() == 0) {
			return null;
		}
		
		var xml : XML = xmlList[0].monsters[0];
		if(xml == null){
			return [];
		}
		
		var atcodes : Array = String(xml.@atcodes).split(",");
		var counts : Array = String(xml.@counts).split(",");

		if (atcodes.length != counts.length) {
			throw new Error("地图怪物配置异常:" + gdcode);
			return [];
		}

		for (var i : int = 0; i < atcodes.length; i++) {
			var atcode : int = int(atcodes[i]);
			if (rs[atcode] == null) {
				rs[atcode] = 0;
			}

			rs[atcode] += int(counts[i]);
		}
		return rs;
	}

	/**
	 * 获取地图的奖励数据
	 * @param mapId
	 * @return
	 */
	public static function getRewards(mapId : int) : Array {
		var rs : Array = [];

		var xmlList : XMLList = mapEvent.map.(@gdcode == mapId.toString());
		if (xmlList == null || xmlList.length() == 0) {
			return [];
		}

		for each (var xml : XML in xmlList[0]..reward) {
			var vo : RewardVo = new RewardVo();
			vo.count = int(xml.@count);
			vo.item = getItem(int(xml.@gdcode));
			rs.push(vo);
		}

		return rs;
	}

	/**
	 * 获取地图背景音乐
	 * @param mapId
	 * @return
	 */
	public static function getMapBgSound(mapId : int) : String {
		var xmlList : XMLList = mapEvent.map.(@gdcode == mapId.toString());

		return String(xmlList[0].@bgSound);
	}

	/**
	 * 获取Item信息
	 * @param gdcode
	 * @return
	 */
	public static function getItem(gdcode : int) : ItemVo {
		var vo : ItemVo = new ItemVo();
		vo.gdcode = gdcode;

		var xml : XML = item.item.(@gdcode == gdcode.toString())[0];
		vo.name = String(xml.@name);

		return vo;
	}
}
}
