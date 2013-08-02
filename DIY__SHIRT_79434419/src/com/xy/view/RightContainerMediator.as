package com.xy.view {
import com.adobe.images.PNGEncoder;
import com.adobe.serialization.json.JSON;
import com.xy.component.alert.Alert;
import com.xy.component.alert.enum.AlertType;
import com.xy.interfaces.AbsMediator;
import com.xy.interfaces.Map;
import com.xy.model.URLConfig;
import com.xy.model.enum.DiyDataNotice;
import com.xy.model.enum.SourceType;
import com.xy.model.history.AddHistory;
import com.xy.model.history.BackgroundHistory;
import com.xy.model.history.ChangeModelHistory;
import com.xy.model.history.ChildIndexHistory;
import com.xy.model.history.DeleteHistory;
import com.xy.model.history.ModifyHistory;
import com.xy.model.history.MulityDeleteHistory;
import com.xy.model.history.MultyModifyHistory;
import com.xy.model.vo.BitmapDataVo;
import com.xy.model.vo.EditVo;
import com.xy.model.vo.ExportVo;
import com.xy.ui.BuyButton;
import com.xy.util.Base64;
import com.xy.util.EnterFrameCall;
import com.xy.util.Http;
import com.xy.util.MulityLoad;
import com.xy.util.PopUpManager;
import com.xy.util.SMouse;
import com.xy.util.STool;
import com.xy.util.Tools;
import com.xy.view.layer.RightContainer;
import com.xy.view.ui.SCtrlBar;
import com.xy.view.ui.componet.BitmapDragTip;
import com.xy.view.ui.componet.DiyBase;
import com.xy.view.ui.componet.DiyFont;
import com.xy.view.ui.componet.DiySystemImage;
import com.xy.view.ui.componet.GroupResize;
import com.xy.view.ui.componet.SAlertTextUI;
import com.xy.view.ui.componet.SMulityPageUI;
import com.xy.view.ui.componet.SUserCtrlBar;
import com.xy.view.ui.events.AbsPanelEvent;
import com.xy.view.ui.events.ChooseBackgroundPanelEvent;
import com.xy.view.ui.events.EditTextPanelEvent;
import com.xy.view.ui.events.SCtrlBarEvent;
import com.xy.view.ui.events.SLoginPanelEvent;
import com.xy.view.ui.events.SMulityPageUIEvent;
import com.xy.view.ui.events.SUserCtrlBarEvent;
import com.xy.view.ui.panels.ChooseBackgroundPanel;
import com.xy.view.ui.panels.ChooseCalendar;
import com.xy.view.ui.panels.EditTextPanel;
import com.xy.view.ui.panels.SLoginPanel;
import com.xy.view.ui.panels.SUploadPanel;

import deng.fzip.FZip;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.net.FileReference;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.net.navigateToURL;
import flash.text.Font;
import flash.utils.ByteArray;
import flash.utils.getTimer;
import flash.utils.setTimeout;


public class RightContainerMediator extends AbsMediator {
    public static const NAME : String = "RightContainerMediator";

    /**
     * 添加图片
     * [
     *   vo:BitmapDataVo
     *   stageX:Number
     *   stageY:Number
     * ]
     */
    public static const ADD_IMAGE : String = NAME + "ADD_IMAGE";

    /**
     * 添加文字
     * [
     *   font:Font
     *   stageX:Number
     *   stageY:Number
     * ]
     */
    public static const ADD_FONT : String = NAME + "ADD_FONT";

    public static const KEY_DELETE : String = NAME + "KEY_DELETE";

    public static const DELETE_BG : String = NAME + "DELETE_BG";

    /**
     * color:uint
     */
    public static const SET_BG_AS_COLOR : String = NAME + "SET_BG_AS_COLOR";

    private var _ctrlBar : SCtrlBar;

    private var _diyBg : Bitmap;
    private var _mask : Shape;
    private var _diyArea : Sprite;
    private var _diys : Array = [];

    private var _exportVo : ExportVo;

    private var _currentSelectImage : DiyBase;
    private var _diyBar : SUserCtrlBar;

    private var _lastX : Number;
    private var _lastY : Number;

    private var _chooseModelPanel : ChooseBackgroundPanel;

    private var _bmpDragTip : BitmapDragTip;

    private var _editPanel : EditTextPanel;

    private var _buyBtn : BuyButton;

    private var _selectedImages : Array;
    private var _selectStartPt : Point;

    private var _prevVo : EditVo;
    private var _prevVos : Array;

    private var _currentModelId : String;

    private var _groups : Array = [];

    private var _groupBg : GroupResize;

    private var _background : Sprite;

    private var _mulityPageUI : SMulityPageUI;

    private var _chooseCalPanel : ChooseCalendar;

    private var _loginPanel : SLoginPanel;

    private var _uploadPanel : SUploadPanel;

    public function RightContainerMediator(viewComponent : Object = null) {
        super(NAME, viewComponent);

        _chooseModelPanel = new ChooseBackgroundPanel(SourceType.MODEL, 720, 520, "选择模板");
        _chooseModelPanel.addEventListener(ChooseBackgroundPanelEvent.BACKGROUND_STATUS, __modelChangeHandler);
    }

    override public function makeNoticeMap() : Map {
        var map : Map = new Map();
        map.put(Event.RESIZE, resize);
        map.put(DiyDataNotice.MODEL_UPDATE, modelUpdate);
        map.put(DiyDataNotice.HISTORY_UPDATE, historyUpdate);
        map.put(ADD_IMAGE, addImage);
        map.put(ADD_FONT, addFont);
        map.put(KEY_DELETE, keyDelete);
        map.put(DELETE_BG, deleteBg);
        map.put(SET_BG_AS_COLOR, setBgAsColor);
        map.put(DiyDataNotice.MODEL_INIT, checkModel);
        return map;
    }

    override public function onRegister() : void {
        _ctrlBar = new SCtrlBar();
        _ctrlBar.x = _ctrlBar.y = 10;
        _mask = new Shape();
        _mask.graphics.beginFill(0xFF0000);
        _mask.graphics.drawRect(0, 0, 1, 1);
        _mask.graphics.endFill();

        _diyArea = new Sprite();

        _diyBg = new Bitmap();
        _background = new Sprite();
        _background.mouseChildren = false;
        _background.mouseEnabled = false;

        _buyBtn = new BuyButton();
        ui.container.addChild(_diyBg);
        ui.container.addChild(_mask);
        ui.container.addChild(_background);
        ui.container.addChild(_diyArea);
        ui.container.addChild(_ctrlBar);
        ui.container.addChild(_buyBtn);
        _diyArea.mask = _mask;

        _diyBar = new SUserCtrlBar(ui);

        _exportVo = new ExportVo();

        _bmpDragTip = new BitmapDragTip();

        _editPanel = new EditTextPanel();

        _groupBg = new GroupResize();

        _mulityPageUI = new SMulityPageUI();

        _chooseCalPanel = new ChooseCalendar();

        _loginPanel = new SLoginPanel();

        _uploadPanel = new SUploadPanel();

        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_UP, __upHandler);

        _ctrlBar.addEventListener(SCtrlBarEvent.CHANGE_MODEL, __changeModel);
        _ctrlBar.addEventListener(SCtrlBarEvent.UNDO, __undoHandler);
        _ctrlBar.addEventListener(SCtrlBarEvent.REDO, __redoHandler);
        _ctrlBar.addEventListener(SCtrlBarEvent.GROUP, __groupHandler);
        _ctrlBar.addEventListener(SCtrlBarEvent.UNGROUP, __ungroupHandler);


        _diyBar.addEventListener(SUserCtrlBarEvent.LINE_CHANGE, __lineChangeHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.LINE_COLOR, __lineColorHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.ALPHA, __alphaHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.UP_LEVEL, __upLevelHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.DOWN_LEVEL, __downLevelHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.DELETE, __deleteHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.FULL_STATUS, __fullStatusHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.SHOW_EDIT_TEXT_PANEL, __showEditTextPanel);
        _diyBar.addEventListener(SUserCtrlBarEvent.FONT_COLOR, __fontColorHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.FONT_FACE, __fontFaceHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.FONT_SIZE, __fontSizeHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.FONT_BOLD, __fontBoldHandler);
        _diyBar.addEventListener(SUserCtrlBarEvent.FONT_ALIGN, __fontAlignHandler);

        _loginPanel.addEventListener(SLoginPanelEvent.LOGIN, __loginHandler);
        _chooseCalPanel.addEventListener(AbsPanelEvent.CLOSE, __closeHandler);
        _mulityPageUI.addEventListener(SMulityPageUIEvent.SELECT_ONE, __selectOneHandler);
        _buyBtn.addEventListener(MouseEvent.CLICK, __buyHandler);
        _editPanel.addEventListener(EditTextPanelEvent.EDIT, __editOkHandler);
        ui.bg.addEventListener(MouseEvent.MOUSE_DOWN, __bgDownHandler);
    }

    private function resize() : void {
        if (_ctrlBar != null) {
            _ctrlBar.resize();
        }

        if (_mulityPageUI != null && _mulityPageUI.stage != null) {
            _mulityPageUI.resize();
        }

        if (_diyBg != null) {
            _diyBg.x = (EnterFrameCall.getStage().stageWidth - 200 - _diyBg.width) / 2;

            var h : Number = EnterFrameCall.getStage().stageHeight - _diyBg.height - _ctrlBar.y - _ctrlBar.height;

            if (_mulityPageUI != null && _mulityPageUI.stage != null) {
                h -= _mulityPageUI.height;
            }
            _diyBg.y = h / 2 + _ctrlBar.y + _ctrlBar.height;

            if (_mask != null && dataProxy.currentSelectModel != null) {
                _mask.x = dataProxy.currentSelectModel.rect.x + _diyBg.x;
                _mask.y = dataProxy.currentSelectModel.rect.y + _diyBg.y;
                _mask.width = dataProxy.currentSelectModel.rect.width;
                _mask.height = dataProxy.currentSelectModel.rect.height;
            }

            if (_diyArea != null) {
                _diyArea.x = _diyBg.x;
                _diyArea.y = _diyBg.y;
            }

            if (_background != null) {
                _background.x = _diyBg.x;
                _background.y = _diyBg.y;
            }
        }

        if (dataProxy.currentSelectModel != null) {
            var newRect : Rectangle = dataProxy.currentSelectModel.rect.clone();
            var p : Point = new Point(_mask.x, _mask.y);
            p = ui.localToGlobal(p);
            newRect.x = p.x;
            newRect.y = p.y;
            SMouse.getInstance().setHotArea(newRect);
        }

        if (_currentSelectImage != null) {
            _currentSelectImage.bg.showTo(ui.container);
            if (_diyBar != null && _diyBar.stage != null) {
                _diyBar.showByDiyBase(_currentSelectImage);
            }
        }

        if (_bmpDragTip != null) {
            _bmpDragTip.x = EnterFrameCall.getStage().stageWidth - _bmpDragTip.width - 10;
            _bmpDragTip.y = _ctrlBar.y + _ctrlBar.height + 10;
        }

        if (_buyBtn != null) {
            _buyBtn.x = EnterFrameCall.getStage().stageWidth - 200 - _buyBtn.width - 40;
            _buyBtn.y = EnterFrameCall.getStage().stageHeight - _buyBtn.height - 20;
        }

    }

    private function modelUpdate(record : Boolean) : void {
        if (_currentModelId == dataProxy.currentSelectModel.id) {
            return;
        }

        if (_currentModelId != null && record) {
            dataProxy.recordHistory(new ChangeModelHistory(_currentModelId, dataProxy.currentSelectModel.id));
        }

        _diyBg.bitmapData = dataProxy.currentSelectModel.bmd;
        resize();
        _exportVo.vo = dataProxy.currentSelectModel;
        _exportVo.bgData = dataProxy.currentSelectModel.bgs[0];

        if (_chooseModelPanel.stage != null) {
            _chooseModelPanel.setData(dataProxy.models);
        }
        _currentModelId = dataProxy.currentSelectModel.id;

        if (dataProxy.currentSelectModel.page > 1) {
            ui.container.addChild(_mulityPageUI);
        } else {
            STool.remove(_mulityPageUI);
        }

        resize();
    }

    private function historyUpdate() : void {
        _ctrlBar.updateData(dataProxy.ctrlHistory, dataProxy.currentHistoryIndex);
    }

    private function addImage(vo : BitmapDataVo, stageX : Number, stageY : Number, id : String = null, needRecord : Boolean = true, needreDrawResult : Boolean = true) : void {
        if (vo.cate == "bg") {
            var oldData : * = _exportVo.bgData;
            var bmp : Bitmap = new Bitmap(vo.bmd);
            var rect : Rectangle = dataProxy.currentSelectModel.rect;
            bmp.width = rect.width;
            bmp.height = rect.height;
            bmp.x = rect.x;
            bmp.y = rect.y;
            STool.clear(_background);
            _background.addChild(bmp);
            _exportVo.bgData = vo.id;
            if (needRecord) {
                dataProxy.recordHistory(new BackgroundHistory(setBackground, oldData, _exportVo.bgData));
            }
            sendNotification(BackgroundMediator.UPDATE_DELETE_BG, _background.numChildren > 0);
            checkCalBg();
        } else {
            var image : DiySystemImage = new DiySystemImage(vo, dataProxy.currentSelectModel.rect, _bmpDragTip, id);
            addAndRecordDiy(image, stageX, stageY);
            if (needRecord) {
                dataProxy.recordHistory(new AddHistory(addImage, deleteDiyById, vo, stageX, stageY, image.id));
            }
        }

        if (needreDrawResult) {
            reDrawResult();
        }
    }

    private function setBackground(data : *, needreDrawResult : Boolean = true) : void {
        if (data == null) {
            deleteBg(false, needreDrawResult);
        } else if (data is uint) {
            setBgAsColor(data as uint, false, needreDrawResult);
        } else {
            var vo : BitmapDataVo = dataProxy.getBitmapDataVoById(data as String);

            if (vo != null) {
                addImage(vo, 0, 0, null, false, needreDrawResult);
            }
        }
    }

    private function checkCalBg() : void {
        if (_exportVo.calVo != null) {
            var bmp : Bitmap = new Bitmap(_exportVo.calVo.bmd);
            var rect : Rectangle = dataProxy.currentSelectModel.calRect;
            var rect2 : Rectangle = dataProxy.currentSelectModel.rect;
            bmp.width = rect.width;
            bmp.height = rect.height;
            bmp.x = rect.x + rect2.x;
            bmp.y = rect.y + rect2.y;
            _background.addChild(bmp);
        }
    }

    public function reDrawResult() : void {
        var arr : Array = [];
        for(var i : int = 0; i < _diyArea.numChildren; i++){
        	var diy : DiyBase = _diyArea.getChildAt(i) as DiyBase;
            arr.push(diy.editVo.clone());
        }
        _exportVo.diys = arr;

        var rect : Rectangle = dataProxy.currentSelectModel.rect;
        var p : Point = rect.topLeft.clone();
        var bmd : BitmapData = new BitmapData(rect.width, rect.height, true, 0x00000000);
        var mat : Matrix = new Matrix();
        mat.translate(-p.x, -p.y);

        _diyArea.mask = null;
        bmd.draw(_background, mat);
        bmd.draw(_diyArea, mat, null, null, new Rectangle(0, 0, rect.width, rect.height), true);
        _diyArea.mask = _mask;
        _exportVo.exportBmd = bmd;
        _mulityPageUI.updateSelectedShow();
    }

    private function deleteDiyById(id : String) : void {
        var diyTmp : DiyBase = getDiyBaseById(id);

        var index : int = _diys.indexOf(diyTmp);
        if (index == -1) {
            var vo : BitmapDataVo = dataProxy.getBitmapDataVoById(id);
            if (vo != null && vo.cate == "bg") {
                STool.clear(_background);
            }
            return;
        }

        _diys.splice(index, 1);
        diyTmp.deleted();

        diyTmp.removeEventListener(MouseEvent.DOUBLE_CLICK, __showEditTextPanel);
        diyTmp.removeEventListener(MouseEvent.MOUSE_DOWN, __downHandler);

        if (diyTmp == _currentSelectImage) {
            _currentSelectImage = null;
            __unSelectHandler(null);
            _diyBar.hide();
        }
    }

    private function drag() : void {
        var stageX : Number = EnterFrameCall.getStage().mouseX;
        var stageY : Number = EnterFrameCall.getStage().mouseY;

        if (_selectedImages == null || _selectedImages.length == 0) {
            _currentSelectImage.moveOffset(stageX - _lastX, stageY - _lastY);

            _diyBar.showByDiyBase(_currentSelectImage);
        } else {
            for each (var diy : DiyBase in _selectedImages) {
                diy.moveOffset(stageX - _lastX, stageY - _lastY);
            }
        }

        _lastX = stageX;
        _lastY = stageY;

    }

    private function addByEditVo(editVo : EditVo, redraw : Boolean) : void {
        var p : Point = new Point(editVo.ix, editVo.iy);
        p = _diyArea.localToGlobal(p);
        if (editVo.isImage) {
            addImage(dataProxy.getBitmapDataVoById(editVo.bmdId), p.x, p.y, editVo.id, false, redraw);
        } else {
            addFont(dataProxy.getFontByName(editVo.fontName), p.x, p.y, editVo.id, false, redraw);
        }

        var diy : DiyBase = getDiyBaseById(editVo.id);
        diy.setByEditVo(editVo);
        _diyBar.showByDiyBase(diy);
    }

    public function updateDiyBar() : void {
        if (_currentSelectImage != null) {
            _diyBar.showByDiyBase(_currentSelectImage);

            if (_currentSelectImage.editVo.isFull) {
                _bmpDragTip.showBy(_currentSelectImage as DiySystemImage);
            } else {
                STool.remove(_bmpDragTip);
            }
        }
    }

    private function addFont(font : Font, stageX : Number, stageY : Number, id : String = null, needRecord : Boolean = true, redraw : Boolean = true) : void {
        var image : DiyFont = new DiyFont(font, id);
        addAndRecordDiy(image, stageX, stageY);

        image.doubleClickEnabled = true;
        image.addEventListener(MouseEvent.DOUBLE_CLICK, __showEditTextPanel);

        if (needRecord) {
            dataProxy.recordHistory(new AddHistory(addFont, deleteDiyById, font, stageX, stageY, image.id));
        }

        if (redraw) {
            reDrawResult();
        }
    }

    private function keyDelete() : void {
        if (_currentSelectImage != null) {
            __deleteHandler(null);
        }

        if (_selectedImages != null && _selectedImages.length != 0) {
            var vos : Array = [];
            for each (var diy : DiyBase in _selectedImages) {
                vos.push(diy.editVo.clone());

                deleteDiyById(diy.id);
            }
            dataProxy.recordHistory(new MulityDeleteHistory(mulityDelete, mulityAdd, vos));
            reDrawResult();
        }
    }

    private function deleteBg(record : Boolean = true, needReDraw : Boolean = true) : void {
        var oldData : * = _exportVo.bgData;
        STool.clear(_background);
        _exportVo.bgData = null;

        if (record) {
            dataProxy.recordHistory(new BackgroundHistory(setBackground, oldData, _exportVo.bgData));
        }
        sendNotification(BackgroundMediator.UPDATE_DELETE_BG, _background.numChildren > 0);
        checkCalBg();

        if (needReDraw) {
            reDrawResult();
        }
    }

    private function setBgAsColor(color : uint, record : Boolean = true, needreDrawResult : Boolean = true) : void {
        var oldData : * = _exportVo.bgData;
        STool.clear(_background);
        var shape : Shape = new Shape();
        _background.addChild(shape);
        _exportVo.bgData = color;

        var rect : Rectangle = dataProxy.currentSelectModel.rect;
        shape.graphics.beginFill(color);
        shape.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
        shape.graphics.endFill();
        _background.addChild(shape);

        if (record) {
            dataProxy.recordHistory(new BackgroundHistory(setBackground, oldData, _exportVo.bgData));
        }
        sendNotification(BackgroundMediator.UPDATE_DELETE_BG, _background.numChildren > 0);
        checkCalBg();

        if (needreDrawResult) {
            reDrawResult();
        }
    }

    private function addAndRecordDiy(diy : DiyBase, stageX : Number, stageY : Number) : void {
        __unSelectHandler(null);

        var p : Point = new Point(stageX, stageY);
        p = _diyArea.globalToLocal(p);
        diy.x = p.x;
        diy.y = p.y;

        _diys.push(diy);
        _diyArea.addChild(diy);
        diy.bg.showTo(ui.container);
        diy.addEventListener(MouseEvent.MOUSE_DOWN, __downHandler);
        diy.resetRegister();
        _diyBar.showByDiyBase(diy);
        _currentSelectImage = diy;
    }


    public function getDiyBaseById(id : String) : DiyBase {
        for each (var diy : DiyBase in _diys) {
            if (diy.id == id) {
                return diy;
            }
        }

        return null;
    }

    private function upLevel(id : String) : void {
        var diy : DiyBase = getDiyBaseById(id);
        diy.upLevel();
    }

    private function downLevel(id : String) : void {
        var diy : DiyBase = getDiyBaseById(id);
        diy.downLevel();
    }

    private function setMulitiData(vos : Array) : void {
        for each (var vo : EditVo in vos) {
            var diy : DiyBase = getDiyBaseById(vo.id);
            if (diy != null) {
                diy.setByEditVo(vo);
            }
        }
    }

    public function mulityAdd(vos : Array, redraw : Boolean = true) : void {
        for each (var vo : EditVo in vos) {
            addByEditVo(vo, redraw);
        }
    }

    public function mulityDelete(vos : Array) : void {
        for each (var vo : EditVo in vos) {
            deleteDiyById(vo.id);
        }
    }

    private function makeGroup() : void {
        if (_selectedImages == null || _selectedImages.length < 2) {
            return;
        }

        var id : String = Tools.makeId();
        for each (var diy : DiyBase in _selectedImages) {
            diy.groupBy(id);
        }
        _groups.push(id);
        _groupBg.showTo(ui.container, getGroupsById(id));
        __unSelectHandler();
    }

    public function getGroupsById(id : String) : Array {
        var rs : Array = [];
        for each (var diy : DiyBase in _diys) {
            if (diy.editVo.groupId == id) {
                rs.push(diy);
            }
        }

        return rs;
    }

    private function __downHandler(e : MouseEvent) : void {
        if (_selectedImages == null || _selectedImages.length == 0) {
            __unSelectHandler();

            var sp : DiyBase = e.currentTarget as DiyBase;

            _currentSelectImage = sp;
            _diyBar.hide();
            sp.bg.showTo(ui.container);

            if (_currentSelectImage.editVo.isFull) {
                _bmpDragTip.showBy(_currentSelectImage as DiySystemImage);
            } else {
                STool.remove(_bmpDragTip);
            }

            if (_currentSelectImage != null) {
                _prevVo = _currentSelectImage.editVo.clone();
            }
        } else {
            _prevVos = [];
            for each (var diy : DiyBase in _selectedImages) {
                _prevVos.push(diy.editVo.clone());
            }
        }

        EnterFrameCall.add(drag);
        _lastX = e.stageX;
        _lastY = e.stageY;
    }

    private function __changeModel(e : SCtrlBarEvent) : void {
        _chooseModelPanel.setData(dataProxy.models);

        PopUpManager.getInstance().showPanel(_chooseModelPanel);
    }

    private function __undoHandler(e : SCtrlBarEvent) : void {
        dataProxy.undo();
    }

    private function __redoHandler(e : SCtrlBarEvent) : void {
        dataProxy.redo();
    }

    private function __groupHandler(e : SCtrlBarEvent) : void {
        makeGroup();
    }

    private function __ungroupHandler(e : SCtrlBarEvent) : void {

    }

    private function __modelChangeHandler(e : ChooseBackgroundPanelEvent) : void {
        STool.clear(_background);
        PopUpManager.getInstance().closeAll();
        if (_diyArea.numChildren != 0) {
            Alert.show(new SAlertTextUI("更换模板将删除现有DIY，确认更换?"), function(type : int, data : *) : void {
                if (type == AlertType.OK) {
                    checkModel(e.vo);
                } else {
                    e.vo.show = false;
                }
            });
        } else {
            checkModel(e.vo);
        }
        EnterFrameCall.getStage().focus = null;
        _exportVo.bgData = null;
    }

    private var _tempVo : BitmapDataVo;

    private function checkModel(vo : BitmapDataVo) : void {
        _tempVo = vo;
        if (vo.calStyle != null && vo.calStyle != "") {
            _chooseCalPanel.setData(dataProxy.getSelectAbleCals(vo.calStyle));
            PopUpManager.getInstance().showPanel(_chooseCalPanel);
        } else {
            startLoadModelSource();
        }
    }

    private function startLoadModelSource(cals : Array = null) : void {
        var loads : Array = [];
        if (cals != null) {
            loads = cals.concat();
        }

        for each (var bg : String in _tempVo.bgs) {
            var tmp : BitmapDataVo = dataProxy.getBitmapDataVoById(bg);
            if (tmp != null && tmp.bmd == null) {
                loads.push(tmp);
            }
        }

        if (loads.length == 0) {
            changeModel(_tempVo, cals);
        } else {
            MulityLoad.getInstance().load(loads, function() : void {
                changeModel(_tempVo, cals);
            }, 0);
        }
    }

    private function changeModel(vo : BitmapDataVo, cals : Array) : void {
        dataProxy.chooseModel(vo);
        dataProxy.clearHistorys();

        if (vo.page > 1) {
            ui.container.setChildIndex(_diyBg, 3);
        } else {
            ui.container.setChildIndex(_diyBg, 0);
        }

        if (vo.page > 1) {
            dataProxy.currentPageDatas = [];
            for (var i : int = 0; i < vo.page; i++) {
                var exportVo : ExportVo = new ExportVo();
                exportVo.vo = vo;

                if (i >= vo.bgs.length) {
                    exportVo.bgData = vo.bgs[vo.bgs.length - 1];
                } else {
                    exportVo.bgData = vo.bgs[i];
                }
                if (i != 0 && i != vo.page && cals != null) {
                    exportVo.calVo = cals[i - 1];
                }
                var tmp : BitmapDataVo = dataProxy.getBitmapDataVoById(exportVo.bgData);

                var sp : Sprite = new Sprite();
                var bmp : Bitmap = new Bitmap(tmp.bmd);
                var rect : Rectangle = vo.rect;
                bmp.width = rect.width;
                bmp.height = rect.height;
                sp.addChild(bmp);
                if (exportVo.calVo != null) {
                    var bmp2 : Bitmap = new Bitmap(exportVo.calVo.bmd);
                    rect = vo.calRect;
                    bmp2.width = rect.width;
                    bmp2.height = rect.height;
                    bmp2.x = rect.x;
                    bmp2.y = rect.y;
                    sp.addChild(bmp2);
                }

                var rsBmd : BitmapData = new BitmapData(sp.width, sp.height, true, 0x00000000);
                rsBmd.draw(sp);
                exportVo.exportBmd = rsBmd;

                exportVo.index = i;

                dataProxy.currentPageDatas.push(exportVo);
            }

            _exportVo = dataProxy.currentPageDatas[0];
        } else {
            _exportVo = new ExportVo();
        }
        if (vo.bgs.length != 0) {
            setBackground(vo.bgs[0]);
        }

        clear();
        _mulityPageUI.setData(dataProxy.currentPageDatas);
    }

    private function __lineChangeHandler(e : SUserCtrlBarEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }
        var prevVo : EditVo = _currentSelectImage.editVo.clone();
        _currentSelectImage.setLineSickness(e.data);
        var nextVo : EditVo = _currentSelectImage.editVo.clone();
        dataProxy.recordHistory(new ModifyHistory(prevVo, nextVo));

        reDrawResult();
    }

    private function __lineColorHandler(e : SUserCtrlBarEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }
        var prevVo : EditVo = _currentSelectImage.editVo.clone();
        _currentSelectImage.setColor(e.data);
        var nextVo : EditVo = _currentSelectImage.editVo.clone();
        dataProxy.recordHistory(new ModifyHistory(prevVo, nextVo));
        reDrawResult();
    }

    private function __alphaHandler(e : SUserCtrlBarEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }
        _currentSelectImage.setAlpha(e.data);
    }

    private function __upLevelHandler(e : SUserCtrlBarEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }
        var rs : Boolean = _currentSelectImage.upLevel();
        if (rs) {
            dataProxy.recordHistory(new ChildIndexHistory(upLevel, downLevel, _currentSelectImage.id));
            reDrawResult();
        }
    }

    private function __downLevelHandler(e : SUserCtrlBarEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }
        var rs : Boolean = _currentSelectImage.downLevel();
        if (rs) {
            dataProxy.recordHistory(new ChildIndexHistory(downLevel, upLevel, _currentSelectImage.id));
            reDrawResult();
        }
    }

    private function __deleteHandler(e : SUserCtrlBarEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }

        dataProxy.recordHistory(new DeleteHistory(deleteDiyById, addByEditVo, _currentSelectImage.editVo.clone()));
        deleteDiyById(_currentSelectImage.id);
        EnterFrameCall.getStage().focus = null;
        reDrawResult();
    }

    private function __fullStatusHandler(e : SUserCtrlBarEvent) : void {
        var status : Boolean = e.data;
        if (_currentSelectImage == null) {
            return;
        }
        var prevVo : EditVo = _currentSelectImage.editVo.clone();
        if (_currentSelectImage is DiySystemImage) {
            (_currentSelectImage as DiySystemImage).setFullStatus(status);
        }

        _currentSelectImage.bg.showTo(ui.container);
        var nextVo : EditVo = _currentSelectImage.editVo.clone();
        dataProxy.recordHistory(new ModifyHistory(prevVo, nextVo));
        reDrawResult();
    }

    private function __showEditTextPanel(e : Event) : void {
        PopUpManager.getInstance().showPanel(_editPanel);

        if (_currentSelectImage != null) {
            _editPanel.setText(_currentSelectImage.editVo.text);
        }
    }

    private function __fontColorHandler(e : SUserCtrlBarEvent) : void {

        if (_currentSelectImage == null) {
            return;
        }

        if (_currentSelectImage is DiyFont) {
            var prevVo : EditVo = _currentSelectImage.editVo.clone();
            (_currentSelectImage as DiyFont).setColor(e.data);
            var nextVo : EditVo = _currentSelectImage.editVo.clone();
            dataProxy.recordHistory(new ModifyHistory(prevVo, nextVo));
            reDrawResult();
        }
    }

    private function __fontFaceHandler(e : SUserCtrlBarEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }

        if (_currentSelectImage is DiyFont) {
            var prevVo : EditVo = _currentSelectImage.editVo.clone();
            (_currentSelectImage as DiyFont).setFontFace(e.data);
            var nextVo : EditVo = _currentSelectImage.editVo.clone();
            dataProxy.recordHistory(new ModifyHistory(prevVo, nextVo));
            reDrawResult();
        }
    }

    private function __fontSizeHandler(e : SUserCtrlBarEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }

        if (_currentSelectImage is DiyFont) {
            var prevVo : EditVo = _currentSelectImage.editVo.clone();
            (_currentSelectImage as DiyFont).setFontSize(e.data);
            var nextVo : EditVo = _currentSelectImage.editVo.clone();
            dataProxy.recordHistory(new ModifyHistory(prevVo, nextVo));
            reDrawResult();
        }
    }

    private function __fontBoldHandler(e : SUserCtrlBarEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }

        if (_currentSelectImage is DiyFont) {
            var prevVo : EditVo = _currentSelectImage.editVo.clone();
            (_currentSelectImage as DiyFont).setFontBold(e.data);
            var nextVo : EditVo = _currentSelectImage.editVo.clone();
            dataProxy.recordHistory(new ModifyHistory(prevVo, nextVo));
            reDrawResult();
        }
    }

    private function __fontAlignHandler(e : SUserCtrlBarEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }

        if (_currentSelectImage is DiyFont) {
            var prevVo : EditVo = _currentSelectImage.editVo.clone();
            (_currentSelectImage as DiyFont).setFontAlign(e.data);
            var nextVo : EditVo = _currentSelectImage.editVo.clone();
            dataProxy.recordHistory(new ModifyHistory(prevVo, nextVo));
            reDrawResult();
        }
    }

    private function __loginHandler(e : SLoginPanelEvent) : void {
        dataProxy.uName = e.uName;
        dataProxy.uPwd = e.pwd;

        uploadTMp();
    }

    private function __closeHandler(e : AbsPanelEvent) : void {
        startLoadModelSource(_chooseCalPanel.getResult());
    }

    private function __selectOneHandler(e : SMulityPageUIEvent) : void {
        clear();
        dataProxy.clearHistorys();
        _exportVo = e.vo;

        setBackground(e.vo.bgData, false);

        var arr : Array = [];
        mulityAdd(e.vo.diys, false);
        _diyBar.hide();
        for each (var diy : DiyBase in _diys) {
            diy.bg.hide();
        }
    }

    private function clear() : void {
        for each (var diy : DiyBase in _diys) {
            diy.deleted();
        }
        _diyBar.hide();
        STool.clear(_diyArea);
        _diys = [];
        STool.remove(_bmpDragTip);
        _currentModelId = null;
        _currentSelectImage = null;
        _tempVo = null;
    }

    private function __buyHandler(e : MouseEvent) : void {
        if (_diyArea.numChildren == 0) {
            Alert.show(new SAlertTextUI("先DIY一个自己的作品吧"));
            return;
        }


        var debug : String = STool.getUrlParam("debug");
        if (debug == "true1") {
            var f : FileReference = new FileReference();
            if (dataProxy.currentSelectModel.page == 1) {
                var ba : ByteArray = PNGEncoder.encode(_exportVo.exportBmd);
                _diyArea.mask = _mask;
                f.save(ba, "DIY_" + getTimer() + ".png");
            } else {
                var fzip : FZip = new FZip();
                for (var i : int = 0; i < dataProxy.currentPageDatas.length; i++) {
                    var expVp : ExportVo = dataProxy.currentPageDatas[i];
                    ba = PNGEncoder.encode(expVp.exportBmd);
                    var name : String = "";
                    if (i == 0) {
                        name = "封面";
                    } else if (i == dataProxy.currentPageDatas.length - 1) {
                        name = "封底";
                    } else {
                        name = "第" + i + "张";
                    }
                    fzip.addFile(name + ".png", ba);
                }

                var rs : ByteArray = new ByteArray();
                fzip.serialize(rs);
                rs.position = 0;
                f.save(rs, "DIY_" + getTimer() + ".zip");
            }
        } else {
            if (dataProxy.uName == null) {
                PopUpManager.getInstance().showPanel(_loginPanel);
                _loginPanel.setPwdNull();
            } else {
                uploadTMp();
            }
        }
    }

    private function uploadTMp() : void {
        PopUpManager.getInstance().closeAll();
        PopUpManager.getInstance().showPanel(_uploadPanel);
        _uploadPanel.playMc();
        _uploadPanel.setData("正在上传您的作品，请稍候");
        setTimeout(upload, 500);
    }

    private function upload() : void {
        var params : URLVariables = new URLVariables();
        params.uName = dataProxy.uName;
        params.uPwd = dataProxy.uPwd;
		params.id = dataProxy.currentSelectModel.id;
        params.pageCount = dataProxy.currentSelectModel.page;
        var images : Array = [];
        if (dataProxy.currentSelectModel.page == 1) {
            var ba : ByteArray = PNGEncoder.encode(_exportVo.exportBmd);
            images.push(Base64.encode(ba));
			
        } else {
            for (var i : int = 0; i < dataProxy.currentPageDatas.length; i++) {
                var expVp : ExportVo = dataProxy.currentPageDatas[i];
                ba = PNGEncoder.encode(expVp.exportBmd);
				images.push(Base64.encode(ba));
            }
        }
        params.images = JSON.encode(images);

        new Http(URLConfig.UPLOAD_URL, function(data : String) : void {
            PopUpManager.getInstance().closeAll();
            var rs : *;

            if (data != null) {
                try {
                    rs = JSON.decode(data);
                } catch (e : Error) {
                    rs = null;
                }
            }
            if (rs == null || rs.status != 0) {
            	dataProxy.uName = dataProxy.uPwd = null;
                var txt : String = "上传失败，请稍候再试";
                if (rs != null) {
                    txt = rs.data;
                }
                Alert.show(new SAlertTextUI(txt), function(type : int, data : *) : void {
                });
            } else {
                Alert.show(new SAlertTextUI("上传成功，是否查看购物车？"), function(type : int, data : *) : void {
                    if (type == AlertType.OK) {
                        navigateToURL(new URLRequest(rs.data), "_blank");
                    }
                });
            }
        }, URLLoaderDataFormat.TEXT, params, URLRequestMethod.POST);
    }

    private function __editOkHandler(e : EditTextPanelEvent) : void {
        if (_currentSelectImage == null) {
            return;
        }

        if (_currentSelectImage is DiyFont) {
            var prevVo : EditVo = _currentSelectImage.editVo.clone();
            (_currentSelectImage as DiyFont).setText(e.text);
            var nextVo : EditVo = _currentSelectImage.editVo.clone();
            dataProxy.recordHistory(new ModifyHistory(prevVo, nextVo));
            reDrawResult();
        }
        EnterFrameCall.getStage().focus = null;
    }

    private function __bgDownHandler(e : MouseEvent) : void {
        __unSelectHandler();
        _selectStartPt = new Point(EnterFrameCall.getStage().mouseX, EnterFrameCall.getStage().mouseY);
        _selectStartPt = ui.globalToLocal(_selectStartPt);

        EnterFrameCall.getStage().addEventListener(MouseEvent.MOUSE_MOVE, __updateSelectedHandler);
    }

    private function __upHandler(e : MouseEvent) : void {
        EnterFrameCall.del(drag);
        EnterFrameCall.getStage().removeEventListener(MouseEvent.MOUSE_MOVE, __updateSelectedHandler);

        ui.selectUI.graphics.clear();
        _groupBg.hide();

        if (_prevVos != null && _prevVos.length != 0 && _selectedImages != null && _prevVos[0].ix != _selectedImages[0].editVo.ix && _prevVos[0].iy != _selectedImages[0].editVo.iy) {
            var nowVos : Array = [];
            for each (var diy : DiyBase in _selectedImages) {
                nowVos.push(diy.editVo.clone());
            }

            dataProxy.recordHistory(new MultyModifyHistory(setMulitiData, _prevVos, nowVos));
            reDrawResult();
        }

        if (_prevVo != null && _prevVo.ix != _currentSelectImage.editVo.ix && _prevVo.iy != _currentSelectImage.editVo.iy && _currentSelectImage != null) {
            dataProxy.recordHistory(new ModifyHistory(_prevVo, _currentSelectImage.editVo.clone()));
            reDrawResult();
        }

        _prevVo = null;
        _prevVos = null;
    }

    private function __unSelectHandler(e : MouseEvent = null) : void {
        if (_currentSelectImage != null) {
            _diyBar.hide();
        }

        for each (var diy : DiyBase in _diys) {
            diy.bg.hide();
        }
        _currentSelectImage = null;
        _selectedImages = null;
        STool.remove(_bmpDragTip);
    }

    private function __updateSelectedHandler(e : MouseEvent) : void {
        var nowPt : Point = new Point(EnterFrameCall.getStage().mouseX, EnterFrameCall.getStage().mouseY);
        nowPt = ui.globalToLocal(nowPt);
        ui.selectUI.graphics.clear();
        ui.selectUI.graphics.lineStyle(1, 0xb8b8b8, 0.9);
        ui.selectUI.graphics.beginFill(0xCCCCCC, 0.3);

        var startX : Number = Math.min(nowPt.x, _selectStartPt.x);
        var startY : Number = Math.min(nowPt.y, _selectStartPt.y);

        ui.selectUI.graphics.drawRect(startX, startY, Math.abs(nowPt.x - _selectStartPt.x), Math.abs(nowPt.y - _selectStartPt.y));
        ui.selectUI.graphics.endFill();

        _selectedImages = [];

        for each (var diy : DiyBase in _diys) {
            if (ui.selectUI.hitTestObject(diy.getChildAt(0))) {
                diy.bg.showTo(ui.container, true);
                _selectedImages.push(diy);
            } else {
                diy.bg.hide();
            }
        }

        if (_selectedImages.length == 1) {
            _selectedImages[0].bg.showTo(ui.container, false);
        }

        _ctrlBar.updateGroup(_selectedImages.length > 1, false);
    }

    public function get ui() : RightContainer {
        return viewComponent as RightContainer;
    }
}
}
