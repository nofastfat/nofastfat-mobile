package {
import com.adobe.serialization.json.JSON;
import com.xy.HelperFacade;
import com.xy.model.Config;
import com.xy.model.vo.OrganizedStructVo;
import com.xy.ui.Loading;
import com.xy.util.EnterFrameCall;
import com.xy.view.layer.DetailContainer;
import com.xy.view.layer.TreeContainer;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.external.ExternalInterface;

[SWF(witdh = "1024", height = "768", backgroundColor = "#666666")]
public class Helper extends Sprite {
    private var _facade : HelperFacade;

    private var _treeContainer : TreeContainer;
    private var _detailContainer : DetailContainer;

    private var _loading : Loading;

    private var _initData : String;

    public function Helper() {

        ExternalInterface.addCallback("resizeHandler", __resizeHandler);
        addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);

        /* 请求的配置文件地址 */
        Config.ACTION0_URL = decodeURIComponent(this.loaderInfo.parameters["action0"]);
        Config.ACTION1_URL = decodeURIComponent(this.loaderInfo.parameters["action1"]);
        Config.ACTION2_URL = decodeURIComponent(this.loaderInfo.parameters["action2"]);

        /* 初始数据 */
        _initData = decodeURIComponent(this.loaderInfo.parameters["initData"]);

//		var vo : OrganizedStructVo = new OrganizedStructVo();
//		vo.company = "诺克萨斯公司";
//		vo.imgUrl = "http://192.168.1.175/heads/per_01.png";
//		vo.jobScore = 500;
//		vo.jobType = "营销类";
//		vo.joinTime = "2001-03-10";
//		vo.levelUpLastScore = 100;
//		vo.name = "刀妹";
//		vo.powerMatrix = 8;
//		vo.sex = 1;
//		vo.simpleSubordinateList = [];
//		vo.status = 0;
//		
//		trace(JSON.encode(vo));
    }

    private function __addToStageHandler(e : Event) : void {
        removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        EnterFrameCall.initState(stage);

        _treeContainer = new TreeContainer();
        _detailContainer = new DetailContainer();
        _loading = new Loading();

        addChild(_treeContainer);
        addChild(_detailContainer);
        addChild(_loading);

        LoadingController.initLoading(_loading);

        LoadingController.showLoading();
		
		__resizeHandler(ExternalInterface.call("getWebWidth"), ExternalInterface.call("getWebHeight"));

        _facade = new HelperFacade();
        _facade.startUp(this, _initData);
    }

    private function __resizeHandler(w : int, h : int) : void {
        if (_loading != null) {
            _loading.x = (w - _loading.width) / 2;
            _loading.y = 0;
        }

        if (_treeContainer != null) {
            _treeContainer.x = _treeContainer.y = 0;
            _treeContainer.resize(w - 250, h);
        }

        if (_detailContainer != null) {
            _detailContainer.x = w - 350;
            _detailContainer.y = 0;
            _detailContainer.resize(350, h);
        }

        if (_facade != null) {
            _facade.sendNotification(Event.RESIZE, {w: w, h: h});
        }
    }


    public function get detailContainer() : DetailContainer {
        return _detailContainer;
    }

    public function get treeContainer() : TreeContainer {
        return _treeContainer;
    }
}
}
