package {
	import com.xy.ui.SSearchUI;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import fl.livepreview.LivePreviewParent;
	import flash.external.ExternalInterface;
	
	public class SSearchUIView extends SSearchUI {

		private var lp:LivePreviewParent;

		public function SSearchUIView() {
			lp = new LivePreviewParent  ;
			lp.myInstance = this;
		}

		/**
		*������иı����ʱ����onUpdate����ʱ����ֵ
		*/
		public function onUpdate(e:Event):void {
			this.initName();
		}

		/**
		*�������������Сʱ�����ĺ�����
		*/
		public function onResize(wid:Number,hei:Number):void {
			this.initName();
		}
	}

}