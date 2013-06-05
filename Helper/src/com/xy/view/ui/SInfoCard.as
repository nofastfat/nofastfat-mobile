package com.xy.view.ui {
import com.xy.model.vo.OrganizedStructVo;
import com.xy.model.vo.SInfoList;
import com.xy.model.vo.SimpleSubordinateVo;
import com.xy.ui.InfoCard;
import com.xy.util.STool;

import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;

/**
 * 组织机构
 * @author xy
 */
public class SInfoCard extends InfoCard {
    private var _vo : OrganizedStructVo;

    private var _uiList : Array = [];

    private var _loader : Loader;

    public function SInfoCard() {
        super();
    }

    public function get vo() : OrganizedStructVo {
        return _vo;
    }

    public function setData(vo : OrganizedStructVo) : void {
        _vo = vo;
        STool.clear(iconContainer, [iconContainer.bg]);

        if (_loader != null) {
            _loader.unload();
        }
        _loader = new Loader();
        _loader.load(new URLRequest(vo.imgUrl));
        _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void{});
        iconContainer.addChild(_loader);

        sexMc.gotoAndStop(vo.sex + 1);
        nameTf.text = vo.name;
        companyTf.text = vo.company;
        statusMc.gotoAndStop(vo.status + 1);
        statusBg.gotoAndStop(vo.status + 1);
        jobTypeTf.text = vo.jobType;
        joinTimeTf.text = vo.joinTime;
        myScoreTf.text = vo.jobScore + "";
        leftSorceTf.text = vo.levelUpLastScore + "";
        subordinateCountTf.text = "（" + vo.simpleSubordinateList.length + "）";
        for each (var subVo : SimpleSubordinateVo in vo.simpleSubordinateList) {
            var line : SInfoList = new SInfoList();
            line.setData(subVo);
            _uiList.push(line);
        }


    }
}
}
