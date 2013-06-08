package {
import com.greensock.TweenLite;
import com.xy.ui.Loading;

public class LoadingController {
    private static var _mc : Loading;

    public static function initLoading(mc : Loading) : void {
        _mc = mc;
        stopLoading();
    }

    public static function showLoading() : void {
        TweenLite.killTweensOf(_mc);
        _mc.loading.gotoAndPlay(1);
        _mc.alpha = 1;
        _mc.loading.visible = true;
        _mc.errorTf.visible = false;
        _mc.visible = true;
    }

    public static function showError() : void {
        _mc.alpha = 1;
        _mc.loading.visible = false;
        _mc.errorTf.visible = true;
        _mc.visible = true;

        TweenLite.to(_mc, 0.5, {alpha: 0.3, onComplete: function() : void {
            _mc.visible = false;
        }, overwite: true, delay: 3});
    }

    public static function stopLoading() : void {
        _mc.loading.stop();
        _mc.visible = false;
    }
}
}
