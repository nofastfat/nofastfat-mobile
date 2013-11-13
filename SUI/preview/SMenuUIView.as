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
		*当组件中改变参数时触发onUpdate，这时更新值
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