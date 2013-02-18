package com.xy.view.roles {
import com.xy.model.enum.Action;
import com.xy.model.enum.Direction;
import com.xy.model.enum.FPS;
import com.xy.model.vo.NpcVo;
import com.xy.util.EnterFrameCall;
import com.xy.util.Tools;

import starling.animation.DelayedCall;
import starling.core.Starling;
import starling.display.MovieClip;
import starling.text.TextField;

/**
 * NPC
 * @author xy
 */
public class Npc extends BaseRole {
	private var _newTaskMc : MovieClip;
	private var _finishTaskMc : MovieClip;
	private var _name : TextField;

	private var _randomDirectios : Array = [Direction.LB, Direction.LU, Direction.RB, Direction.RU];

	private var _timeOut : DelayedCall;

	public function Npc(vo : NpcVo) {
		super(vo);
		
		_name = new TextField(130, 40, vo.name, "Verdana", 20, 0xFFFFFF, true);
		_name.pivotX = 130 >> 1;
		_name.pivotY = 40;
		addChild(_name);
		_name.y = -currentShowMc.height + 20;

		_timeOut = Starling.juggler.delayCall(randomDirection, 3);


	}

	/**
	 * 随机换方向
	 */
	private function randomDirection() : void {
		var t : int = Tools.random(6000, 15000);
		var newDirection : String = _randomDirectios[Tools.random(0, 3)];
		direction = newDirection;
		_timeOut = Starling.juggler.delayCall(randomDirection, t / 1000);
	}

	public function get VO() : NpcVo {
		return _vo as NpcVo;
	}

	override protected function updateMovieClip() : void {
		EnterFrameCall.del(updateMovieClip);
		var directionAction : String = _direction + "_" + _action;
		if (_currentShowAction == directionAction) {
			return;
		}
		var needLoop : Boolean = Action.actionCanLoop(_action);

		var tmpDirectionAction : String = directionAction;
		if (directionAction.charAt(1) == "B") {
			tmpDirectionAction = tmpDirectionAction.replace("R", "L");
		} else {
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

		if (tmpDirectionAction == directionAction) {
			mc.scaleX = Math.abs(mc.scaleX);
		} else {
			mc.scaleX = -Math.abs(mc.scaleX);
		}

		if (mc != currentShowMc) {
			if (currentShowMc != null) {
				Tools.remove(this, currentShowMc);
				Starling.juggler.remove(currentShowMc);
				currentShowMc.stop();
			}

			addChild(mc);
			Starling.juggler.add(mc);
			mc.play();
		}

		_currentShowAction = directionAction;

		mcLoopUpdate();
	}

	public function showNewTask() : void {
		hideTask();
		if (_newTaskMc == null) {
			_newTaskMc = Assets.makeUiMc("newTask", 1, true);
			_newTaskMc.pivotX = _newTaskMc.width / 2;
			_newTaskMc.pivotY = _newTaskMc.height;
			_newTaskMc.y = -currentShowMc.height;
			_newTaskMc.scaleX = _newTaskMc.scaleY = 2;
		}

		addChild(_newTaskMc);
		Starling.juggler.add(_newTaskMc);
		_newTaskMc.play();

	}

	public function showFinishTask() : void {
		hideTask();
		if (_finishTaskMc == null) {
			_finishTaskMc = Assets.makeUiMc("finishTask", 1, true);
			_finishTaskMc.pivotX = _finishTaskMc.width / 2;
			_finishTaskMc.pivotY = _finishTaskMc.height;
			_finishTaskMc.y = -currentShowMc.height;
			_finishTaskMc.scaleX = _finishTaskMc.scaleY = 2;
		}

		addChild(_finishTaskMc);
		Starling.juggler.add(_finishTaskMc);
		_finishTaskMc.play();
	}

	private function hideTask() : void {
		if (_newTaskMc != null) {
			_newTaskMc.removeFromParent();
			Starling.juggler.remove(_newTaskMc);
			_newTaskMc.stop();
		}
		if (_finishTaskMc != null) {
			_newTaskMc.removeFromParent();
			Starling.juggler.remove(_finishTaskMc);
			_finishTaskMc.stop();
		}
	}

	/**
	 * 被对话
	 * @param baseRole
	 */
	public function beenTalk(baseRole : BaseRole) : void {
		var newDirection : String = Tools.calculateDirection(x, y, baseRole.x, baseRole.y);
		direction = newDirection;
	}

	override protected function moveRender() : void {

	}

	override public function dispose() : void {

		if (_name != null) {
			_name.dispose();
		}
		if (_newTaskMc != null) {
			_newTaskMc.dispose();
		}
		if (_finishTaskMc != null) {
			_finishTaskMc.dispose();
		}
		Starling.juggler.remove(_timeOut);
		super.dispose();
	}

	/**
	* 是否已经死亡
	* @return
	*/
	override public function get isDie() : Boolean {
		return false;
	}

	/**
	 * 是否还活着
	 * @return
	 */
	override public function get isAlive() : Boolean {
		return true;
	}
}
}
