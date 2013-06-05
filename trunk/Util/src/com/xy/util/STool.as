package com.xy.util {

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.geom.Point;

public class STool {

	/**
	 * 清空显示容器中的内容
	 * @param container
	 * @param exceptChildNames
	 */
	public static function clear(container : DisplayObjectContainer, exceptChilds : Array = null) : void {
		if (container == null) {
			return;
		}
		if (exceptChilds == null) {
			while (container.numChildren > 0) {
				container.removeChildAt(0);
			}
		} else {
			for (var i : int = 0; i < container.numChildren; i++) {
				if (exceptChilds.indexOf(container.getChildAt(i)) == -1) {
					container.removeChildAt(i);
					i--;
				}
			}
		}
	}

	/**
	 * 安全移除显示对象
	 * @param container
	 * @param child
	 */
	public static function safeRemove(container : DisplayObjectContainer, child : DisplayObject) : void {
		if (child == null || container == null || !container.contains(child)) {
			return;
		}

		container.removeChild(child);
	}

	/**
	 * 居中显示
	 * @param parent
	 * @param child
	 */
	public static function center(child : DisplayObject) : void {
		var parent : DisplayObjectContainer = child.parent as DisplayObjectContainer;
		if (child == null || parent == null) {
			return;
		}
		child.x = child.y = 0;
		child.x = (parent.width - child.width) / 2;
		child.y = (parent.height - child.height) / 2;

	}

	public static function remove(child : DisplayObject) : void {
		if (child == null || child.parent == null) {
			return;
		}

		child.parent.removeChild(child);
	}

	public static function getClazzFromLoader(clazzName : String, loader : Loader) : Class {
		if (loader == null || !loader.contentLoaderInfo.applicationDomain.hasDefinition(clazzName)) {
			return null;
		}

		var clazz : Class = loader.contentLoaderInfo.applicationDomain.getDefinition(clazzName) as Class;
		return clazz;
	}

	/**
	 * 根据指定的色值，获取颜色
	 * @param red
	 * @param green
	 * @param blue
	 * @return
	 */
	public static function makeColor(red : int, green : int, blue : int) : uint {
		return red << 16 | green << 8 | blue;
	}

	/**
	 * 计算中间点
	 * @param p1
	 * @param p2
	 * @return
	 */
	public static function calCenterPoint(p1 : Point, p2 : Point) : Point {
		var p : Point = new Point();
		p.x = p1.x + (p2.x - p1.x) / 2;
		p.y = p1.y + (p2.y - p1.y) / 2;
		return p;
	}

	/**
	 * 根据数字，控制mc的显示
	 * @param mc
	 * @param num
	 */
	public static function updateMcByNum(mc : Sprite, num : String) : void {
		if (mc == null || num == null) {
			return;
		}

		var numStr : Array = num.split("");

		if (mc["num" + (numStr.length - 1)] == null) {
			return;
		}

		/*先隐藏mc上所有数字的mc*/
		var index : int = 0;
		while (mc["num" + index] != null) {
			mc["num" + index].visible = false;
			index++;
		}

		for (var i : int = 0; i < numStr.length; i++) {
			var numMc : MovieClip = mc["num" + i];
			if (numMc != null) {
				var value : String = numStr[i];

				numMc.visible = true;

				/*空格，+号的解析*/
				switch (value) {
					case " ":
						numMc.visible = false;
						break;
					case ":":
						numMc.gotoAndStop(11);
						break;
					case "+":
						numMc.gotoAndStop(12);
						break;
					case "-":
						numMc.gotoAndStop(13);
						break;
					default:
						var frameRate : int = int(value) + 1;
						numMc.gotoAndStop(frameRate);
				}
			}
		}
	}

	public static function random(start : int, end : int) : int {
		return int(start + (end - start + 1) * Math.random())
	}

	/**
	 * 搞一个超链接
	 * @param str
	 * @param eventName
	 * @return
	 */
	public static function makeLink(str : String, eventName : String) : String {
		var vl : String;
		vl = "<a href='event:" + eventName + "'>" + str + "</a>";
		return vl;
	}

	/**
	 * 设置按钮是否可用
	 * @param btn
	 * @param enable
	 */
	public static function setButtonEnable(btn : SimpleButton, enable : Boolean) : void {
		btn.mouseEnabled = enable;
		if (enable) {
			btn.filters = [];
		} else {
			btn.filters = GrayColor.value;
		}
	}

	/**
	 * 设置MC是否可用
	 * @param mc
	 * @param enable
	 */
	public static function setMovieClipEnable(mc : Sprite, enable : Boolean) : void {
		mc.mouseEnabled = enable;
		mc.buttonMode = enable;
		if (enable) {
			mc.filters = [];
		} else {
			mc.filters = GrayColor.value;
		}
	}

	/**
	 *
	 * 计算字符串的长度
	 * 汉字算2个
	 * 其他都算1个
	 * @param text
	 * @return
	 */
	public static function count(text : String) : int {
		var count : int = 0;
		var pattern : RegExp = /^[\u4E00-\u9FA5\uF900-\uFA2D]+$/; //验证中文
		for (var i : int = 0; i < text.length; i++) {
			var str : String = text.charAt(i);
			if (pattern.test(str)) {
				count += 2;
			} else {
				count += 1;
			}
		}
		return count;
	}

	/**
	 * 毫秒转 日-时-分-秒
	 * @param msTime 毫秒
	 * @valueAsString 是否返回字符串
	 * @return [日-时-分-秒]
	 */
	public static function toDate(msTime : Number, valueAsString : Boolean = false) : Array {
		var second : int = msTime / 1000;
		var minute : int = second / 60;
		var hour : int = minute / 60;
		var day : int = hour / 24;

		second = second % 60;
		minute = minute % 60;
		hour = hour % 24;
		day = day % 30;

		if (valueAsString) {
			var d : String = day + "";
			var h : String = hour + "";
			var m : String = minute + "";
			var s : String = second + "";

			if (d.length == 1) {
				d = "0" + d;
			}
			if (h.length == 1) {
				h = "0" + h;
			}
			if (m.length == 1) {
				m = "0" + m;
			}
			if (s.length == 1) {
				s = "0" + s;
			}
			return [d, h, m, s];
		}
		return [day, hour, minute, second];
	}

	public static function copyChar(char : String, count : int) : String {
		var s : String = "";
		for (var i : int = 0; i < count; i++) {
			s += char;
		}
		return s;
	}

	/**
	 * @param value
	 * @param total
	 * @return
	 */
	public static function percent(value : int, total : int, fixed : int = 2) : String {
		var rs : Number = (value / total) * 100;
		var str : String = rs + "";
		var index : int = str.indexOf(".");
		if (index == -1) {
			index = str.length;
		}
		return str.substr(0, index + fixed + 1) + "%";
	}

	/**
	 * 格式化字符串
	 * <pre>
	 *  var str2:String = "Hei jave, there are {0} apples，and {1} banana！ {2} dollar all together";
	 *  trace(formate(str2, 5, 10, 20));
	 * </pre>
	 * @param str strs{0}ststrstrs{1}sytsyts...
	 * @param args [value0, value1, ...]
	 * @return
	 */
	public static function format(str : String, ... args) : String {
		for (var i : int = 0; i < args.length; i++) {
			str = str.replace(new RegExp("\\{" + i + "\\}", "gm"), args[i]);
		}
		return str;
	}
}
}
