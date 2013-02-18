package com.xy.util {
import flash.geom.Rectangle;

/**
 * 表示椭圆或者矩形
 * @author xy
 */
public class PkRectangle extends Rectangle {

	/**
	 * rect所属的ID
	 */
	public var ownerId : int;

	/**
	 * 是否是椭圆
	 */
	public var isEllipse : Boolean;

	public function PkRectangle(x : Number = 0, y : Number = 0, width : Number = 0, height : Number = 0, isEllipse : Boolean = false, ownerId : int = 0) {
		super(x, y, width, height);
		this.isEllipse = isEllipse;
		this.ownerId = ownerId;
	}

	/**
	 * 是否包含
	 * @param px
	 * @param py
	 * @return
	 */
	override public function contains(px : Number, py : Number) : Boolean {
		if (!isEllipse) {
			return super.contains(px, py);
		}
		var xRadius : int = width >> 1;
		var yRadius : int = height >> 1;
		var xTar : int = px - x - xRadius;
		var yTar : int = py - y - yRadius;
		return Math.pow(xTar / xRadius, 2) + Math.pow(yTar / yRadius, 2) <= 1;
	}

	/**
	 * 椭圆与椭圆是否相交 
	 * @param rect
	 * @return 
	 */	
	override public function intersects(rect : Rectangle) : Boolean {
		if (!isEllipse) {
			return super.intersects(rect);
		}

		var halfWidth : Number = rect.width >> 1;
		var halfHeight : Number = rect.height >> 1;
		var selfHalfWidth : Number = width >> 1;
		var selfHalfHeight : Number = height >> 1;

		return contains(rect.x + halfWidth, rect.y + halfHeight) ||
			contains(rect.x + halfWidth, rect.y) ||
			contains(rect.x + rect.width, rect.y + halfHeight) ||
			contains(rect.x + halfWidth, rect.y + rect.height) ||
			contains(rect.x + rect.width, rect.y + halfHeight) ||

			rect.contains(x + selfHalfHeight, y + selfHalfHeight) ||
			rect.contains(x + selfHalfHeight, y) ||
			rect.contains(x + width, y + selfHalfHeight) ||
			rect.contains(x + selfHalfHeight, y + height) ||
			rect.contains(x + width, y + selfHalfHeight);
	}
}
}
