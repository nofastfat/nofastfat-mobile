package com.xy.view.roles {
import com.xy.model.PKDataProxy;
import com.xy.model.enum.Action;
import com.xy.model.enum.DataConfig;
import com.xy.model.enum.FPS;
import com.xy.model.vo.MonsterVo;
import com.xy.util.EnterFrameCall;
import com.xy.util.Tools;
import com.xy.util.factories.HpBarFactory;
import com.xy.view.event.RoleEvent;
import com.xy.view.sprite.HpBar;

import flash.geom.Point;
import flash.utils.getTimer;

import org.puremvc.as3.patterns.facade.Facade;

import starling.core.Starling;
import starling.display.Image;
import starling.display.MovieClip;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.deg2rad;

public class Monster extends BaseRole {

	private var _isActive : Boolean;

	private var _lastAttackTime : Number = 0;

	public var _hpBar : HpBar;

	/**
	 * 巡逻中
	 */
	private var _isRoaming : Boolean = false;

	private var _enterFrameCount : int;

	private var _roamFrameRateInterval : int = DataConfig.ROAM_INTERVAL * FPS.STAGE / 1000;

	public function Monster(vo : MonsterVo, id : int) {
		super(vo);
		_id = id;
		_bodyRect.ownerId = _id;
		
		addHpBar();
		addEventListener(TouchEvent.TOUCH, __touchHandler);
		//addMask();
	}

	private function addMask() : void {
		//警戒范围
		var img : Image = Tools.makeImg(vO.warnAttackRadius, 0x330000);
		img.pivotX = img.pivotY = vO.warnAttackRadius;
		addChildAt(img, 0);
	}

	/**
	 * ai行为
	 */
	public function ai() : void {
		if (_enterFrameCount % _roamFrameRateInterval == 0) {
			/*巡逻检查*/
			roam();
		}
		if (_enterFrameCount % (FPS.STAGE >> 1) == 0) {
			/*自己警戒检查*/
			warnAttack();

			/*友军警戒检查*/
			friendWarnAttack();
		}
		_enterFrameCount++;
	}

	/**
	 * 检查是否需要巡逻
	 */
	public function roam() : void {
		/*是否开始巡逻*/
		if (vO.roamRadius == 0 || !isActive || !_canAttackOrMove || isDie || _lockRole != null || action != Action.STAND) {
			return;
		}

		var pt : Point = Tools.randomInCircle(vO.birthLocation.x, vO.birthLocation.y, vO.roamRadius);
		_isRoaming = true;
		moveTo(pt.x, pt.y);
	}

	/**
	 * 检查是否有敌人闯入警戒范围
	 * 激活后，才会检查
	 */
	public function warnAttack() : void {
		if (_lockRole != null) {
			return;
		}

		/*检查*/
		var hero : Hero = getHero();
		if (_isRoaming && Tools.calLen(x, y, hero.x, hero.y) <= vO.warnAttackRadius) {
			isActive = true;
			lockRole(hero);
		}
	}

	/**
	 * 检查是否有敌人闯入警戒范围
	 * 激活后，才会检查
	 */
	public function friendWarnAttack() : void {
		if (_lockRole != null) {
			return;
		}

		/*检查*/
		var mons : Array = getMonsters();
		for each (var mon : Monster in mons) {
			if (_isRoaming && mon._lockRole != null && Tools.calLen(vO.birthLocation.x, vO.birthLocation.y, mon.x, mon.y) <= vO.friendWarnRadius) {
				isActive = true;
				lockRole(mon._lockRole);
			}
		}
	}



	override public function setHurt(hurt : int) : void {
		super.setHurt(hurt);

		_hpBar.setHp(_currentHp, vo.maxHp);

		if (isDie) {
			_hpBar.removeFromParent();
			SoundManager.play("die" + vO.gdcode);
		}
	}

	/**
	 * 攻击 动作
	 */
	override public function attack() : void {
		if (_lockRole != null) {
			direction = Tools.calculateDirection(x, y, _lockRole.x, _lockRole.y);
		}
		super.attack();
		
		var directionAction : String = direction + "_" + Action.ATTACK;
		if(directionAction.charAt(1) == "B"){
			directionAction = directionAction.replace("R", "L");
		}else{
			directionAction = directionAction.replace("L", "R");
		}
		
		var attackEffect : int = DataConfig.getEffectFrame(_vo.gdcode, directionAction);
		if(attackEffect == 0){
			attackEffect = currentShowMc.numFrames;
		}
		var delay : Number = 1 / FPS.NORMAL * attackEffect;
		if (delay != 0) {
			Starling.juggler.delayCall(function() : void {
				dispatchEventWith(Action.ATTACK);
			}, delay);
		} else {
			dispatchEventWith(Action.ATTACK);
		}
		_lastAttackTime = getTimer();
		_canAttackOrMove = false;
	}

	/**
	 * 被打动作
	 * @param attacker
	 */
	override public function underAttack(attacker : BaseRole) : Boolean {
		/*闲置的时候，被攻击，立即锁定目标*/
		if (_lockRole == null) {
			lockRole(attacker);
		}

		super.underAttack(attacker);

		currentShowMc.setFrameDuration(currentShowMc.numFrames - 1, vo.gainTime / 1000);
		var effectMc : MovieClip = Assets.makeEffectMc(30003, "", FPS.NORMAL);
		attachEffect(effectMc);

		addUnderAttackMomentum(attacker);

		return true;
	}
	
	/**
	 * 获取当前角色的攻击范围
	 * @return
	 */
	override public function getAttackRad() : Number {
		return deg2rad(180);
	}

	override public function dispose() : void {
		HpBarFactory.collectToPool(_hpBar);
		removeEventListeners(TouchEvent.TOUCH);
		EnterFrameCall.del(ai);
		super.dispose();
	}

	/**
	* 攻击是否CD了
	* @return
	*/
	override public function get attackCD() : Boolean {
		return getTimer() - _lastAttackTime > vo.attackLimitTime;
	}

	/**
	 * 根据速度，计算移动向量
	 */
	override protected function calSpeed(moveSpeed : int = -1) : void {
		super.calSpeed(_isRoaming ? vO.roamSpeed : vo.moveSpeed);
	}

	override public function lockRole(role : BaseRole) : void {
		/*锁定目标时，速度归为正常*/
		_isRoaming = false;
		super.lockRole(role);
	}

	override protected function moveRender() : void {
		super.moveRender();

		/*如果当前距离小于*/
		if (Tools.calLen(x, y, vO.birthLocation.x, vO.birthLocation.y) > vO.pursueAttackRadius) {
			unlockRole();
			moveTo(vO.birthLocation.x, vO.birthLocation.y);
		}
	}

	override protected function updateMovieClip() : void {
		EnterFrameCall.del(updateMovieClip);
		var directionAction : String = _direction + "_" + _action;
		if (_currentShowAction == directionAction) {
			return;
		}
		var needLoop : Boolean = Action.actionCanLoop(_action);

		var tmpDirectionAction : String = directionAction;
		if(directionAction.charAt(1) == "B"){
			tmpDirectionAction = tmpDirectionAction.replace("R", "L");
		}else{
			tmpDirectionAction = tmpDirectionAction.replace("L", "R");
		}
		
		var mc : MovieClip;
		var currentShowMc : MovieClip = getChildByName(_currentShowAction) as MovieClip;

		/*怪物是左右镜像的资源*/
		if (_actionMcMap[tmpDirectionAction] == null) {
			mc = Assets.makeRoleMc(vo.gdcode, tmpDirectionAction, FPS.NORMAL);
			_actionMcMap[tmpDirectionAction] = mc;
		} else {
			mc = _actionMcMap[tmpDirectionAction];
		}

		mc.loop = needLoop;
		mc.name = directionAction;
		
		if(tmpDirectionAction == directionAction){
			mc.scaleX = Math.abs(mc.scaleX);
		}else{
			mc.scaleX = -Math.abs(mc.scaleX);
		}

		if (mc != currentShowMc) {
			if (currentShowMc != null) {
				Tools.remove(this, currentShowMc);
				Starling.juggler.remove(currentShowMc);
				currentShowMc.stop();
			}

			addChildAt(mc, 0);
			Starling.juggler.add(mc);
			mc.play();
		}

		_currentShowAction = directionAction;

		mcLoopUpdate();
	}

	/**
	 * 添加被击位移
	 * @param attacker
	 */
	private function addUnderAttackMomentum(attacker : BaseRole) : void {
		var momentum : int = attacker.getUnderAttackMomentum(attacker.action);
		var p : Point = Tools.calSpeedXY(attacker.x, attacker.y, x, y, momentum);
		//addMoveMomentum(x+p.x, y+p.y, currentShowMc.numFrames/currentShowMc.fps);
		addMoveMomentum(x + p.x, y + p.y);
	}

	/**
	 * 事件
	 * @param e
	 */
	private function __touchHandler(e : TouchEvent) : void {
		var touch : Touch = e.touches[0];
		if (touch.phase == TouchPhase.ENDED || touch.phase == TouchPhase.MOVED) {
			dispatchEventWith(RoleEvent.CLICK_MONSTER);
		}
	}

	/**
	 * 添加一个HP条
	 */
	private function addHpBar() : void {
		_hpBar = HpBarFactory.make();
		_hpBar.width = currentShowMc.width * 0.6;
		_hpBar.y = -currentShowMc.height - _hpBar.height;
		_hpBar.x = -_hpBar.width / 2;
		addChild(_hpBar);
		_hpBar.setPercent(1);
	}

	private function getHero() : Hero {
		return (Facade.getInstance().retrieveProxy(PKDataProxy.NAME) as PKDataProxy).hero;
	}

	private function getMonsters() : Array {
		return (Facade.getInstance().retrieveProxy(PKDataProxy.NAME) as PKDataProxy).liveMonsters;
	}

	public function get vO() : MonsterVo {
		return _vo as MonsterVo;
	}

	/**
	 * 当前是否处于激活状态
	 */
	public function get isActive() : Boolean {
		return _isActive;
	}

	/**
	 * @private
	 */
	public function set isActive(value : Boolean) : void {
		_isActive = value;

		if (_isActive && isAlive) {
			EnterFrameCall.add(ai);
			_enterFrameCount = 0;
		} else {
			EnterFrameCall.del(ai);
		}
	}

}
}
