package com.xy.model.vo.uiStatus {
import com.xy.view.ui.SInfoCard;


public class SInfoCardStatus {
    /**
     * 是否显示
     */
    private var _visible : Boolean = false;

    /**
     * 是否是父节点隐藏的
     */
    public var hideById : String = "-1";

    /**
     * 直属下属显示的数量
     */
    public var showCount : int = 3;

    /**
     * X坐标
     */
    public var locationX : Number = 0;

    /**
     * Y坐标
     */
    public var locationY : Number = 0;

    /**
     * 父节点UI
     */
    public var parentCard : SInfoCard;

    public function get visible() : Boolean {
        return _visible;
    }

    public function setVisible(visible : Boolean, hideById : String = "-1") : void {
        _visible = visible;
        if (!_visible) {
            this.hideById = hideById;
        }else{
        	this.hideById = "-1";
        }
    }
}
}
