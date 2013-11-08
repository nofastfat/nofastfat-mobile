package com.xy.ui {
import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.MovieClip;


/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-9-24 下午12:01:44
 **/
public class SUpdateUI extends MovieClip {
	private var _call : Function;
	
	public function SUpdateUI() {
		super();
		alert.okBtn.addEventListener(MouseEvent.CLICK, __clickHandler);
	}

	/**
	 * 显示注释
	 * @param xx xxxx
	 */
	public function showAlert(txt : String, call : Function) : void {
		alert.visible = true;
		progress.visible = false;
		alert.infoTf.text = txt;
		_call = call;
	}

	public function showProgress() : void {
		alert.visible = false;
		progress.visible = true;
		setProgressText(0);
	}
	
	public function setProgressText(per :Number):void{
		if(per > 1){
			per = 1;
		}
		if(per < 0){
			per = 0;
		}
		progress.lodNum.text = int(per*100) + "%";
		progress.lod.scaleX = per;
	}
	
	private function __clickHandler(e : Event):void{
		_call();
	}
}
}
