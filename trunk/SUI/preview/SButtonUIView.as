package {
	import com.xy.ui.SButtonUI;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import fl.livepreview.LivePreviewParent;
	import flash.external.ExternalInterface;
	
	public class SButtonUIView extends SButtonUI {

		private var lp:LivePreviewParent;

		public function SButtonUIView() {
			lp = new LivePreviewParent  ;
			lp.myInstance = this;
		}

		/**
		*当组件中改变参数时触发onUpdate，这时更新值
		*/
		public function onUpdate(e:Event):void {
			this.updateTf();
		}

		/**
		*当组件被调整大小时触发的函数。
		*/
		override public function onResize(width:Number, height:Number):void {
			this.resized();
		}
	}

}