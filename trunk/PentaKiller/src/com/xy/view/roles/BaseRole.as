package com.xy.view.roles {
import com.xy.model.enum.Action;
import com.xy.model.enum.Direction;
import com.xy.model.enum.FPS;
import com.xy.model.vo.BaseVo;
import com.xy.util.EnterFrameCall;
import com.xy.util.PkRectangle;
import com.xy.util.Tools;
import com.xy.view.event.RoleEvent;

import flash.geom.Point;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.events.Event;

public class BaseRole extends Sprite {
	protected var _id : int;

	protected var _gdcode : int;

	/**
	 * 当前动作的数组
	 */
	protected var _actionMcMap : Array = [];

	protected var _direction : String;

	protected var _action : String;

	/**
	 * 当前的方向+动作
	 */
	protected var _currentShowAction : String;

	/**
	 * 当前寻路的路点
	 */
	protected var _roadTarget : Point = new Point();
	protected var _speedX : Number;
	protected var _speedY : Number;
	protected var _speedXValue : Number;
	protected var _speedYValue : Number;

	protected var _vo : BaseVo;

	protected var _tween : Tween;

	protected var _bodyRect : PkRectangle;

	/**
	 * 当前锁定的目标
	 */
	protected var _lockRole : BaseRole;

	/**
	 * 上次移动是否遇到碰撞了
	 */
	protected var _prevMoveHasHit : Boolean;

	/**
	 * 是否能进行攻击动作
	 */
	protected var _canAttackOrMove : Boolean = true;

	protected var _currentHp : int;

	public function BaseRole(vo : BaseVo) {
		super();
		_vo = vo;
		_currentHp = _vo.maxHp;
		_direction = Direction.LB;
		_action = Action.STAND;
		updateMovieClip();
		_tween = new Tween(this, 0);
		_bodyRect = new PkRectangle(0, 0, _vo.bodyRadius << 1, _vo.bodyRadius, true);
	}

	/**
	 * 移动到某点 ，终点
	 * @param p
	 */
	public function moveTo(px : Number, py : Number) : void {
		if (!_canAttackOrMove) {
			return;
		}

		if (Math.abs(px - x) < 1 && Math.abs(py - y) < 1) {
			return;
		}
		_roadTarget.setTo(px, py);
		_prevMoveHasHit = false;
		calSpeed();
		action = getWalkAction();
		EnterFrameCall.add(moveRender);
	}

	/**
	 * 停止移动
	 */
	public function stopMove() : void {
		EnterFrameCall.del(moveRender);
		action = Action.STAND;
		_prevMoveHasHit = false;
	}

	/**
	 * 攻击 动作
	 */
	public function attack() : void {
		if (!_canAttackOrMove) {
			return;
		}

		EnterFrameCall.del(moveRender);
		action = Action.ATTACK;
	}

	/**
	 * 被攻击了
	 */
	public function underAttack(attacker : BaseRole) : Boolean {
		stopMove();
		action = Action.HIT;
		_canAttackOrMove = false;

		return true;
	}

	/**
	 * 设置伤害值
	 * @param hurt
	 */
	public function setHurt(hurt : int) : void {
		_currentHp -= hurt;
		if (_currentHp < 0) {
			_currentHp = 0;
		}

		if (_currentHp <= 0) {
			action = Action.DIE;
			_speedX = _speedY = _speedXValue = _speedYValue = 0;
			_canAttackOrMove = false;
			EnterFrameCall.del(moveRender);
			unlockRole();
		}
	}
	
	/**
	 * 获取当前角色的攻击范围
	 * @return
	 */
	public function getAttackRad() : Number {
		return 0;
	}

	/**
	 * 获取攻击移动的冲量
	 * @param action
	 * @return
	 */
	public function getAttackMomentum(action : String) : Number {
		return 0;
	}

	/**
	 * 获取攻击移动的冲量
	 * @param action
	 * @return
	 */
	public function getUnderAttackMomentum(action : String) : Number {
		return 0;
	}

	/**
	 * 获取该角色的攻击力
	 * @return
	 */
	public function getATK() : int {
		return vo.atk;
	}

	/**
	* 获取该角色的攻击力
	* @return
	*/
	public function getDefense() : int {
		return vo.defense;
	}

	/**
	 * 添加攻击动作的冲量
	 */
	public function addMoveMomentum(momentnumX : int, momentnumY : int, tweenTime : Number = 0) : void {
		if (tweenTime <= 0) {
			x = momentnumX;
			y = momentnumY;
		} else {
			_tween.reset(this, tweenTime);
			_tween.moveTo(momentnumX, momentnumY);
			Starling.juggler.add(_tween);
		}
	}

	/**
	 * 设置动作，但不立即更改动作
	 * @param value
	 */
	public function setActionDelay(value : String) : void {
		if (_action == value) {
			return;
		}
		_action = value;

		EnterFrameCall.add(updateMovieClip);
	}

	/**
	 * 锁定目标
	 * @param montser
	 */
	public function lockRole(role : BaseRole) : void {
		if (_lockRole == role) {
			return;
		}
		unlockRole();

		_lockRole = role;
		checkLock();

		_lockRole.addEventListener(RoleEvent.DEAD, __lockRoleDeadHandler);
	}

	/**
	 * 解锁 目标
	 * @return
	 */
	public function unlockRole() : void {
		if (_lockRole != null) {
			_lockRole.removeEventListener(RoleEvent.DEAD, __lockRoleDeadHandler);
		}
		_lockRole = null;
	}

	/**
	 * 销毁
	 */
	override public function dispose() : void {
		stopMove();
		this.removeFromParent();
		var currentShowMc : MovieClip = getChildByName(_currentShowAction) as MovieClip;
		if (currentShowMc != null) {
			Starling.juggler.remove(currentShowMc);
			currentShowMc.stop();
		}

		for each (var mc : MovieClip in _actionMcMap) {
			Assets.collect(mc);
			Starling.juggler.remove(mc);

			if (mc.hasEventListener(Event.COMPLETE)) {
				mc.removeEventListeners(Event.COMPLETE);
			}
		}

		EnterFrameCall.del(updateMovieClip);
		_actionMcMap = null;
		Starling.juggler.remove(_tween);
		_tween = null;
		_vo = null;
		Tools.clear(this);
		super.dispose();
	}

	/**
	 * 添加光效
	 * @param effectMc
	 */
	protected function attachEffect(effectMc : MovieClip) : void {
		effectMc.touchable = false;
		addChild(effectMc);
		Starling.juggler.add(effectMc);
		effectMc.play();
		effectMc.loop = false;
		effectMc.addEventListener(Event.COMPLETE, __effectPlayOverHandler);
	}

	/**
	 * 根据速度，计算移动向量
	 */
	protected function calSpeed(moveSpeed : int = -1) : void {
		var speed : Point = Tools.calSpeedXY(x, y, _roadTarget.x, _roadTarget.y, moveSpeed == -1 ? vo.moveSpeed : moveSpeed);

		var maxAddX : Number = _roadTarget.x - x;
		var maxAddY : Number = _roadTarget.y - y;

		_speedX = speed.x;
		_speedY = speed.y;
		_speedXValue = Math.abs(_speedX);
		_speedYValue = Math.abs(_speedY);
	}

	/**
	 * 走路渲染
	 */
	protected function moveRender() : void {
		if (_lockRole != null) {
			if (Tools.ACanAttackB(this, _lockRole)) {
				if (attackCD) {
					stopMove();
					attack();
				} else {
					action = Action.STAND;
					_prevMoveHasHit = false;
				}
				return;
			}


			if (_lockRole.x != _roadTarget.x || _lockRole.y != _roadTarget.y) {
				refreshTarget();
			}
		}

		action = getWalkAction();

		currentShowMc.fps = Tools.calLen(0, 0, _speedX, _speedY) / vo.moveSpeed * FPS.NORMAL;

		if (x == _roadTarget.x && y == _roadTarget.y) {
			moveComplete();
			return;
		}

		var prevX : Number = x;
		var prevY : Number = y;
		//更新方向
		var newDirection : String = Tools.calculateDirection(x, y, _roadTarget.x, _roadTarget.y);
		if (x != _roadTarget.x || _prevMoveHasHit) {
			prevX = x + _speedX;
		}
		if (y != _roadTarget.y || _prevMoveHasHit) {
			prevY = y + _speedY;
		}

		var hasHit : Boolean = false;
		var loopMax : int = 3;
		var loopIndex : int = 0;
		while (Tools.bafflesHitTest(prevX, prevY - (vo.bodyRadius >> 1), id) && loopIndex < loopMax) {
			prevY += _speedYValue / loopMax;
			hasHit = true;
			loopIndex++;
		}
		loopIndex = 0;
		while (Tools.bafflesHitTest(prevX, prevY + (vo.bodyRadius >> 1), id) && loopIndex < loopMax) {
			prevY -= _speedYValue / loopMax;
			hasHit = true;
			loopIndex++;
		}

		loopIndex = 0;
		while (Tools.bafflesHitTest(prevX - vo.bodyRadius, prevY, id) && loopIndex < loopMax) {
			prevX += _speedXValue / loopMax;
			hasHit = true;
			loopIndex++;
		}
		loopIndex = 0;
		while (Tools.bafflesHitTest(prevX - vo.bodyRadius, prevY, id) && loopIndex < loopMax) {
			prevX -= _speedXValue / loopMax;
			hasHit = true;
			loopIndex++;
		}

		var prevDirection : String = Tools.calculateDirection(prevX, prevY, _roadTarget.x, _roadTarget.y);
		if (prevDirection != newDirection && Tools.calLen(x, y, _roadTarget.x, _roadTarget.y) < vo.moveSpeed) {
			x = _roadTarget.x;
			y = _roadTarget.y;
		} else {
			/*如果每次位移量小于移动速度，则改变力的方向*/
			var absX : Number = Math.abs(prevX - x);
			var absY : Number = Math.abs(prevY - y);
			var halfSpeed : Number = vo.moveSpeed >> 1;
			if (absX <= halfSpeed && absY <= halfSpeed) {
				var absSpeedX : Number = Math.abs(_speedX);
				var absSpeedY : Number = Math.abs(_speedY);

				if (absSpeedX < 0.001) {
					_speedX = _direction.charAt(1) == "B" ? halfSpeed : -halfSpeed;
				} else if (absSpeedX < 1) {
					_speedX = _speedX > 0 ? halfSpeed : -halfSpeed;
				}

				if (absSpeedY < 0.001) {
					_speedY = _direction.charAt(0) == "L" ? halfSpeed : -halfSpeed;
				} else if (absSpeedY < 1) {
					_speedY = _speedY > 0 ? halfSpeed : -halfSpeed;
				}
			}
			x = prevX;
			y = prevY;
		}
		//更新方向
		direction = newDirection;

		if (!_prevMoveHasHit && !hasHit) {
			calSpeed();
		}

		_prevMoveHasHit = hasHit;

		/*与终点处障碍有碰撞，视为到达目的地*/
		var targetRect : PkRectangle = Tools.bafflesHitTest(_roadTarget.x, _roadTarget.y, id);
		if (hasHit && targetRect) {
			if (targetRect.intersects(bodyRect)) {
				moveComplete();
			}
		}
	}

	/**
	 * 移动任务完成
	 */
	protected function moveComplete() : void {
		/*移动完成后，检查是有有锁定的目标*/
		if (_lockRole != null && _lockRole.isAlive) {
			checkLock();
		} else {
			stopMove();
		}
	}

	/**
	 * 更换动作后，需要重新显示动画
	 */
	protected function updateMovieClip() : void {
		mcLoopUpdate();
	}

	/**
	 * 重新设置MC是否需要循环播放，及over事件
	 */
	protected function mcLoopUpdate() : void {
		var needLoop : Boolean = Action.actionCanLoop(_action);
		var currentShowMc : MovieClip = getChildByName(_currentShowAction) as MovieClip;
		currentShowMc.loop = needLoop;
		if (!needLoop && !currentShowMc.hasEventListener(Event.COMPLETE)) {
			currentShowMc.addEventListener(Event.COMPLETE, __mcPlayCompleteHandler);
		}
	}

	/**
	 * 某个动作播放完成
	 * @param e
	 */
	protected function __mcPlayCompleteHandler(e : Event) : void {
		var mc : MovieClip = e.currentTarget as MovieClip;
		
		if (mc.name.indexOf(Action.DIE) == -1) {
			setActionDelay(Action.STAND);
			_canAttackOrMove = true;
			checkLock();
		} else {
			playDeadEffect();
		}
	}

	protected function __effectPlayOverHandler(e : Event) : void {
		var mc : MovieClip = e.currentTarget as MovieClip;
		mc.removeEventListeners(Event.COMPLETE);
		Assets.collect(mc);
		mc.removeFromParent();
		Starling.juggler.remove(mc);
	}

	/**
	 * 指定行走方法
	 * @return
	 */
	protected function getWalkAction() : String {
		return Action.WALK;
	}

	/**
	 * 锁定后，检查移动
	 */
	protected function checkLock() : void {
		if (_lockRole != null && _lockRole.isAlive) {
			moveTo(_lockRole.x, _lockRole.y);
		}
	}

	/**
	* 刷新移动时，目标点的位置
	*/
	protected function refreshTarget() : void {
		_roadTarget.x = _lockRole.x;
		_roadTarget.y = _lockRole.y;
		_prevMoveHasHit = false;
		calSpeed();
	}

	/**
	 * 播放消失的动画
	 */
	protected function playDeadEffect() : void {
		var tween : Tween = new Tween(this, 0.3);
		tween.fadeTo(0);
		tween.onComplete = deadTweenComplete;
		Starling.juggler.add(tween);
	}

	protected function deadTweenComplete() : void {
		dispatchEventWith(RoleEvent.DEAD);
	}

	/**
	 * 锁定的目标死了
	 * @param e
	 */
	protected function __lockRoleDeadHandler(e : Event) : void {
		unlockRole();
	}

	/**
	 * ID
	 */
	public function get id() : int {
		return _id;
	}

	/**
	 * 资源ID
	 */
	public function get gdcode() : int {
		return _gdcode;
	}

	/**
	 * 当前的方向
	 */
	public function get direction() : String {
		return _direction;
	}

	/**
	 * @protected
	 */
	public function set direction(value : String) : void {
		if (_direction == value) {
			return;
		}
		_direction = value;
		updateMovieClip();
	}

	/**
	 * 当前的动作
	 */
	public function get action() : String {
		return _action;
	}

	/**
	 * @protected
	 */
	public function set action(value : String) : void {
		if (_action == value) {
			return;
		}

		if (this is Monster) {
			//trace(_action, value, getTimer());
		}
		_action = value;
		updateMovieClip();
	}

	/**
	 * 属性
	 */
	public function get vo() : BaseVo {
		return _vo;
	}

	/**
	 * 当前显示的MC
	 * @return
	 */
	public function get currentShowMc() : MovieClip {
		return getChildByName(_currentShowAction) as MovieClip;
	}

	/**
	 * 身体大小
	 */
	public function get bodyRect() : PkRectangle {
		_bodyRect.x = -_vo.bodyRadius + x;
		_bodyRect.y = -(_vo.bodyRadius >> 1) + y;
		return _bodyRect;
	}

	/**
	 * 攻击是否CD了
	 * @return
	 */
	public function get attackCD() : Boolean {
		return true;
	}

	/**
	 * 是否已经死亡
	 * @return
	 */
	public function get isDie() : Boolean {
		return _currentHp <= 0;
	}

	/**
	 * 是否还活着
	 * @return
	 */
	public function get isAlive() : Boolean {
		return _currentHp > 0;
	}

	/**
	 * 当前的血量
	 */
	public function get currentHp() : int {
		return _currentHp;
	}

	public function set currentHp(value : int) : void {
		if (value > vo.maxHp) {
			value = vo.maxHp;
		}
		_currentHp = value;
	}


}
}
