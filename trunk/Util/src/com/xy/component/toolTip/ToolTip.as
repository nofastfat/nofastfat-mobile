package com.xy.component.toolTip {

import com.xy.component.toolTip.enum.ToolTipMode;
import com.xy.component.toolTip.interfaces.ITipViewContent;
import com.xy.util.STool;

import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.geom.Point;

/**
 * Tip
 * @author xy
 */
public class ToolTip {
    private static var _stage : Stage;
    private static var _tipMaps : Array = [];
    private static var _simpleTip : SimpleTipContent = new SimpleTipContent();
    private static var _simpleTipYellow : SimpleTipContentYellow = new SimpleTipContentYellow();
    private static var _lastShowSource : InteractiveObject;

    /**
     * 当前显示的souce与TIP
     * [[source,tip], [source,tip], ...]
     */
    private static var _souce_tipView_map : Array = [];

    /**
     * 初始化stage
     * @param stage
     */
    public static function initStage(stage : Stage) : void {
        _stage = stage;
    }

    /**
     * 设置简单的文字TIP
     * @param source 事件源
     * @param htmlText 用于显示的htmlText
     * @param toolTipMode TIP显示的方式
     * @see ToolTipMode
     *
     */
    public static function setSimpleTip(source : InteractiveObject, htmlText : String, toolTipMode : int = 0) : void {
        setTip(source, _simpleTip, htmlText, toolTipMode);
    }

    /**
     * 设置简单的文字TIP
     * @param source 事件源
     * @param htmlText 用于显示的htmlText
     * @param toolTipMode TIP显示的方式
     * @see ToolTipMode
     *
     */
    public static function setSimpleYellowTip(source : InteractiveObject, htmlText : String, toolTipMode : int = 0) : void {
        setTip(source, _simpleTipYellow, htmlText, toolTipMode);
    }

    /**
     * 设置复杂的TIP显示
     * @param source 事件源
     * @param tipViewContent 用于显示的TIP-UI，需要实现ITipViewContent接口
     * @param tipValue 传递给ITipViewContent.setData的数据
     * @param toolTipMode TIP显示的方式
     * @see ITipViewContent
     * @see ToolTipMode
     */
    public static function setTip(source : InteractiveObject, tipViewContent : ITipViewContent, tipValue : * = null, toolTipMode : int = 0) : void {
        if (_stage == null) {
            throw new Error("必须先调用initStage设置Stage");
        }

        var oldData : TipData = fetch(source);
        if (oldData == null) {
            _tipMaps.push(new TipData(source, tipViewContent, tipValue, toolTipMode));
            source.addEventListener(MouseEvent.ROLL_OVER, __overHandler);
            source.addEventListener(MouseEvent.ROLL_OUT, __outHandler);
        } else {
            oldData.tipViewContent = tipViewContent;
            oldData.tipValue = tipValue;
            oldData.toolTipMode = toolTipMode;

            /* 可能实时更新数据 */
            if (source == _lastShowSource) {
                oldData.tipViewContent.setData(oldData.tipValue);
            }
        }
    }

    public static function hideTip() : void {
        if (_lastShowSource != null) {
            _lastShowSource.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
        }
    }

    /**
     * 清除tip
     * @param listenedTarget
     */
    public static function removeTip(source : InteractiveObject) : void {
        if (source == _lastShowSource) {
            _lastShowSource = null;
        }

        source.removeEventListener(MouseEvent.ROLL_OVER, __overHandler);
        source.removeEventListener(MouseEvent.ROLL_OUT, __outHandler);
        for (var i : int = 0; i < _tipMaps.length; i++) {
            var obj : TipData = _tipMaps[i];
            if (obj.source == source) {
                for (var j : int = 0; j < _souce_tipView_map.length; j++) {
                    if (_souce_tipView_map[j][0] == source) {
                        _souce_tipView_map.splice(j, 1);
                        STool.remove(obj.tipViewContent as DisplayObject);
                        break;
                    }
                }

                obj.destroy(__overHandler, __outHandler);
                _tipMaps.splice(i, 1);
                return;
            }
        }
    }

    /**
     * 全部销毁
     */
    public static function destroy() : void {
        for (var i : int = 0; i < _tipMaps.length; i++) {
            var obj : TipData = _tipMaps[i];
            obj.destroy(__overHandler, __outHandler);
        }
        _tipMaps = null;
        _lastShowSource = null;
        _souce_tipView_map = null;
    }

    private static function __overHandler(e : MouseEvent) : void {
        var source : InteractiveObject = e.currentTarget as InteractiveObject;
        var tipData : TipData = fetch(source);

        if (tipData == null) {
            return;
        }
        updateSource_TipView(tipData.source, tipData.tipViewContent);
        _lastShowSource = source;

        tipData.tipViewContent.setData(tipData.tipValue);
        _stage.addChild(tipData.tipViewContent as DisplayObject);

        var mouseX : int = _stage.mouseX;
        var mouseY : int = _stage.mouseY;

        var view : DisplayObject = tipData.tipViewContent as DisplayObject;

        var p : Point;
        switch (tipData.toolTipMode) {
            case ToolTipMode.RIGHT_BOTTOM_CENTER:
                p = new Point(source.x + source.width, source.y + source.height / 2);
                p = source.parent.localToGlobal(p);
                view.x = p.x;
                view.y = p.y;
                break;
            case ToolTipMode.LEFT_TOP:
                p = new Point(source.x, source.y);
                p = source.parent.localToGlobal(p);
                view.x = p.x;
                view.y = p.y;
                break;
            case ToolTipMode.RIGHT_TOP:
                p = new Point(source.x + source.width, source.y);
                p = source.parent.localToGlobal(p);
                view.x = p.x;
                view.y = p.y;
                break;
            default:
                view.x = mouseX;
                view.y = mouseY;
                break;
        }
        if (view.x + view.width > _stage.stageWidth) {
            view.x = _stage.stageWidth - view.width - 10;
            view.y += source.height;
        }

        if (view.y + view.height > _stage.stageHeight) {
            view.y = _stage.stageHeight - view.height - 10 - source.height;

        }
        if (view.x < 0) {
            view.x = 0;
        }
        if (view.y < 0) {
            view.y = 0;
        }
    }

    private static function __outHandler(e : MouseEvent) : void {
        _lastShowSource = null;
        if (e == null) {
            return;
        }

        var source : InteractiveObject = e.currentTarget as InteractiveObject;
        removeSource_TipView(source);
        var tipData : TipData = fetch(source);

        if (tipData == null) {
            return;
        }
        STool.remove(tipData.tipViewContent as DisplayObject);
    }

    /**
     * 更新当前正在显示的TIP信息
     * @param source
     * @param view
     */
    private static function updateSource_TipView(source : InteractiveObject, view : ITipViewContent) : void {
        var hasIt : Boolean;
        for each (var arr : Array in _souce_tipView_map) {
            if (arr[0] == source) {
                arr[1] = view;
                hasIt = true;
                break;
            }
        }

        if (!hasIt) {
            _souce_tipView_map.push([source, view]);
        }
    }

    /**
     * 移除当前显示的TIP关系
     * @param source
     */
    private static function removeSource_TipView(source : InteractiveObject) : void {
        for (var i : int = 0; i < _souce_tipView_map.length; i++) {
            if (_souce_tipView_map[i][0] == source) {
                _souce_tipView_map.splice(i, 1);
                break;
            }
        }
    }

    /**
     * 查找已有的TIP数据
     * @param source
     * @return
     */
    private static function fetch(source : InteractiveObject) : TipData {
        if (source == null) {
            return null;
        }

        for each (var obj : TipData in _tipMaps) {
            if (obj.source == source) {
                return obj;
            }
        }

        return null;
    }
}
}

import com.xy.component.toolTip.ToolTip;
import com.xy.component.toolTip.interfaces.ITipViewContent;

import flash.display.DisplayObject;
import flash.display.InteractiveObject;
import flash.display.MovieClip;
import flash.events.MouseEvent;

class TipData {
    public var source : InteractiveObject;
    public var tipViewContent : ITipViewContent;
    public var tipValue : *;
    public var toolTipMode : int;

    public function TipData(source : InteractiveObject, tipViewContent : ITipViewContent, tipValue : *, toolTipMode : int) {
        this.source = source;
        this.tipViewContent = tipViewContent;
        this.tipValue = tipValue;
        this.toolTipMode = toolTipMode;

        var view : DisplayObject = (this.tipViewContent as DisplayObject);
        if (view.hasOwnProperty("mouseChildren")) {
            view["mouseChildren"] = false;
        }
        if (view.hasOwnProperty("mouseEnabled")) {
            view["mouseEnabled"] = false;
        }
    }

    public function destroy(overFun : Function, outFun : Function) : void {
        source.removeEventListener(MouseEvent.ROLL_OVER, overFun);
        source.removeEventListener(MouseEvent.ROLL_OUT, outFun);
        source = null;
        tipViewContent.destroy();
        tipViewContent = null;
        tipValue = null;
    }
}


