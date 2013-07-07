package com.xy.model.enum {

public class DiyDataNotice {
    private static const NAME : String = "DiyDataNotice";

    /**
     * 当前上传的图片数量更新
     */
    public static const IMAGE_UPDATE : String = NAME + "IMAGE_UPDATE";

    public static const BACKGROUND_UPDATE : String = NAME + "BACKGROUND_UPDATE";
    public static const DECORATE_UPDATE : String = NAME + "DECORATE_UPDATE";
    public static const FRAME_UPDATE : String = NAME + "FRAME_UPDATE";

    /**
     * vo : BitmapDataVo 
     */
    public static const MODEL_INIT : String = NAME + "MODEL_INIT";
    public static const MODEL_UPDATE : String = NAME + "MODEL_UPDATE";

    public static const HISTORY_UPDATE : String = NAME + "HISTORY_UPDATE";

}
}
