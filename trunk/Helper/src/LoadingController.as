package {
import flash.display.MovieClip;

public class LoadingController {
    private static var _mc : MovieClip;

    public static function initLoading(mc : MovieClip) : void {
        _mc = mc;
        stopLoading();
    }

    public static function showLoading() : void {
        _mc.gotoAndPlay(1);
        _mc.visible = true;
    }

    public static function stopLoading() : void {
        _mc.stop();
        _mc.visible = false;
    }
}
}
