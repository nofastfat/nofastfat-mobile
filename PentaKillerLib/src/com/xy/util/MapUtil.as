package com.xy.util {

/**
 * 地图工具
 * @author xy
 */
public class MapUtil {
	private static var added : Array = [];

	/**
	 * 生成随机地图的数据
	 * @param width
	 * @param height
	 * @param addPercent
	 * @return
	 */
	public static function makeRandomMap(width : int, height : int, addPercent : Number = 0.3) : Array {
		var arr : Array = makeEmptyMap(width, height);
		added = [];
		var addCount : int = addPercent * (width - 1) * (height - 1);

		while (added.length < addCount) {
			var randX : int = random(0, width - 2);
			var randY : int = random(0, height - 2);
			var addKey : String = randX + "_" + randY;
			if (added.indexOf(addKey) == -1) {
				addAt(arr, randX, randY);
			}
		}

		return arr;
	}

	public static function random(start : int, end : int) : int {
		return int(Math.random() * (end - start + 1)) + start;
	}

	public static function makeTileName(index : int) : String {
		return "t_" + index + "_" + random(0, 1);
	}

	private static function addAt(mapArr : Array, ix : int, iy : int) : void {
		added.push(ix + "_" + iy);
		var arr : Array = [mapArr[ix][iy], mapArr[ix][iy + 1], mapArr[ix + 1][iy + 1], mapArr[ix + 1][iy]];
		mapArr[ix][iy] += 4;
		mapArr[ix][iy + 1] += 1;
		mapArr[ix + 1][iy + 1] += 2;
		mapArr[ix + 1][iy] += 8;

		if (mapArr[ix][iy] > 15) {
			mapArr[ix][iy] = 15;
		}
		if (mapArr[ix + 1][iy] > 15) {
			mapArr[ix + 1][iy] = 15;
		}
		if (mapArr[ix + 1][iy + 1] > 15) {
			mapArr[ix + 1][iy + 1] = 15;
		}
		if (mapArr[ix][iy + 1] > 15) {
			mapArr[ix][iy + 1] = 15;
		}

		if (mapArr[ix][iy] == 6) {
			addAt(mapArr, ix - 1, iy);
		}
		if (mapArr[ix + 1][iy + 1] == 6) {
			addAt(mapArr, ix, iy + 1);
		}

		if (mapArr[ix][iy + 1] == 9) {
			addAt(mapArr, ix, iy + 1);
		}

		if (mapArr[ix + 1][iy] == 9) {
			addAt(mapArr, ix + 1, iy);
		}
	}

	private static function delAt(mapArr : Array, ix : int, iy : int) : void {
		var addIndex : int = added.indexOf(ix + "_" + iy);
		if (addIndex == -1) {
			return;
		}
		added.splice(addIndex, 1);

		if (mapArr[ix][iy] > 15) {
			mapArr[ix][iy] = 15;
		}
		if (mapArr[ix + 1][iy] > 15) {
			mapArr[ix + 1][iy] = 15;
		}
		if (mapArr[ix + 1][iy + 1] > 15) {
			mapArr[ix + 1][iy + 1] = 15;
		}
		if (mapArr[ix][iy + 1] > 15) {
			mapArr[ix][iy + 1] = 15;
		}

		mapArr[ix][iy] -= 4;
		mapArr[ix][iy + 1] -= 1;
		mapArr[ix + 1][iy + 1] -= 2;
		mapArr[ix + 1][iy] -= 8;

		if (mapArr[ix][iy] == 9) {
			delAt(mapArr, ix - 1, iy);
		}
		if (mapArr[ix + 1][iy + 1] == 9) {
			delAt(mapArr, ix, iy + 1);
		}

		if (mapArr[ix][iy + 1] == 6) {
			delAt(mapArr, ix, iy + 1);
		}

		if (mapArr[ix + 1][iy] == 6) {
			delAt(mapArr, ix + 1, iy);
		}
	}

	/**
	 * 创建一个空的数数组，内容由-1填充
	 * @param width
	 * @param height
	 * @return
	 */
	private static function makeEmptyMap(width : int, height : int) : Array {
		var arr : Array = [];
		for (var i : int = 0; i < width; i++) {
			arr[i] = [];
			for (var j : int = 0; j < height; j++) {
				arr[i][j] = 0;
			}
		}

		return arr;
	}
}
}
