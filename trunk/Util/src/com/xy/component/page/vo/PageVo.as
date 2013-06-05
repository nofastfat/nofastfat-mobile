package com.xy.component.page.vo {

/**
 * 分页信息
 * @author xy
 */
public class PageVo {
	/**
	 * 总页数 从0开始
	 */
	private var _pageCount : int;

	/**
	 * 当前页数 从0开始
	 */
	private var _pageIndex : int;

	/**
	 * 一页显示多少个
	 */
	private var _pageSize : int;

	/**
	 * 总数量
	 */
	private var _numCount : int;

	public function PageVo(pageSize : int) {
		_pageSize = pageSize;
	}

	/**
	 * 当前是否是第一页
	 * @return
	 */
	public function isFirstPage() : Boolean {
		return pageIndex == 0;
	}

	/**
	 * 当前是否是最后一页
	 * @return
	 */
	public function isLastPage() : Boolean {
		return pageCount == (pageIndex + 1);
	}

	/**
	 * 获取开始的index
	 * @return
	 */
	public function getStartIndex() : int {
		return _pageIndex * pageSize;
	}

	/**
	 * 页数显示
	 * @return
	 */
	public function toString() : String {
		var rs : int = pageCount;
		if (rs == 0) {
			rs = 1;
		}
		return (pageIndex + 1) + "/" + rs;
	}

	public function set pageIndex(value : int) : void {
		if (value >= pageCount) {
			value = pageCount - 1;
		}

		if (value < 0) {
			value = 0;
		}

		_pageIndex = value;
	}

	/**
	 * 当前是第几页
	 * @return
	 */
	public function get pageIndex() : int {
		return _pageIndex;
	}

	/**
	 * 总页数 从0开始
	 */
	public function get pageCount() : int {
		return _pageCount;
	}

	/**
	 * 总数量
	 */
	public function get numCount() : int {
		return _numCount;
	}

	/**
	 * @private
	 */
	public function set numCount(value : int) : void {
		_numCount = value;

		_pageCount = int(_numCount / pageSize);

		if (_numCount % pageSize != 0) {
			_pageCount++;
		}

		if (_pageIndex + 1 >= _pageCount) {
			pageIndex = _pageCount - 1;
		}
	}

	/**
	 * 每页数量
	 * @return
	 */
	public function get pageSize() : int {
		return _pageSize;
	}

}
}
