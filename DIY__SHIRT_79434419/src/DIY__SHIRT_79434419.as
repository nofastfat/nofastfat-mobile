package {
import com.xy.DiyFacade;
import com.xy.component.alert.Alert;
import com.xy.component.menu.Menu;
import com.xy.component.toolTip.ToolTip;
import com.xy.ui.AlertBg;
import com.xy.util.EnterFrameCall;
import com.xy.util.Http;
import com.xy.view.layer.LeftContainer;
import com.xy.view.layer.RightContainer;
import com.xy.view.ui.componet.SAlertTextUI;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

public class DIY__SHIRT_79434419 extends Sprite {
    private var _facade : DiyFacade;

    private var _left : LeftContainer;
    private var _right : RightContainer;

    public function DIY__SHIRT_79434419() {
        addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
    }

    private function __addToStageHandler(e : Event) : void {
        ToolTip.initStage(stage);
        removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
        stage.addEventListener(Event.RESIZE, __resizeHandler);
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

		Menu.initParent(stage, new Sprite());
        EnterFrameCall.initState(stage);
		Alert.initParent(stage, new AlertBg(), true);

        _left = new LeftContainer();
        _right = new RightContainer();
        _right.x = 200;
        addChild(_left);
        addChild(_right);

        _facade = new DiyFacade();
		
		SLoading.getInstance().show();
		
		new Http("config/config.xml?r" + Math.random(), loadOk);
		
		//TODO 增加权限控制
		//TODO 增加URL参数定位模板
		//TODO 保存，填写帐号，密码，导出多张图片
		//TODO 保存作品的http接口，base64+压缩
		//TODO 配置文件编辑说明文档
		//TODO 接入说明，crossdomain.xml
    }
	
	private function loadOk(data:*):void{
		SLoading.getInstance().hide();
		if(data != null){
			_facade.startUp(this, new XML(data));
			__resizeHandler();
		}else{
			Alert.show(new SAlertTextUI("配置文件加载失败，请联系管理员"));
		}
	}

    private function __resizeHandler(e : Event = null) : void {
        if (left != null) {
            left.resize();
        }
        if (_right != null) {
            _right.resize();
        }

        if (_facade != null) {
            _facade.sendNotification(Event.RESIZE);
        }
    }


    public function get right() : RightContainer {
        return _right;
    }

    public function get left() : LeftContainer {
        return _left;
    }
}
}
