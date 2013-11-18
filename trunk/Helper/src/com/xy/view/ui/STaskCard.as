package com.xy.view.ui {
import com.greensock.TweenLite;
import com.xy.component.toolTip.ToolTip;
import com.xy.component.toolTip.enum.ToolTipMode;
import com.xy.model.vo.TaskVo;
import com.xy.ui.TaskCard;
import com.xy.util.EnterFrameCall;
import com.xy.util.STool;
import com.xy.view.event.STaskCardEvent;
import com.xy.view.event.TreeContainerEvent;

import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.URLRequest;
import flash.text.TextFormat;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

/**
 * 目标卡片
 * @author xy
 */
public class STaskCard extends TaskCard {
	private var _vo : TaskVo;

	private var _rect : Rectangle;
	private var _lastLocation : Point = new Point();

	private var _selected : Boolean = false;
	private var _loader : Loader;

	private static var _BOLD : TextFormat = new TextFormat(null, null, null, "bold");

	public function STaskCard() {
		super();
		_rect = new Rectangle(0, 0, width, height);
		ctrlBtn.addEventListener(MouseEvent.CLICK, __showChildHandler);

		iconContainer.mouseChildren = false;
		iconContainer.mouseEnabled = false;
		stateMc.mouseChildren = false;
		stateMc.mouseEnabled = false;
		statusBar.mouseChildren = false;
		statusBar.mouseEnabled = false;
		bg.addEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
		EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_UP, __upHandler);

		targetTf.defaultTextFormat = _BOLD;
		bolder0.setTextFormat(_BOLD);
		bolder1.setTextFormat(_BOLD);
		taskValueTf.defaultTextFormat = _BOLD;
		totalTaskTf.defaultTextFormat = _BOLD;
	}

	public function setData(vo : TaskVo) : void {
		_vo = vo;

		if (_loader != null) {
			_loader.unload();
		}
		_loader = new Loader();
		_loader.load(new URLRequest(vo.imgUrl));
		_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e : Event) : void {});
		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e : Event) : void {
			_loader.width = iconContainer.bg.width - 3;
			_loader.height = iconContainer.bg.height - 3;
		});
		_loader.x = _loader.y = 1;
		iconContainer.addChild(_loader);

		targetTf.text = _vo.taskName;
		nameTf.text = _vo.name;
		jobTf.text = _vo.job;
		companyTf.text = _vo.company;
		totalTaskTf.text = _vo.taskValue;
		taskValueTf.text = _vo.taskCurrentValue;
		stateMc.gotoAndStop(_vo.statusValue + 1);
		bg.gotoAndStop(_vo.statusValue + 1);
		ctrlBtn.gotoAndStop(_vo.statusValue + 1);

		ToolTip.setSimpleTip(targetTf, _vo.makeTipString(), ToolTipMode.RIGHT_TOP);

		ctrlBtn.visible = _vo.subLen != 0;

		STool.minSizeTextfields([targetTf, nameTf, jobTf, companyTf, totalTaskTf, taskValueTf], true);


		var per : Number = _vo.statusPercent / 100;

		if (per < 0) {
			per = 0;
		}

		if (per > 1) {
			per = 1;
		}

		TweenLite.to(statusBar.bar, 0.3, {width: (statusBar.bg.width - 2) * per, overwrite: true})


	}

	public function get vo() : TaskVo {
		return _vo;
	}

	public function setCtrlBtnSelect(selected : Boolean) : void {
		_selected = selected;
	}

	private function __showChildHandler(e : MouseEvent) : void {
		_selected = !_selected;
		dispatchEvent(new STaskCardEvent(STaskCardEvent.SHOW_DETAIL, _vo, _selected));
	}

	private function __downHandler(e : MouseEvent) : void {
		Mouse.cursor = MouseCursor.HAND;
		_lastLocation.x = EnterFrameCall.getStage().mouseX;
		_lastLocation.y = EnterFrameCall.getStage().mouseY;
		EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_MOVE, __moveHandler);
	}

	private function __upHandler(e : MouseEvent) : void {
		Mouse.cursor = MouseCursor.AUTO;
		EnterFrameCall.getStage().removeEventListener(MouseEvent.MOUSE_MOVE, __moveHandler);
	}

	private function __moveHandler(e : MouseEvent) : void {
		var offsetX : Number = EnterFrameCall.getStage().mouseX - _lastLocation.x;
		var offsetY : Number = EnterFrameCall.getStage().mouseY - _lastLocation.y;
		dispatchEvent(new TreeContainerEvent(TreeContainerEvent.LOCATION_MOVE, offsetX, offsetY));

		_lastLocation.x = EnterFrameCall.getStage().mouseX;
		_lastLocation.y = EnterFrameCall.getStage().mouseY;
	}


	public function showTo(parent : Sprite) : void {
		super.x = _vo.cardStatus.locationX;
		super.y = _vo.cardStatus.locationY;

		parent.addChild(this);
		_vo.cardStatus.setVisible(true);
	}

	public function hide(hideById : String) : void {
		STool.remove(this);
		_vo.cardStatus.setVisible(false, hideById);
	}

	override public function set x(value : Number) : void {
		super.x = value;
		_vo.cardStatus.locationX = value;
		_rect.x = value;
	}

	override public function set y(value : Number) : void {
		super.y = value;
		_vo.cardStatus.locationY = value;
		_rect.y = value;
	}

	/**
	 * 底部中点的坐标
	 * @return
	 */
	public function get rightCenterLoaction() : Point {
		return new Point(this.x + this.width + 3, this.y + bg.height / 2);
	}

	public function get rect() : Rectangle {
		return _rect;
	}

	public function get selected() : Boolean {
		return _selected;
	}
}
}
