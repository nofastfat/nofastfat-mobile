package com.xy.cmd {
import com.xy.interfaces.AbsCommand;
import com.xy.model.PKDataProxy;
import com.xy.view.BatterMediator;
import com.xy.view.GameMediator;
import com.xy.view.HeroMediator;
import com.xy.view.HurtShowMediator;
import com.xy.view.JudgeMediator;
import com.xy.view.MapLayerMediator;
import com.xy.view.MenuMediator;
import com.xy.view.MonsterMediator;
import com.xy.view.NewUserPanelMediaor;
import com.xy.view.NpcMediator;
import com.xy.view.PortalMediator;
import com.xy.view.ResultPanelMediator;
import com.xy.view.RoleLayerMediator;
import com.xy.view.TalkMediator;
import com.xy.view.UILayerMediator;
import com.xy.view.sprite.NewUserPanel;

import org.puremvc.as3.interfaces.INotification;

/**
 * MVC注册
 * @author xy
 */
public class RegisteCmd extends AbsCommand {
	/**
	 * 注册MVC<br>
	 * 参数: game:Game
	 */
	public static const NAME : String = "RegisteCmd";

	public function RegisteCmd() {
		super();
	}

	override public function execute(notification : INotification) : void {
		var game : Game = notification.getBody() as Game;
		//models
		facade.registerProxy(new PKDataProxy());

		//views
		facade.registerMediator(new JudgeMediator());
		facade.registerMediator(new GameMediator(game));
		facade.registerMediator(new MonsterMediator(game.roleLayer));
		facade.registerMediator(new RoleLayerMediator(game.roleLayer));
		facade.registerMediator(new HeroMediator(game.roleLayer));
		facade.registerMediator(new NpcMediator(game.roleLayer));
		facade.registerMediator(new MapLayerMediator(game.mapLayer));
		facade.registerMediator(new BatterMediator(game.uiLayer));
		facade.registerMediator(new HurtShowMediator(game.uiLayer));
		facade.registerMediator(new MenuMediator(game.uiLayer));
		facade.registerMediator(new TalkMediator(game.uiLayer));
		facade.registerMediator(new PortalMediator(game.uiLayer));
		facade.registerMediator(new UILayerMediator(game.uiLayer));
		facade.registerMediator(new ResultPanelMediator(game.uiLayer));
		facade.registerMediator(new NewUserPanelMediaor(game.uiLayer));


		//commands
		facade.registerCommand(GameStartCmd.NAME, GameStartCmd);
		facade.registerCommand(SwitchMapCmd.NAME, SwitchMapCmd);
		facade.registerCommand(GameOverCmd.NAME, GameOverCmd);
	}
}
}
