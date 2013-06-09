package {
import com.xy.HelperFacade;
import com.xy.component.toolTip.ToolTip;
import com.xy.model.Config;
import com.xy.ui.Loading;
import com.xy.util.EnterFrameCall;
import com.xy.view.layer.DetailContainer;
import com.xy.view.layer.SUIPanel;
import com.xy.view.layer.TreeContainer;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;

import net.hires.debug.Stats;

[SWF(witdh = "100", height = "100", backgroundColor = "#666666")]
public class Helper extends Sprite {
    private var _facade : HelperFacade;

    private var _treeContainer : TreeContainer;
    private var _detailContainer : DetailContainer;
    private var _ctrlUI : SUIPanel;

    private var _loading : Loading;

    private var _initData : String;

    public function Helper() {
        addEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);

        /* 请求的配置文件地址 */
        Config.ACTION0_URL = decodeURIComponent(this.loaderInfo.parameters["action0"]);
        Config.ACTION1_URL = decodeURIComponent(this.loaderInfo.parameters["action1"]);
        Config.ACTION2_URL = decodeURIComponent(this.loaderInfo.parameters["action2"]);
        Config.ACTION3_URL = decodeURIComponent(this.loaderInfo.parameters["action3"]);
        Config.DEBUG_MODE = decodeURIComponent(this.loaderInfo.parameters["debug"]).toLocaleLowerCase() == "true";

        /* 初始数据 */
        _initData = decodeURIComponent(this.loaderInfo.parameters["initData"]);

//        var vo : OrganizedStructVo = new OrganizedStructVo();
//        vo.company = "诺克萨斯公司";
//        vo.imgUrl = "http://192.168.1.175/heads/per_01.png";
//        vo.jobScore = 500;
//        vo.jobType = "营销类";
//        vo.joinTime = "2001-03-10";
//        vo.levelUpLastScore = 100;
//        vo.name = "刀妹";
//        vo.powerMatrix = 8;
//        vo.sex = 1;
//        vo.id = 2;
//
//        vo.simpleSubordinateList = [];
//        var ids : Array = STool.makeUnionRandomArray(1, 99, 12);
//        var departs : Array = ["销售部", "生产部", "公关部"];
//        for (var i : int = 0; i < 12; i++) {
//            var svo : SimpleSubordinateVo = new SimpleSubordinateVo();
//            svo.department = STool.randomFromArray(departs);
//            svo.id = vo.id * 100 + ids[i];
//            svo.name = RandomName.makeName();
//            svo.status = STool.random(0, 2);
//            ;
//            vo.simpleSubordinateList.push(svo);
//        }
//        vo.status = 0;
//
//        trace(JSON.encode(vo));
    }

    private function __addToStageHandler(e : Event) : void {
        ToolTip.initStage(stage);
        removeEventListener(Event.ADDED_TO_STAGE, __addToStageHandler);
        stage.addEventListener(Event.RESIZE, __resizeHandler);
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        EnterFrameCall.initState(stage);

        _treeContainer = new TreeContainer();
        _detailContainer = new DetailContainer();
        _loading = new Loading();

        _ctrlUI = new SUIPanel();

        addChild(_treeContainer);
        addChild(_detailContainer);
        addChild(_ctrlUI);
        addChild(_loading);


        LoadingController.initLoading(_loading);

        LoadingController.showLoading();

        __resizeHandler();
        
        _facade = new HelperFacade();
        _facade.startUp(this, _initData);

        if (Config.DEBUG_MODE) {
            addChild(new Stats());
        }
    }

    private function __resizeHandler(e : Event = null) : void {
        if (_loading != null) {
            _loading.x = (EnterFrameCall.getStage().stageWidth - _loading.width) / 2;
            _loading.y = 0;
        }

        if (_treeContainer != null) {
            _treeContainer.x = _treeContainer.y = 0;
            var offsetWidth : int = 350;
            if (_detailContainer == null || !_detailContainer.visible) {
                offsetWidth = 0;
            }
            _treeContainer.resize(EnterFrameCall.getStage().stageWidth - offsetWidth, EnterFrameCall.getStage().stageHeight);
        }

        if (_detailContainer != null) {
            _detailContainer.x = EnterFrameCall.getStage().stageWidth - 350;
            _detailContainer.y = 0;
            _detailContainer.resize(350, EnterFrameCall.getStage().stageHeight);
        }

        if (_ctrlUI != null) {
            if (Config.DEBUG_MODE) {
                _ctrlUI.x = Stats.WIDTH;
                _ctrlUI.y = 0;
            } else {
                _ctrlUI.x = 0;
                _ctrlUI.y = 0;
            }
        }

        if (_facade != null) {
            _facade.sendNotification(Event.RESIZE);
        }
    }


    public function get detailContainer() : DetailContainer {
        return _detailContainer;
    }

    public function get treeContainer() : TreeContainer {
        return _treeContainer;
    }

    public function get ctrlUI() : SUIPanel {
        return _ctrlUI;
    }
}
}
