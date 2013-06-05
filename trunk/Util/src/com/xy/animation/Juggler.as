package com.xy.animation {

import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.getTimer;

public class Juggler {
	public static const REMOVE_FROM_JUGGLER : String = "REMOVE_FROM_JUGGLER";
	private static var _stage : Stage;
	private static var _isInit : Boolean;
	private static var _mLastFrameTimestamp : Number;
	private static var _animates : Array = [];

	private static var mObjects : Array = [];

	/**
	 * 初始化
	 * @param stage
	 */
	public static function init(stage : Stage) : void {
		if (_isInit) {
			return;
		}

		_isInit = true;
		_stage = stage;
		_stage.addEventListener(Event.ENTER_FRAME, __enterFrameHandler);
	}


	public static function tween(target : Object, time : Number, properties : Object) : void {

		var tween : Tween = new Tween(target, time);
		//var tween : Tween = Tween.fromPool(target, time);

		for (var property : String in properties)

		{

			var value : Object = properties[property];



			if (tween.hasOwnProperty(property))

				tween[property] = value;

			else if (target.hasOwnProperty(property))

				tween.animate(property, value as Number);

			else

				throw new ArgumentError("Invalid property: " + property);

		}

		add(tween);

	}


	public static function removeTweens(target : Object) : void {
		if (target == null)
			return;



		for (var i : int = mObjects.length - 1; i >= 0; --i) {

			var tween : Tween = mObjects[i] as Tween;

			if (tween && tween.target == target) {
				tween.removeEventListener(REMOVE_FROM_JUGGLER, __onRemoveHandler);
				mObjects[i] = null;
			}

		}

	}

	/**
	 * @param call
	 * @param delay 单位:S
	 * @param args
	 * @return
	 */
	public static function delayCall(call : Function, delay : Number, ... args) : DelayedCall {
		if (call == null)
			return null;

		var delayedCall : DelayedCall = new DelayedCall(call, delay, args);

		add(delayedCall);

		return delayedCall;
	}

	private static function add(object : IAnimatable) : void {
		if (object && mObjects.indexOf(object) == -1) {

			mObjects.push(object);

			(object as EventDispatcher).addEventListener(REMOVE_FROM_JUGGLER, __onRemoveHandler);
		}
	}

	public static function remove(object : IAnimatable) : void {
		if (object == null)
			return;

		(object as EventDispatcher).removeEventListener(REMOVE_FROM_JUGGLER, __onRemoveHandler);
		var index : int = mObjects.indexOf(object);
		if (index != -1) {
			mObjects[index] = null;
		}
	}

	private static function __onRemoveHandler(e : Event) : void {
		var ia : IAnimatable = e.currentTarget as IAnimatable;
		remove(ia);


		var tween : Tween = e.currentTarget as Tween;

		if (tween && tween.isComplete)
			add(tween.nextTween);
	}

	/**
	 * 添加一个可控制的MC
	 * @param mc
	 * @param fps
	 * @param completeCall
	 * @param keyCalls 2维数组：[[frameIndex:int,call:Function], [frameIndex:int,call:Function], ...]
	 */
	public static function addMovieClip(mc : *, fps : int, completeCall : Function = null, keyCalls : Array = null) : void {
		var isNew : Boolean = true;
		var len : int = _animates.length;
		for (var i : int = 0; i < len; i++) {
			var animeObj : AnimateObj = _animates[i];
			if (animeObj != null && mc == animeObj.mc) {
				animeObj.fps = fps;
				if (completeCall != null) {
					animeObj.completeCalls = [completeCall];
				}
				animeObj.transformKeyCalls(keyCalls);
			}
		}

		if (isNew) {
			var callArr : Array = [];

			if (completeCall != null) {
				callArr.push(completeCall);
			}
			animeObj = new AnimateObj(mc, fps, callArr, keyCalls);
			_animates.push(animeObj);
		}
	}

	public static function updateMovieClip(mc : *, completeCall : Function, keyCalls : Array = null) : void {
		var len : int = _animates.length;
		for (var i : int = 0; i < len; i++) {
			var animeObj : AnimateObj = _animates[i];
			if (mc == animeObj.mc) {
				animeObj.completeCalls.push(completeCall);
				animeObj.transformKeyCalls(keyCalls);
				return;
			}
		}
	}

	public static function updateFps(mc : *, fps : int) : void {
		var len : int = _animates.length;
		for (var i : int = 0; i < len; i++) {
			var animeObj : AnimateObj = _animates[i];
			if (animeObj != null && mc == animeObj.mc) {
				animeObj.fps = fps;
				return;
			}
		}

	}

	private static function __enterFrameHandler(e : Event) : void {
		var nullIndex : Array = [];
		var now : Number = getTimer() / 1000.0;
		var passedTime : Number = now - _mLastFrameTimestamp;
		_mLastFrameTimestamp = now;
		if (isNaN(passedTime)) {
			passedTime = 0;
		}

		var len : int = _animates.length;
		for (var i : int = 0; i < len; i++) {
			var animeObj : AnimateObj = _animates[i];
			if (animeObj != null) {
				animeObj.advanceTime(passedTime);
			} else {
				nullIndex.push(i);
			}
		}
		for (i = nullIndex.length -1 ; i >= 0; i--) {
			_animates.splice(nullIndex[i], 1);
		}


		nullIndex = [];
		for (i = 0; i < mObjects.length; i++) {
			var ia : IAnimatable = mObjects[i];
			if (ia != null) {
				ia.advanceTime(passedTime);
			} else {
				nullIndex.push(i);
			}
		}
		for (i = nullIndex.length -1 ; i >= 0; i--) {
			mObjects.splice(nullIndex[i], 1);
		}
	}
	
	public static function resetMc(mc:*):void{
		var len : int = _animates.length;
		for (var i : int = 0; i < len; i++) {
			var animeObj : AnimateObj = _animates[i];
			if (animeObj != null && mc == animeObj.mc) {
				animeObj.completeCalls = [];
				animeObj.keyCalls = [];
			}
		}
	}

	public static function removeMovieClip(mc : *) : void {
		if(mc == null){
			return;
		}
		
		var len : int = _animates.length;
		for (var i : int = 0; i < len; i++) {
			var animeObj : AnimateObj = _animates[i];
			if (animeObj != null && mc == animeObj.mc) {
				_animates[i] = null;
				animeObj.destroy();
			}
		}
	}
}
}
