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
		*������иı����ʱ����onUpdate����ʱ����ֵ
		*/
		public function onUpdate(e:Event):void {
			this.updateTf();
		}

		/**
		*�������������Сʱ�����ĺ�����
		*/
		override public function onResize(width:Number, height:Number):void {
			this.resized();
		}
	}

}