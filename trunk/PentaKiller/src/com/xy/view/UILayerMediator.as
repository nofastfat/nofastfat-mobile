package com.xy.view {
import com.greensock.TweenMax;
import com.xy.interfaces.AbsMediator;
import com.xy.model.enum.DataConfig;
import com.xy.model.vo.ResultVo;
import com.xy.util.Map;
import com.xy.view.event.CtrlBarEvent;
import com.xy.view.event.GamingMenuEvent;
import com.xy.view.event.HeroInfoBarEvent;
import com.xy.view.roles.Hero;
import com.xy.view.sprite.CtrlBar;
import com.xy.view.sprite.GamingMenu;
import com.xy.view.sprite.HeroInfoBar;
import com.xy.view.sprite.UILayer;

import starling.core.Starling;
import starling.display.Image;
import starling.events.Event;

/**
 * 主UI
 * @author xy
 */
public class UILayerMediator extends AbsMediator {
	public static const NAME : String = "UILayerMediator";

	/**
	 * 显示用户血量板
	 */
	public static const SHOW_HERO_INFO_BAR : String = NAME + "SHOW_HERO_INFO_BAR";


	/**
	 * 隐藏用户血量板
	 */
	public static const HIDE_HERO_INFO_BAR : String = NAME + "HIDE_HERO_INFO_BAR";

	/**
	 * 显示控制板
	 */
	public static const SHOW_CTRL_BAR : String = NAME + "SHOW_CTRL_BAR";

	/**
	 * 隐藏控制板
	 */
	public static const HIDE_CTRL_BAR : String = NAME + "HIDE_CTRL_BAR";

	/**
	 * 玩家信息更新
	 */
	public static const HERO_INFO_UPDATE : String = NAME + "HERO_INFO_UPDATE";

	/**
	 * 任务完成
	 * [isWin:boolean,rewards:Array]
	 *
	 */
	public static const SHOW_TASK_RESULT : String = NAME + "SHOW_TASK_RESULT";

	/**
	 * 升级文字动画
	 */
	public static const SHOW_LEVEL_TEXT : String = NAME + "SHOW_LEVEL_TEXT";

	private var _heroInfoBar : HeroInfoBar;
	private var _ctrlBar : CtrlBar;
	private var _gamingMenu : GamingMenu;

	private var _winImage : Image;
	private var _loseImage : Image;
	private var _levelUpImage : Image;

	private var _taskResultIsPlaying : Boolean = false;

	private var _movieList : Array = [];
	private var _movieIsPlaying : Boolean;

	public function UILayerMediator(viewComponent : Object = null) {
		super(NAME, viewComponent);
	}

	override public function makeNoticeMap() : Map {
		var map : Map = new Map();

		map.put(SHOW_HERO_INFO_BAR, showHeroInfoBar);
		map.put(HIDE_HERO_INFO_BAR, hideHeroInfoBar);
		map.put(SHOW_CTRL_BAR, showCtrlBar);
		map.put(HIDE_CTRL_BAR, hideCtrlBar);
		map.put(HERO_INFO_UPDATE, updateHeroInfoBar);
		map.put(SHOW_TASK_RESULT, showTaskResult);
		map.put(SHOW_LEVEL_TEXT, showLevelTxt);

		return map;
	}

	private function showHeroInfoBar() : void {
		if (_heroInfoBar == null) {
			_heroInfoBar = new HeroInfoBar();
			_heroInfoBar.addEventListener(HeroInfoBarEvent.BE_SUPER_HERO, __beSuperHandler);
		}

		ui.addChild(_heroInfoBar);
		_heroInfoBar.x = _heroInfoBar.y = 5;
		updateHeroInfoBar();
	}

	private function hideHeroInfoBar() : void {
		if (_heroInfoBar != null) {
			_heroInfoBar.removeFromParent();
		}
	}

	private function updateHeroInfoBar() : void {
		var hero : Hero = dataProxy.hero;
		if (_heroInfoBar != null) {
			_heroInfoBar.setHp(hero.currentHp / hero.VO.maxHp);
			_heroInfoBar.setLvl(hero.vo.level);
			_heroInfoBar.setSp(hero.currentSp / hero.VO.maxSp);
			_heroInfoBar.setName(hero.VO.userName);
		}
	}

	private function showCtrlBar() : void {
		if (_ctrlBar == null) {
			_ctrlBar = new CtrlBar();
			_ctrlBar.addEventListener(CtrlBarEvent.SHOW_GAMING_MENU, __showGamingMenuHandler);
		}
		ui.addChild(_ctrlBar);
		_ctrlBar.x = DataConfig.WIDTH - _ctrlBar.width - 20;
		_ctrlBar.y = 20;
	}

	private function __beSuperHandler(e : Event) : void {
		_heroInfoBar.setSp(0);
		sendNotification(HeroMediator.BE_SUPER_HERO);
	}

	private function hideCtrlBar() : void {
		if (_ctrlBar != null) {
			_ctrlBar.removeFromParent();
		}
	}

	private function __showGamingMenuHandler(e : Event) : void {
		if (_gamingMenu == null) {
			_gamingMenu = new GamingMenu();
			_gamingMenu.addEventListener(GamingMenuEvent.SAVE_EXIT, __saveExitHandler);
		}

		_gamingMenu.showTo(ui);

	}

	private function __saveExitHandler(e : Event) : void {
		sendNotification(JudgeMediator.USER_WANT_BACK);
	}

	/**
	 * 显示任务结果
	 * @param isWin
	 */
	private function showTaskResult(isWin : Boolean, rsVo : ResultVo = null) : void {
		if (_taskResultIsPlaying) {
			return;
		}
		
		var img : Image;
		if (isWin) {
			SoundManager.play("taskComplete");
			if (_winImage == null) {
				_winImage = Assets.makeUI("win", 1.5, true);
			}
			img = _winImage;
		} else {
			SoundManager.play("taskFaild");
			if (_loseImage == null) {
				_loseImage = Assets.makeUI("lose", 1.5, true);
			}
			img = _loseImage;
		}
		_taskResultIsPlaying = true;

		addMovie(img, true, function() : void {
			sendNotification(ResultPanelMediator.SHOW_RESULT_PANEL, rsVo);
			_taskResultIsPlaying = false;
		});
	}

	private function showLevelTxt() : void {
		if (_levelUpImage == null) {
			_levelUpImage = Assets.makeUI("levelUp", 2, true);
		}

		addMovie(_levelUpImage, false);
	}

	private function addMovie(img : Image, lockScreen : Boolean = true, call : Function = null) : void {
		_movieList.push({img: img, call: call, lockScreen: lockScreen});

		if (!_movieIsPlaying && _movieList.length > 0) {
			playNextMovie();
		}
	}

	/**
	 * 同一时刻只能放一个动画
	 * @param img
	 * @param call
	 */
	private function playNextMovie() : void {
		if (_movieList.length == 0) {
			_movieIsPlaying = false;
			return;
		}
		_movieIsPlaying = true;

		var obj : * = _movieList.shift();
		var img : Image = obj.img;
		var call : Function = obj.call;
		var lockScreen : Boolean = obj.lockScreen;

		if (lockScreen) {
			ui.addChild(Assets.mask);
		} else {
			img.touchable = false;
		}
		ui.addChild(img);
		img.x = (DataConfig.WIDTH - img.width) >> 1;
		img.y = 150;
		img.alpha = 1;
		TweenMax.from(img, 0.2, {alpha: .1, x: img.x * 3, onCompleteParams: [img], onComplete: function(img1 : Image) : void {
			TweenMax.to(img1, 0.3, {delay: 1.5, x: -img1.x, alpha: .1, onCompleteParams: [img1], onComplete: function(img2 : Image) : void {
				img2.removeFromParent();
				Assets.mask.removeFromParent();

				Starling.juggler.delayCall(function() : void {
					playNextMovie();

					if (call != null) {
						call();
					}
				}, 0.5);
			}});
		}});
	}

	public function get ui() : UILayer {
		return viewComponent as UILayer;
	}
}
}
