package com.xy.model.vo.uiStatus {
import com.xy.view.ui.STaskCard;


public class STaskStatus {
    /**
   * 是否显示
         */
    private var _visible : Boolean = false;

    /**
     * 是否是父节点隐藏的
     */
    public var hideById : int = -1;

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
    public var parentCard : STaskCard;

    public function get visible() : Boolean {
        return _visible;
    }

    public function setVisible(visible : Boolean, hideById : int = -1) : void {
        _visible = visible;
        if (!_visible) {
            this.hideById = hideById;
        } else {
            this.hideById = -1;
        }
    }

}
}
