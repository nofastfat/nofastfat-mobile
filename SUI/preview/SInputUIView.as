package {
	import com.xy.ui.SInputUI;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import fl.livepreview.LivePreviewParent;
	import flash.external.ExternalInterface;
	
	public class SInputUIView extends SInputUI {

		private var lp:LivePreviewParent;

		public function SInputUIView() {
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
			
			//this.resized();
		}
	}

}