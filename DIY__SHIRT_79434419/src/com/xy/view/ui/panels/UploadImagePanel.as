package com.xy.view.ui.panels {
import com.xy.component.alert.Alert;
import com.xy.component.alert.enum.AlertType;
import com.xy.component.buttons.ToggleButton;
import com.xy.component.buttons.ToggleButtonGroup;
import com.xy.component.buttons.event.ToggleButtonGroupEvent;
import com.xy.component.page.SPage;
import com.xy.component.page.event.SPageEvent;
import com.xy.model.vo.BitmapDataVo;
import com.xy.ui.BlackButton;
import com.xy.ui.BlueButton;
import com.xy.ui.ImageThumbUI;
import com.xy.ui.PageUI;
import com.xy.ui.TabButton;
import com.xy.util.Tools;
import com.xy.view.ui.componet.SAlertTextUI;
import com.xy.view.ui.componet.SImageThumbUI;
import com.xy.view.ui.events.SImageThumbUIEvent;
import com.xy.view.ui.events.UploadImagePanelEvent;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.events.SecurityErrorEvent;
import flash.net.FileFilter;
import flash.net.FileReference;
import flash.net.FileReferenceList;
import flash.text.TextField;
import flash.utils.ByteArray;

public class UploadImagePanel extends AbsPanel {

    private var _btn0 : TabButton;
    private var _btn1 : TabButton;
    private var _line : Shape;
    private var _line2 : Shape;

    private var _tabContainer0 : Sprite;
    private var _tabContainer1 : Sprite;

    private var _uploadBtn : BlueButton;
    private var _tf : TextField;

    private var _images : Array = [];

    private var _togGroup : ToggleButtonGroup;

    private var _clearBtn : BlueButton;

    private var _imageThumbs : Array = [];

    private var _spage : SPage;
    private var _pageUI : PageUI;

    public function UploadImagePanel(w : int = 720, h : int = 520, title : String = "添加图片") {
        super(w, h, title);

        _btn0 = Tools.makeTabButton("本地图片");

        _btn1 = Tools.makeTabButton("已上传图片");
        _btn1.x = _btn0.x + _btn0.width - 1;

        _line = new Shape();
        _line.graphics.lineStyle(1, 0xb8b8b8);
        _line.graphics.moveTo(_btn1.x + _btn1.width, _btn0.height - 1);
        _line.graphics.lineTo(_mask.width, _btn0.height - 1);

        _tabContainer0 = new Sprite();
        _tabContainer0.x = 0;
        _tabContainer0.y = _btn1.y + _btn1.height + 15;

        _tabContainer1 = new Sprite();
        _tabContainer1.x = 0;
        _tabContainer1.y = _btn1.y + _btn1.height + 15;

        _line2 = new Shape();
        _line2.graphics.lineStyle(1, 0xb8b8b8);
        _line2.graphics.moveTo(0, _mask.height - 40 - _tabContainer1.y);
        _line2.graphics.lineTo(_mask.width, _mask.height - 40 - _tabContainer1.y);

        _uploadBtn = Tools.makeBlueButton("普通上传");
        _uploadBtn.x = 15;

        _tf = new TextField();
        _tf.htmlText = "<font color='#666666' face='宋体'>简单快捷，支持多张上传</font>";
        _tf.width = getTabContainerWidth();
        _tf.height = 40;
        _tf.y = _uploadBtn.y + _uploadBtn.height + 10;
        _tf.x = _uploadBtn.x;


        _clearBtn = Tools.makeBlueButton("清空图片");
        _clearBtn.x = 15;
        _clearBtn.y = _mask.height - 40 - _tabContainer1.y + 10;

        _pageUI = new PageUI();
        _spage = new SPage(18);
        _spage.setCtrlUI(_pageUI.prevBtn, _pageUI.tf, _pageUI.nextBtn);
        _pageUI.x = (getTabContainerWidth() - _pageUI.width) / 2;
        _pageUI.y = _mask.height - 40 - _tabContainer1.y - 5 - _pageUI.height;


        container.addChild(_line);
        container.addChild(_btn0);
        container.addChild(_btn1);
        container.addChild(_tabContainer0);
        container.addChild(_tabContainer1);

        _tabContainer0.addChild(_uploadBtn);
        _tabContainer0.addChild(_tf);
        _tabContainer1.addChild(_line2);
        _tabContainer1.addChild(_clearBtn);
        _tabContainer1.addChild(_pageUI);


        _tabContainer1.visible = false;

        _togGroup = new ToggleButtonGroup();
        _togGroup.setToggleButtons(
            [
            new ToggleButton(_btn0),
            new ToggleButton(_btn1)
            ]
            );


        for (var i : int = 0; i < 3; i++) {
            for (var j : int = 0; j < 6; j++) {
                var thumb : SImageThumbUI = new SImageThumbUI();
                thumb.x = j * (thumb.width + 13);
                thumb.y = i * (thumb.height + 13);
                thumb.addEventListener(SImageThumbUIEvent.STATUS_CHANGE, __imageThumbHandler);
                _tabContainer1.addChild(thumb);

                _imageThumbs.push(thumb);
            }
        }

        _uploadBtn.addEventListener(MouseEvent.CLICK, __uploadHandler);
        _togGroup.addEventListener(ToggleButtonGroupEvent.STATE_CHANGE, __changeHandler);
        _spage.addEventListener(SPageEvent.PAGE_CHANGE, __pageHandler);
        _clearBtn.addEventListener(MouseEvent.CLICK, __clearAllHandler);

        updateDataShow();
    }

    /**
     * 更新数据
     * @param images
     */
    public function setData(images : Array) : void {
        _images = images;
        _spage.setDataCount(images.length, false);
		_btn1.tf.htmlText = "已上传图片(<font color='#FF0000'>"+ images.length +"</font>)";
        updateDataShow();
    }

    private function updateDataShow() : void {
        for (var i : int = 0; i < 18; i++) {
            var index : int = _spage.pageVo.getStartIndex() + i;
            var vo : BitmapDataVo = _images[index];
            var thumb : SImageThumbUI = _imageThumbs[i];
            if (vo == null) {
                thumb.visible = false;
            } else {
                thumb.visible = true;
                thumb.setData(vo);
            }
        }
    }

    private function getTabContainerWidth() : int {
        return _mask.width - 30;
    }

    private function getTabContainerHeight() : int {
        return _mask.height - _line.y - 15 - 40 - 15;
    }

    private function __uploadHandler(e : MouseEvent) : void {
        var fl : FileReferenceList = new FileReferenceList();
        fl.browse([new FileFilter("(图片文件)*.jpg,*.jpeg,*.png", "*.jpg;*.jpeg;*.png")]);

        var okSize : int = 0;
        fl.addEventListener(Event.SELECT, function(e : Event) : void {
            for each (var f : FileReference in fl.fileList) {
                f.addEventListener(IOErrorEvent.IO_ERROR, function(e2 : Event) : void {
                    okSize++;
                });
                f.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e3 : Event) : void {
                    okSize++;
                });
                f.addEventListener(Event.COMPLETE, function(e1 : Event) : void {
                    okSize++;

                    if (okSize >= fl.fileList.length) {
                        uploadOk(fl.fileList);
                    }
                });
                f.load();
            }
        });
    }

    private function uploadOk(list : Array) : void {
        var bmds : Array = [];
        var okLen : int = 0;
        for each (var f : FileReference in list) {
            var data : ByteArray = f.data;

            var loader : Loader = new Loader();
            loader.loadBytes(data);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e : Event) : void {
                okLen++;

                var bmp : Bitmap = e.currentTarget.content as Bitmap;
                if (bmp != null) {
                    bmds.push(bmp.bitmapData);
                }

                if (okLen >= list.length) {
                    dispatchEvent(new UploadImagePanelEvent(UploadImagePanelEvent.UPLOAD_IMAGE, bmds));
                }
            });
        }

        _togGroup.setSelected(1, true);
    }

    private function __changeHandler(e : ToggleButtonGroupEvent) : void {
        _tabContainer0.visible = _togGroup.selectIndex == 0;
        _tabContainer1.visible = _togGroup.selectIndex == 1;

        if (_tabContainer1.visible) {
            updateDataShow();
        }
    }

    private function __pageHandler(e : SPageEvent) : void {
        updateDataShow();
    }

    private function __clearAllHandler(e : MouseEvent) : void {
		Alert.show(new SAlertTextUI("确认<font color='#FF0000'>清空所有图片</font>？<br>清空后需要<font color='#FF0000'>重新上传</font>才能使用。"), function(type : int, value:*):void{
			if(type == AlertType.OK){
				dispatchEvent(new UploadImagePanelEvent(UploadImagePanelEvent.CLEAR_ALL_IMAGE));
			}
		});
    }

    private function __imageThumbHandler(e : SImageThumbUIEvent) : void {
        var thumb : SImageThumbUI = e.currentTarget as SImageThumbUI;
		thumb.vo.show = e.selected;
        dispatchEvent(new UploadImagePanelEvent(UploadImagePanelEvent.THUMB_STATUS_CHANGE, null, thumb.vo));
    }
}
}
