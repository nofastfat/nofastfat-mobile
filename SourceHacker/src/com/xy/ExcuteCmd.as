package com.xy {
import com.xy.util.Http;
import com.xy.view.ViewProgress;

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.net.URLLoaderDataFormat;
import flash.utils.ByteArray;
import flash.utils.setTimeout;

/**
 * @author nofastfat
 * @E-mail: xiey147@163.com
 * @version 1.0.0
 * 创建时间：2013-11-19 上午9:46:44
 **/
public class ExcuteCmd {

	private var _needStop : Boolean = false;
	private var _len : int;
	private var _index : int;
	private var _filterUrls : Array = [];
	private var _preUri : String;
	private var _savePath : String;
	private var _skip : Boolean;
	private var _saveAsWebPath : Boolean;
	private var _notFound : int = 0;
	
	public function excute(urls : Array, startIndex : int, savePath : String, preUrl : String, skip : Boolean, saveAsWebPath : Boolean) : void {
		_needStop = false;
		_filterUrls = urls;
		_len = _filterUrls.length;
		_preUri = preUrl;
		_index = startIndex;
		_savePath = savePath;
		_skip = skip;
		_saveAsWebPath = saveAsWebPath;
		_notFound = 0;
		
		ViewProgress.getInstance().show(null, stop);

		tjNext();
	}

	private function stop() : void {
		_needStop = true;
	}

	private function tjNext() : void {
		_index++;
		if (_index >= _len) {
			ViewProgress.getInstance().addLog("Complete len: " + (_len - _notFound) + ", not found len: " + _notFound + ", total:" + _len);
			return;
		}

		if (_needStop) {
			ViewProgress.getInstance().addLog("Stoped by user!");
			return;
		}

		var url : String = _filterUrls[_index];

		ViewProgress.getInstance().setProgress(_index + 1, _len);

		if (_skip) {
			var path : String = url.substr(_preUri.length);
			path = _savePath + path;
			path = path.replace(new RegExp("/", "g"), File.separator);
			var f : File = new File(path);
			if (f.exists) {
				skiped();

				ViewProgress.getInstance().addLog("skiped " + _index);
				return;
			}
		}

		ViewProgress.getInstance().addLog("start:" + _index + "/" + _len);
		new Http(url, tjOk, URLLoaderDataFormat.BINARY);
	}

	private function skiped() : void {
		setTimeout(tjNext, 30);
	}

	private function tjOk(data : ByteArray) : void {
		var url : String = _filterUrls[_index];
		if (data == null) {
			ViewProgress.getInstance().addLog("not found resource:" + url);
			_notFound++;
			tjNext();
			return;
		}
		var path : String = url.substr(_preUri.length);
		path = _savePath + path;
		path = path.replace(new RegExp("/", "g"), File.separator);
		var f : File = new File(path);
		var fr : FileStream = new FileStream();
		fr.open(f, FileMode.WRITE);
		fr.writeBytes(data);
		fr.close();
		tjNext();
	}

}
}
