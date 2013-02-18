package com.xy.view.roles {
import com.xy.model.enum.Action;
import com.xy.model.enum.DataConfig;
import com.xy.model.enum.FPS;
import com.xy.model.vo.HeroVo;
import com.xy.util.EnterFrameCall;
import com.xy.util.Tools;
import com.xy.view.event.RoleEvent;

import flash.geom.Point;

import starling.animation.DelayedCall;
import starling.core.Starling;
import starling.display.MovieClip;
import starling.events.Event;
import starling.utils.deg2rad;
import starling.utils.getTimer;

public class Hero extends BaseRole {
	/**
	 * 被击后的无敌时间，单位：ms
	 */
	public static const SAFE_TIME : int = 1000;

	/**
	 * 连击序号
	 */
	private var _batterIndex : int;

	/**
	 * 最后一次普通攻击的时间
	 */
	private var _lastAttackTime : Number;

	/**
	 * 最后一次被击的时间，1S保护
	 */
	private var _lastUnderAttackTime : Number;

	/**
	 * 普通攻击特效
	 */
	private var _attackEffects : Array = [];

	/**
	 * 当前锁定的地图移动点，这个锁定优先级高于怪物
	 */
	private var _lockPosition : Point;

	private var _attackDelayCall : DelayedCall;

	/**
	 * 变身后的光效
	 */
	private var _superHeroEffect : MovieClip;

	/**
	 * 是否处于变身状态
	 */
	private var _isSuperHero : Boolean;

	private var _currentSp : int;

	public function Hero(vo : HeroVo) {
		super(vo);
		touchable = false;
	}

	/**
	 * 指定行走方法
	 * @return
	 */
	override protected function getWalkAction() : String {
		return Action.RUN;
	}

	/**
	 * 达到位置后，发起对话
	 */
	private function talk() : void {
		direction = Tools.calculateDirection(x, y, _lockRole.x, _lockRole.y);
		dispatchEventWith(RoleEvent.TALK_ACTION, false, _lockRole);
		unlockRole();
	}


	public function reset() : void {
		alpha = 1;
		_canAttackOrMove = 1;
		stopMove();
		unlockRole();
	}

	/**
	 * 攻击动作
	 */
	override public function attack() : void {
		/*对NPC不用打，说话*/
		if (_lockRole is Npc) {
			talk();
			return;
		}

		if (!_canAttackOrMove) {
			return;
		}

		stopMove();
		var time : int = getTimer();

		/*普通攻击连击*/
		if (time - _lastAttackTime > DataConfig.NORMAL_ATTACK_BATTER_LIMIT) {
			_batterIndex = 1;
		} else {
			_batterIndex++;

			if (_batterIndex > 4) {
				_batterIndex = 1;
			}
		}


		if (_lockRole != null) {
			direction = Tools.calculateDirection(x, y, _lockRole.x, _lockRole.y);
		}
		action = Action.ATTACK + _batterIndex;
		var tmpAction : String = _direction + "_" + action;

		if (_batterIndex == 4) {
			_attackEffects = [Assets.makeEffectMc(30001, "", FPS.NORMAL), Assets.makeEffectMc(30002, "", FPS.NORMAL)];
		} else {
			_attackEffects = [Assets.makeEffectMc(0, tmpAction, FPS.NORMAL)];
		}

		var fps : int;

		if (_isSuperHero) {
			fps = FPS.FAST;
		} else {
			fps = FPS.NORMAL;
		}
		var delay : Number = 1 / fps * DataConfig.getEffectFrame(_vo.gdcode, tmpAction);
		_attackDelayCall = Starling.juggler.delayCall(function() : void {
			for each (var effectMc : MovieClip in _attackEffects) {
				attachEffect(effectMc);
				effectMc.fps = fps;
			}
			dispatchEventWith(_action);
		}, delay);
		_canAttackOrMove = false;

		addAttackMomentum();
	}

	public function playAttackSound(hitSth : Boolean) : void {
		if (action.indexOf(Action.ATTACK) != -1) {
			var soundName : String = action;
			if(hitSth){
				soundName += "_ok";
			}
			SoundManager.play(soundName);
		}
	}

	/**
	 * 停止移动
	 */
	override public function stopMove() : void {
		super.stopMove();
		_lockPosition = null;
		SoundManager.stopWalkSound();
	}


	/**
	 * 锁定目标
	 * @param montser
	 */
	override public function lockRole(role : BaseRole) : void {
		super.lockRole(role);
		_lockPosition = null;
	}

	/**
	 * 锁定地图点
	 * @param p
	 */
	public function lockPostion(p : Point) : void {
		_lockRole = null;
		_lockPosition = p;
		checkLock();
	}

	/**
	 * 获取当前角色的攻击范围
	 * @return
	 */
	override public function getAttackRad() : Number {
		switch (_action) {
			case Action.ATTACK1:
				return deg2rad(180);
			case Action.ATTACK2:
			case Action.ATTACK3:
				return deg2rad(180);
			case Action.ATTACK4:
				return deg2rad(360);
		}
		return deg2rad(180);
	}

	/**
	 * 获取攻击移动的冲量
	 * @param action
	 * @return
	 */
	override public function getAttackMomentum(action : String) : Number {
		switch (action) {
			case Action.ATTACK1:
			case Action.ATTACK2:
			case Action.ATTACK3:
				return 8 * DataConfig.SCALE;
			case Action.ATTACK4:
				return 0;
		}
		return 0;
	}

	/**
	 * 获取攻击移动的冲量
	 * @param action
	 * @return
	 */
	override public function getUnderAttackMomentum(action : String) : Number {
		switch (action) {
			case Action.ATTACK1:
			case Action.ATTACK2:
			case Action.ATTACK3:
				return 8 * DataConfig.SCALE;
			case Action.ATTACK4:
				return 20 * DataConfig.SCALE;
		}
		return 0;
	}

	/**
	 * 当前的攻击力
	 * @return
	 */
	override public function getATK() : int {
		var addAtk : int = 0;
		switch (_action) {
			case Action.ATTACK1:
				addAtk = 10;
				break;
			case Action.ATTACK2:
			case Action.ATTACK3:
				addAtk = 6;
				break;
			case Action.ATTACK4:
				addAtk = 20;
				break;
		}
		return vo.atk + addAtk;
	}

	/**
	 * 播放升级动画
	 */
	public function playLevelUpMc() : void {
		var mc : MovieClip = Assets.makeEffectMc(30005, "", FPS.NORMAL, 4);
		attachEffect(mc);
		SoundManager.play("levelUp");
	}

	/**
	 * 显示变身后光效
	 */
	public function superModel() : void {
		if (_superHeroEffect == null) {
			_superHeroEffect = Assets.makeEffectMc(30006, "", FPS.NORMAL);
			_superHeroEffect.loop = true;
		}
		addChildAt(_superHeroEffect, 0);
		Starling.juggler.add(_superHeroEffect);
		_superHeroEffect.play();
		_isSuperHero = true;
	}

	/**
	 * 隐藏变身光效
	 */
	public function normalModel() : void {
		if (_superHeroEffect != null) {
			_superHeroEffect.removeFromParent();
			Starling.juggler.remove(_superHeroEffect);
			_superHeroEffect.stop();
		}

		_isSuperHero = false;
	}

	override public function dispose() : void {
		for each (var effectMc : MovieClip in _attackEffects) {
			Assets.collect(effectMc);
		}
		_attackEffects = [];
		_lockRole = null;

		super.dispose();
	}

	/**
	 * 被击
	 * @param attacker
	 */
	override public function underAttack(attacker : BaseRole) : Boolean {
		/*闲置的时候，被攻击，立即锁定目标*/
		if (_lockRole == null) {
			lockRole(attacker);
		}
		var now : Number = getTimer();
		/*被击保护时间内，不会再次被击*/
		if (now - _lastUnderAttackTime <= SAFE_TIME) {
			return false;
		}

		/*变身的时候，被击不会僵直*/
		if (!_isSuperHero) {
			super.underAttack(attacker);
			currentShowMc.setFrameDuration(currentShowMc.numFrames - 1, vo.gainTime / 1000);
		}

		var effectMc : MovieClip = Assets.makeEffectMc(30004, "", FPS.NORMAL);
		attachEffect(effectMc);

		/*被击的时候，不再添加攻击光效*/
		Starling.juggler.remove(_attackDelayCall);
		if (_attackEffects != null) {
			for each (effectMc in _attackEffects) {
				Assets.collect(effectMc);
			}
		}

		_lastUnderAttackTime = now;

		return true;
	}

//	override protected function moveRender():void{
//		SoundManager.playWalkSound();
//		super.moveRender();
//	}

	private var _soundMark : Array = [];

	/**
	 * 主角的动作处理
	 */
	override protected function updateMovieClip() : void {
		EnterFrameCall.del(updateMovieClip);
		var directionAction : String = _direction + "_" + _action;
		if (_currentShowAction == directionAction) {
			return;
		}

		var mc : MovieClip;
		if (_actionMcMap[directionAction] == null) {
			mc = Assets.makeRoleMc(vo.gdcode, directionAction, FPS.NORMAL);
			_actionMcMap[directionAction] = mc;
			mc.name = directionAction;
		} else {
			mc = _actionMcMap[directionAction];
		}

		if (_action.indexOf(Action.ATTACK) != -1) {
			if (_isSuperHero) {
				mc.fps = FPS.FAST;
			} else {
				mc.fps = FPS.NORMAL;
			}
		} else {
			mc.fps = FPS.NORMAL;
		}

		var currentShowMc : MovieClip = getChildByName(_currentShowAction) as MovieClip;
		if (mc != currentShowMc) {
			if (currentShowMc != null) {
				Tools.remove(this, currentShowMc);
				Starling.juggler.remove(currentShowMc);
				currentShowMc.stop();
			}

			addChildAt(mc, _isSuperHero ? 1 : 0);
			Starling.juggler.add(mc);
			mc.play();
		}
		_currentShowAction = directionAction;

		mcLoopUpdate();

//		if(action == Action.RUN && _soundMark[_currentShowAction] == null){
//			mc.setFrameSound(0, Assets.getSound("walk1"));
//			mc.setFrameSound(10, Assets.getSound("walk2"));
//			_soundMark[_currentShowAction] = "added";
//		}
	}

	/**
	 * 某个动作播放完成
	 * @param e
	 */
	override protected function __mcPlayCompleteHandler(e : Event) : void {
		var mc : MovieClip = e.currentTarget as MovieClip;
		var mcAction : String = _action;

		/*记录最后一次普通攻击的事件*/
		if (mcAction.indexOf(Action.ATTACK) != -1) {
			_lastAttackTime = getTimer();
		}

		super.__mcPlayCompleteHandler(e);
	}

	/**
	 * 移动完成后，检查目标是否达到，如果没达到，继续追
	 */
	override protected function moveComplete() : void {
		_lockPosition = null;
		super.moveComplete();
	}

	/**
	 * 锁定后，检查移动
	 */
	override protected function checkLock() : void {
		if (_lockRole != null) {
			super.checkLock();
		} else if (_lockPosition != null) {
			moveTo(_lockPosition.x, _lockPosition.y);
		}
	}

	/**
	 * 添加攻击动作的冲量
	 */
	private function addAttackMomentum() : void {
		var momentum : int = getAttackMomentum(_action);
		var p : Point;
		if (_lockRole == null) {
			p = Tools.calSpeedByDirection(_direction, momentum);
		} else {
			p = Tools.calSpeedXY(x, y, _lockRole.x, _lockRole.y, momentum);
		}

		addMoveMomentum(x + p.x, y + p.y, currentShowMc.numFrames / currentShowMc.fps);
	}

	public function get VO() : HeroVo {
		return _vo as HeroVo;
	}

	/**
	 * 当前能量值
	 */
	public function get currentSp() : int {
		return _currentSp;
	}

	/**
	 * @private
	 */
	public function set currentSp(value : int) : void {
		if (value < 0) {
			value = 0;
		}

		if (value > VO.maxSp) {
			value = VO.maxSp;
		}

		_currentSp = value;
	}

	/**
	 * SP是否满了
	 * @return
	 */
	public function isSpFull() : Boolean {
		return _currentSp == VO.maxSp;
	}

}
}
