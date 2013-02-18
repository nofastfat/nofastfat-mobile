package {
import com.greensock.TweenMax;
import com.xy.model.enum.DataConfig;

import flash.display.Bitmap;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;

public class Loading {
	private static var _parent : Sprite;
	private static var _instance : Loading = new Loading();

	private var _initlitingLoading : Sprite;
	private var _comLogo : Bitmap;
	private var _gameLogo : Bitmap;
	private var _superHeroMc : MovieClip;
	private var _superHeroCall : Function;

	public static function getInstance() : Loading {
		return _instance;
	}

	public static function initParent(sp : Sprite) : void {
		_parent = sp;
	}

	public function Loading() {
		_initlitingLoading = new AssetEmbeds_1x.Loading();
		_superHeroMc = new AssetEmbeds_1x.SuperHeroMc();
		_superHeroMc.stop();
		_initlitingLoading.width = DataConfig.WIDTH;
		_initlitingLoading.height = DataConfig.HEIGHT;
		_comLogo = new AssetEmbeds_1x.Default();
		_gameLogo = new AssetEmbeds_1x.doco();
	}

	/**
	 * 显示LOGO的动画
	 */
	public function showLogo(callback : Function) : void {
		_parent.addChild(_comLogo);
		_comLogo.width = DataConfig.HEIGHT;
		_comLogo.height = DataConfig.WIDTH;
		_comLogo.rotation = -90;
		_comLogo.y = _comLogo.height;
		TweenMax.to(_comLogo, 2, {alpha: 0, delay: 1, onComplete: function() : void {
			_parent.removeChild(_comLogo);
			_parent.addChild(_gameLogo);
			_gameLogo.width = DataConfig.HEIGHT;
			_gameLogo.height = DataConfig.WIDTH;
			_gameLogo.rotation = -90;
			_gameLogo.y = _gameLogo.height;

			TweenMax.from(_gameLogo, 2, {alpha: 0, onComplete: function() : void {
				TweenMax.to(_gameLogo, 2, {delay: 1, alpha: 0, onComplete: function() : void {
					_parent.removeChild(_gameLogo);
					_comLogo.bitmapData.dispose();
					_gameLogo.bitmapData.dispose();
					_comLogo = null;
					_gameLogo = null;
					callback();
				}});
			}});
		}});
	}

	public function showSuperHeroMc(callback : Function) : void {
		_superHeroCall = callback;
		_parent.addChild(_superHeroMc);
		_superHeroMc.x = DataConfig.WIDTH >> 1;
		_superHeroMc.y = (DataConfig.HEIGHT >> 1) + (_superHeroMc.height >> 1);
		_superHeroMc.gotoAndPlay(1);
		_superHeroMc.addEventListener(Event.ENTER_FRAME, __superHeroHandler);
	}

	private function __superHeroHandler(e : Event) : void {
		if (_superHeroMc.currentFrame == _superHeroMc.totalFrames) {
			_superHeroMc.removeEventListener(Event.ENTER_FRAME, __superHeroHandler);
			_superHeroMc.stop();
			if (_parent.contains(_superHeroMc)) {
				_parent.removeChild(_superHeroMc);
			}
			_superHeroCall();
		}
	}

	public function showLoading(index : int = 0, soundAble : Boolean = true) : void {
		_parent.addChild(_initlitingLoading);
		show(index);

		if (soundAble) {
			SoundManager.play("loading");
		}
	}

	private function show(index : int) : void {
		for (var i : int = 0; i < 3; i++) {
			var txt : MovieClip = _initlitingLoading["txt" + i];
			var mc : MovieClip = _initlitingLoading["mc" + i];
			txt.visible = mc.visible = false;
		}


		txt = _initlitingLoading["txt" + index];
		mc = _initlitingLoading["mc" + index];
		txt.visible = mc.visible = true;
	}

	public function hide() : void {
		SoundManager.stop("loading");
		while (_parent.numChildren > 0) {
			_parent.removeChildAt(0);
		}
	}
}
}
