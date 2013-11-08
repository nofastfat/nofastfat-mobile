﻿package com.xy.ui {
import com.greensock.TweenLite;
import flash.display.MovieClip;

import flash.events.Event;
import flash.events.MouseEvent;


/**
 * 提示框
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-9-9 上午11:54:23
 **/
public class SAlertUI extends MovieClip {
	private static var _instance : SAlertUI;
	private static var _call : Function;

	public static function getInstance() : SAlertUI {
		if (_instance == null) {
			_instance = new SAlertUI();
		}

		return _instance;
	}

	public function SAlertUI() {
		super();

		width = SUIRoot.stageWidth;
		height = SUIRoot.stageHeight;
		this.x = width/2;
		this.y = height/2;
		okBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
	}

	private function __clickHandler(source : * = null):void{
		hide();
		if(_call != null){
			_call();
		}
	}
	
	/**
	 * 显示提示 
	 * @param content
	 * @param title
	 */	
	public function show(content : String, title : String = "提示", call : Function = null) : void {
		infoTf.text = content;
		titleTf.text = title;
		if(this.stage != null){
			return;
		}
		
		SUIRoot.stage.addChild(this);
		TweenLite.from(this, 0.4, {scaleX:0.1, scaleY:0.1});
		_call = call;
	}

	/**
	 * 隐藏 
	 */	
	public function hide() : void {
		remove();
	}
	
	private function remove():void{
		if(SUIRoot.stage.contains(this)){
			SUIRoot.stage.removeChild(this);
		}
	}
}
}
