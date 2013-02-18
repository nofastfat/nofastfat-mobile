package starling.extensions {
import flash.utils.getTimer;

import starling.display.Image;
import starling.extensions.flumpVos.FMovieVo;
import starling.textures.TextureSmoothing;

public class FMovie {
	private var _vo : FMovieVo;
	private var _currentFrame : int = 1;
	public var loop : Boolean = false;
	public var x : Number = 0;
	public var y : Number = 0;

	public function FMovie(vo : FMovieVo) {
		_vo = vo;
	}


	public function nextFrame() : void {
		_currentFrame++;
		if (_currentFrame > _vo.totalFrames) {
			if (loop) {
				_currentFrame = 1;
			} else {
				_currentFrame = _vo.totalFrames;
			}
		}
	}

	public function play() : void {
		if (_currentFrame >= _vo.totalFrames && !loop) {
			_currentFrame = 1;
		}
	}

	/**
	 * 获取当前帧上的image
	 * @return
	 */
	public function getCurretnFrameImages() : Array {
		var arr : Array = FlumpResource.getInstance().getMovieImages(_vo.name, _currentFrame);
		var len : int = arr.length;
		for (var i : int = 0; i < len; i++) {
			var img : Image = arr[i];
			img.x += x;
			img.y += y;
		}
		return arr;
	}

	public function get totalFrames() : int {
		return _vo.totalFrames;
	}
}
}
