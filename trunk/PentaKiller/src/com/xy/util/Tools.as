package com.xy.util {
import com.xy.model.enum.DataConfig;
import com.xy.model.enum.Direction;
import com.xy.view.roles.BaseRole;

import flash.display.BitmapData;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Point;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.textures.RenderTexture;
import starling.textures.Texture;
import starling.utils.deg2rad;
import starling.utils.rad2deg;

public class Tools {
	private static var _calLenPoint : Point = new Point();

	/**
	 * 清空容器
	 * @param container
	 * @param dispose
	 */
	public static function clear(container : DisplayObjectContainer, dispose : Boolean = false) : void {
		while (container.numChildren > 0) {
			container.removeChildAt(0, dispose);
		}
	}

	public static function calLen(startX : Number, startY : Number, endX : Number, endY : Number) : Number {
		_calLenPoint.x = endX - startX;
		_calLenPoint.y = endY - startY;

		return _calLenPoint.length;
	}

	/**
	 * 先是对象移除
	 * @param container
	 * @param child
	 * @param dispose
	 */
	public static function remove(container : DisplayObjectContainer, child : DisplayObject, dispose : Boolean = false) : void {
		if (container == null || child == null) {
			return;
		}

		if (container.contains(child)) {
			container.removeChild(child, dispose);
		}
	}

	/**
	 * 计算方向,只是4方向
	 * @param startPosition
	 * @param targetPosition
	 * @return
	 */
	public static function calculateDirection(nowX : Number, nowY : Number, targetX : Number, targetY : Number) : String {
		var direction : String;
		direction = targetX > nowX ? "R" : "L";
		direction += targetY > nowY ? "B" : "U";
		return direction;
	}

	/**
	 * 由向量速度计算X,Y方向上的速度
	 * @param startX
	 * @param startY
	 * @param targetX
	 * @param targetY
	 * @param speedVector
	 * @return
	 */
	public static function calSpeedXY(startX : Number, startY : Number, targetX : Number, targetY : Number, speedVector : Number) : Point {
		var rad : Number = Math.atan2(targetY - startY, targetX - startX);
		var x : Number = Math.cos(rad) * speedVector;
		var y : Number = Math.sin(rad) * speedVector;

		return new Point(x, y);
	}

	/**
	 * 根据方向计算速度
	 * @param direction
	 * @param speedVector
	 * @return
	 */
	public static function calSpeedByDirection(direction : String, speedVector : Number) : Point {
		var rad : Number = Direction.toRad(direction);
		var x : Number = Math.cos(rad) * speedVector;
		var y : Number = Math.sin(rad) * speedVector;

		return new Point(x, y);
	}

	/**
	 * 计算2点之间的弧度
	 * @param startX
	 * @param startY
	 * @param targetX
	 * @param targetY
	 * @return
	 */
	public static function calRad(startX : Number, startY : Number, targetX : Number, targetY : Number) : Number {
		return Math.atan2(targetY - startY, targetX - startX);
	}

	/**
	 * 计算2点之间的角度
	 * @param startX
	 * @param startY
	 * @param targetX
	 * @param targetY
	 * @return
	 */
	public static function calDeg(startX : Number, startY : Number, targetX : Number, targetY : Number) : Number {
		return rad2deg(Math.atan2(targetY - startY, targetX - startX));
	}

	/**
	 * 检查某个弧度是否在范围中
	 * @param startRad
	 * @return
	 */
	public static function radCheckIn(startRad : Number, endRad : Number, currentRad : Number) : Boolean {
		var rad360 : Number = deg2rad(360);
		return (startRad <= currentRad && currentRad <= endRad) ||
			(startRad <= currentRad - rad360 && currentRad - rad360 <= endRad) ||
			(startRad <= currentRad + rad360 && currentRad + rad360 <= endRad);
	}

	/**
	 * A是否能攻击到B
	 * 正圆相交判定
	 * @param a
	 * @param b
	 * @return
	 */
	public static function ACanAttackB(a : BaseRole, b : BaseRole) : Boolean {
		if (a.isDie || b.isDie) {
			return false;
		}

		var directionRad : Number = Direction.toRad(a.direction);
		var attackRad : Number = a.getAttackRad();
		var radius : int = a.vo.attackRadius + a.vo.bodyRadius;
		var startRad : Number = directionRad - attackRad / 2;
		var endRad : Number = directionRad + attackRad / 2;
		var tmpPoint : Point = new Point();
		var attackedSth : Boolean = false;
		/*距离上能否被击中*/
		radius += b.vo.bodyRadius;
		tmpPoint.x = b.x - a.x;
		tmpPoint.y = b.y - a.y;
		var canBeAttackByRadius : Boolean = radius >= Math.abs(tmpPoint.length);

		/*距离够了，才计算角度*/
		if (canBeAttackByRadius) {
			/*怪物与玩家的弧度*/
			directionRad = Tools.calRad(a.x, a.y, b.x, b.y);

			/*弧度上是否能被击中*/
			var canBeAttackByRad : Boolean = Tools.radCheckIn(startRad, endRad, directionRad);

			if (canBeAttackByRad) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 点是否在椭圆内
	 * @param ex 椭圆的左上角X
	 * @param ey 椭圆的左上角Y
	 * @param eWidth 椭圆的宽
	 * @param eHeight 椭圆的高
	 * @param px 点X
	 * @param py 点Y
	 * @return 是否在内
	 */
	public static function ellipseContainsPoint(ex : Number, ey : Number, eWidth : Number, eHeight : Number, px : Number, py : Number) : Boolean {
		var xRadius : Number = eWidth * 0.5;
		var yRadius : Number = eHeight * 0.5;
		var xTar : Number = px - ex - xRadius;
		var yTar : Number = py - ey - yRadius;

		return Math.pow(xTar / xRadius, 2) + Math.pow(yTar / yRadius, 2) <= 1;
	}

	/**
	 * 伤害计算公式
	 * @param attacker
	 * @param underAttacker
	 * @return
	 */
	public static function calHurt(attacker : BaseRole, underAttacker : BaseRole) : int {
		return attacker.getATK() - underAttacker.getDefense();
	}

	/**
	 * 障碍是否与包含点
	 * @param px
	 * @param py
	 * @return
	 */
	public static function bafflesHitTest(px : int, py : int, targetId : int) : PkRectangle {
		var arr : Array = DataConfig.activeBaffles;
		var len : int = arr.length;
		for(var i : int = 0; i < len; i++){
			var rect : PkRectangle = arr[i];
			if (rect.contains(px, py) && rect.ownerId != targetId) {
				return rect;
			}
		}
		return null;
	}

	public static function random(start : int, end : int) : int {
		return int(Math.random() * (end - start + 1)) + start;
	}

	/**
	 * 圆内随机点
	 * @param centerX
	 * @param centerY
	 * @param radius
	 * @return
	 */
	public static function randomInCircle(centerX : int, centerY : int, radius : int) : Point {
		var px : int = Tools.random(centerX - radius, centerX + radius);
		var py : int = Tools.random(centerY - radius, centerY + radius);
		while (Tools.calLen(centerX, centerY, px, py) > radius) {
			px = Tools.random(centerX - radius, centerX + radius);
			py = Tools.random(centerY - radius, centerY + radius);
		}

		return new Point(px, py);
	}

	/**
	 * 创建一个圆形
	 * @param radius
	 * @param color
	 * @return
	 */
	public static function makeImg(radius : int, color : uint) : Image {
		var shape : Shape = new Shape();
		shape.graphics.clear();
		shape.graphics.beginFill(color);
		shape.graphics.drawCircle(0, 0, radius);
		shape.graphics.endFill();
		var bmd : BitmapData = new BitmapData(radius << 1, radius << 1, true, 0x00000000);
		var mat : Matrix = new Matrix();
		mat.translate(radius, radius);
		bmd.draw(shape, mat);
		var texture : Texture = Texture.fromBitmapData(bmd);
		var img : Image = new Image(texture);
		img.alpha = 0.5;

		return img;
	}

	/**
	 * 克隆可视对象到一个图片
	 * @param target	可视目标对象
	 * @param persistent	指明纹理在经过多次绘制之后是否是持久的
	 * @return
	 */
	public static function clone(target : DisplayObject, persistent : Boolean = false) : Image {
		if (!target) {
			return null;
		}
		var texture : RenderTexture = new RenderTexture(target.width, target.height, persistent);
		if (target is DisplayObjectContainer) {
			texture.drawBundled(function() : void
			{
				var num : int = DisplayObjectContainer(target).numChildren;
				for (var i : int = 0; i < num; i++)
				{
					texture.draw(DisplayObjectContainer(target).getChildAt(i));
				}
			});
		} else {
			texture.draw(target);
		}
		return new Image(texture);
	}
}
}
