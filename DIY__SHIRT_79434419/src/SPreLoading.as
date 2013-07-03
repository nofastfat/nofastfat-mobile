package {
import com.xy.ui.PreLoading;
import com.xy.util.STool;

import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.utils.getDefinitionByName;
import flash.utils.getTimer;
import flash.utils.setTimeout;

public class SPreLoading extends Sprite {
    private var _loader : Loader;

    private var _time : Number;

    private var _loadingMc : PreLoading;

    public function SPreLoading() {
        super();
        addEventListener(Event.ADDED_TO_STAGE, __addedHandler);
    }

    private function __addedHandler(e : Event) : void {
        removeEventListener(Event.ADDED_TO_STAGE, __addedHandler);
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        _loadingMc = new PreLoading();
        addChild(_loadingMc);

        if (stage.stageWidth != 0) {
			_loadingMc.x = stage.stageWidth/2;
			_loadingMc.y = stage.stageHeight/2;
        } else {
            _loadingMc.x = 400;
            _loadingMc.y = 300;
        }
        _loader = new Loader();
        _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, __loadOkHandler);
        _loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, __progressHandler);
        _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, __errorHandler);
        _loader.load(new URLRequest("DIY__SHIRT_79434419.swf?version=" + loaderInfo.parameters["version"]));

        _loadingMc.progressTf.text = "0%";
        _loadingMc.gotoAndStop(1);
        _time = getTimer();
    }

    private function __errorHandler(e : Event) : void {
        _loadingMc.progressTf.htmlText = "<font color='#FF0000'>加载失败</font>";
    }

    private function __progressHandler(e : ProgressEvent) : void {
        var per : int = int(e.bytesLoaded / e.bytesTotal * 100);
        _loadingMc.progressTf.text = per + "%";
        _loadingMc.gotoAndStop(per);
    }

    private function __loadOkHandler(e : Event) : void {
        _loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, __loadOkHandler);
        _loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, __progressHandler);
        _loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, __errorHandler);

        if (getTimer() - _time < 2000) {
            setTimeout(startUp, 2000 - (getTimer() - _time));
        } else {
            startUp();
        }
    }

    private function startUp() : void {
        var mainClass : Class = STool.getClazzFromLoader("DIY__SHIRT_79434419", _loader);
        var sp : Sprite = new mainClass() as Sprite;
        stage.addChild(sp);
        _loader.unloadAndStop();
        _loader = null;
        STool.remove(this);
    }
}
}
