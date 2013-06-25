package com.xy.component.page {
import com.xy.component.page.event.SPageEvent;
import com.xy.component.page.vo.PageVo;
import com.xy.util.STool;

import flash.display.SimpleButton;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;
import flash.sampler.stopSampling;
import flash.text.TextField;

/**
 * 翻页组件，只做控制，不做显示
 * @author xy
 */
[Event(name = "page_change", type = "SPageEvent")]
public class SPage extends EventDispatcher {
	private var _prevBtn : SimpleButton;
	private var _pageTf : TextField;
	private var _nextBtn : SimpleButton;
	private var _pageVo : PageVo;

	public function SPage(pageSize : int) {
		super();
		_pageVo = new PageVo(pageSize);
	}

	public function setDataCount(count : int, needDispatchEvent : Boolean = true) : void {
		_pageVo.numCount = count;

		if (_pageTf != null) {
			_pageTf.text = _pageVo.toString();
		}

		if (needDispatchEvent) {
			dispatchEvent(new SPageEvent(SPageEvent.PAGE_CHANGE, _pageVo.pageIndex, _pageVo.getStartIndex()));
		}
	}

	public function setPage(pageIndex : int, needDispatchEvent : Boolean = true) : void {
		_pageVo.pageIndex = pageIndex;
		
		if (_pageTf != null) {
			_pageTf.text = _pageVo.toString();
		}
		if (needDispatchEvent) {
			dispatchEvent(new SPageEvent(SPageEvent.PAGE_CHANGE, _pageVo.pageIndex, _pageVo.getStartIndex()));
		}
	}

	/**
	 * 设置控制UI
	 * @param prevBtn
	 * @param pageTf
	 * @param nextBtn
	 */
	public function setCtrlUI(prevBtn : SimpleButton, pageTf : TextField, nextBtn : SimpleButton) : void {
		_prevBtn = prevBtn;
		_pageTf = pageTf;
		_nextBtn = nextBtn;

		_prevBtn.addEventListener(MouseEvent.CLICK, __prevHandler);
		_nextBtn.addEventListener(MouseEvent.CLICK, __nextHandler);
	}

	private function __prevHandler(e : MouseEvent) : void {
		if (_pageVo.isFirstPage()) {
			return;
		}
		_pageVo.pageIndex--;
		dispatchEvent(new SPageEvent(SPageEvent.PAGE_CHANGE, _pageVo.pageIndex, _pageVo.getStartIndex()));
		if (_pageTf != null) {
			_pageTf.text = _pageVo.toString();
		}
	}

	private function __nextHandler(e : MouseEvent) : void {
		if (_pageVo.isLastPage()) {
			return;
		}
		_pageVo.pageIndex++;
		dispatchEvent(new SPageEvent(SPageEvent.PAGE_CHANGE, _pageVo.pageIndex, _pageVo.getStartIndex()));
		if (_pageTf != null) {
			_pageTf.text = _pageVo.toString();
		}
	}

	public function destroy() : void {
		_prevBtn.removeEventListener(MouseEvent.CLICK, __prevHandler);
		_nextBtn.removeEventListener(MouseEvent.CLICK, __nextHandler);
	}

	/**
	 * 页数信息
	 * @return
	 */
	public function get pageVo() : PageVo {
		return _pageVo;
	}

}
}
