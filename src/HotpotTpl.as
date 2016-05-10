
package  {
	
	 
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.system.ApplicationDomain;
	
	public class HotpotTpl extends Sprite {
		
		
		protected var sp:Object;
		
		public function HotpotTpl():void { // 1.
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			this.addEventListener(FullScreenEvent.FULL_SCREEN,fullscreenHandler);
			this.aa.bb.fullScreenTakeOver=false;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function fullscreenHandler(e:FullScreenEvent):void
		{
			this.aa.bb.fullScreenTakeOver=false;
			//stage.displayState=StageDisplayState.NORMAL;
		}
		
		public function references(sp:Object, hotspotDataSwf:Object):void { // 2.
		
			var s:Graphics = this.graphics;
			s.beginFill(0x000000,0.5);
			s.drawRect(0,0,100,100);
			s.endFill();
			this.sp = sp;
		}
		
		private function init(e:Event = null):void { // 3.
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if (sp == null ) {
				printError("No  reference.");
				return;
			}
			
			sp.manager.managerData.controlData.autorotationCameraData.enabled = false;
			sp.manager.addEventListener("panoramaStartedLoading", onPanoramaStartedLoading, false, 0 , true);
			
			
		}
		
		private function onPanoramaStartedLoading(e:Event):void {
			this.aa.bb.stop();
			sp.manager.managerData.controlData.autorotationCameraData.enabled = true;
			//while (numChildren) removeChildAt(0);
		}
		
		protected function printError(message:String):void {
			if (sp != null && ("traceWindow" in sp)) {
				sp.traceWindow.printError("AdvancedHotspot: " + message);
			}else{
				trace(message);
			}
		}
	}
}