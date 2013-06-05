package com.xy.animation {

import com.xy.animation.Juggler;

import flash.events.Event;

public class AnimateObj {
	public var mc : *;
	private var _fps : int;
	public var mCurrentTime : Number;
	public var mCurrentFrame : int;
	public var mTotalTime : Number;
	public var mLoop : Boolean;
	public var totalFrame : int;
	public var mDefaultFrameDuration : Number;
	public var mDurations : Array = [];
	public var mStartTimes : Array = [];
	private var _completeCalls : Array = [];

	private var _keyCalls : Array = [];
	private var _hasDestroy : Boolean = false;


	/**
	 * @param mc
	 * @param fpS
	 * @param completeCall
	 * @param keyCalls [[frameIndex:int,call:Function, params:Array], [frameIndex:int,call:Function, params:Array], ...]
	 */
	public function AnimateObj(mc : *, fpS : int, completeCalls : Array = null, keyCalls : Array = null) {
		totalFrame = mc.totalFrames;
		fps = fpS;
		this.mc = mc;
		_completeCalls = completeCalls;
		transformKeyCalls(keyCalls);

		mLoop = (completeCalls == null || completeCalls.length == 0);
		mDefaultFrameDuration = 1.0 / fps;
		mCurrentTime = 0.0;
		mCurrentFrame = 0;
		mTotalTime = mDefaultFrameDuration * totalFrame;

		for (var i : int = 0; i < totalFrame; ++i) {
			mDurations[i] = mDefaultFrameDuration;
			mStartTimes[i] = i * mDefaultFrameDuration;
		}

		mc.addEventListener(Event.REMOVED_FROM_STAGE, __removedHandler);
	}

	private function __removedHandler(e : Event) : void {
		Juggler.removeMovieClip(mc);
		e.stopImmediatePropagation();
	}

	public function transformKeyCalls(keyCalls : Array) : void {
		if (keyCalls == null || keyCalls.length == 0) {
			return;
		}
		var len : int = keyCalls.length;
		for (var i : int = 0; i < len; i++) {
			var data : Array = keyCalls[i];
			//TODO 战斗系统 更新keycall时，这里可能有BUG
			_keyCalls[data[0]] = {fun: data[1], params: data[2]};
		}
	}

	public function destroy() : void {
		_hasDestroy = true;
		mc.stop();
		mc.removeEventListener(Event.REMOVED_FROM_STAGE, __removedHandler);
		mc = null;
		mDurations = null;
		mStartTimes = null;
		_completeCalls = null;

		for (var key : String in _keyCalls) {
			delete _keyCalls[key];
		}
		_keyCalls = null;
	}

	/** @inheritDoc */
	public function advanceTime(passedTime : Number) : void {
		var finalFrame : int;
		var previousFrame : int = mCurrentFrame;

		if (mLoop && mCurrentTime == mTotalTime) {
			mCurrentTime = 0.0;
			mCurrentFrame = 0;
		}
		if (passedTime == 0.0 || mCurrentTime == mTotalTime)
			return;

		mCurrentTime += passedTime;
		finalFrame = totalFrame - 1;

		while (mCurrentTime >= mStartTimes[mCurrentFrame] + mDurations[mCurrentFrame]) {
			if (mCurrentFrame == finalFrame) {
				if (_completeCalls != null && _completeCalls.length != 0) {
					var restTime : Number = mCurrentTime - mTotalTime;
					mCurrentTime = mTotalTime;
					for each (var callback : Function in _completeCalls) {
						callback();
					}
					Juggler.removeMovieClip(mc);
					return;
				} else {
					mCurrentTime -= mTotalTime;
					mCurrentFrame = 0;
				}

			} else {
				mCurrentFrame++;
				if (_keyCalls != null) {
					var callBackData : * = _keyCalls[mCurrentFrame + 1];
					if (callBackData != null) {
						var callB : Function = callBackData.fun;
						var params : Array = callBackData.params;
						callB.apply(null, params);
					}
				}
			}
		}
		mc.gotoAndStop(mCurrentFrame + 1);
	}


	/** Returns the duration of a certain frame (in seconds). */
	public function getFrameDuration(frameID : int) : Number {
		return mDurations[frameID];
	}

	/** Sets the duration of a certain frame (in seconds). */
	public function setFrameDuration(frameID : int, duration : Number) : void {
		mTotalTime -= getFrameDuration(frameID);
		mTotalTime += duration;
		mDurations[frameID] = duration;
		updateStartTimes();
	}

	private function updateStartTimes() : void {
		mStartTimes.length = 0;
		mStartTimes[0] = 0;

		for (var i : int = 1; i < totalFrame; ++i)
			mStartTimes[i] = mStartTimes[i - 1] + mDurations[i - 1];
	}

	/**
	 * [frameIndex:call:Function, frameIndex:call:Function , ...]
	 */
	public function get keyCalls() : Array {
		return _keyCalls;
	}

	/**
	 * @private
	 */
	public function set keyCalls(value : Array) : void {
		_keyCalls = value;
	}

	public function get fps() : int {
		return _fps;
	}

	public function set fps(value : int) : void {
		_fps = value;

		var newFrameDuration : Number = 1.0 / _fps;
		var acceleration : Number = newFrameDuration / mDefaultFrameDuration;
		mCurrentTime *= acceleration;
		mDefaultFrameDuration = newFrameDuration;

		for (var i : int = 0; i < totalFrame; ++i) {
			setFrameDuration(i, getFrameDuration(i) * acceleration);
		}
	}

	public function get completeCalls() : Array {
		return _completeCalls;
	}

	public function set completeCalls(value : Array) : void {
		_completeCalls = value;
	}

}
}
