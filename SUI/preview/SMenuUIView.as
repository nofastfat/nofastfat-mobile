package {
	import com.xy.ui.SMenuUI;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import fl.livepreview.LivePreviewParent;
	import flash.external.ExternalInterface;
	
	public class SMenuUIView extends SMenuUI {

		private var lp:LivePreviewParent;

		public function SMenuUIView() {
			lp = new LivePreviewParent  ;
			lp.myInstance = this;
		}

		/**
		*������иı����ʱ����onUpdate����ʱ����ֵ
		*/
		public function onUpdate(e:Event):void {
			
			//this.initIconUp();
			//this.initIconDown();
			//this.initMenuLen();
			//this.resized();
		}

		public function onResize(...rest):void{
			//this.resized();
		}


	}

}