/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.jsgooglemap {
	
	import com.panozona.modules.jsgooglemap.data.*;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	import flash.external.ExternalInterface;
	
	public class JSGoogleMap extends Module {
		
		private var __fov:Number = 0;
		private var __pan:Number = 0;
		private var currentDirection:Number = 0;
		
		private var panoramaEventClass:Class;
		
		private var jsGooglemapData:JSGoogleMapData;
		
		public function JSGoogleMap() {
			super("JSGoogleMap", "1.0", "http://ouwei.cn/wiki/Module:JSGoogleMap");
			
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("toggleOpen");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			jsGooglemapData = new JSGoogleMapData(moduleData, qjPlayer); // allways read data first 
			
			visible = false;
			
			// add listeners 
			panoramaEventClass = ApplicationDomain.currentDomain.getDefinition("com.panozona.player.manager.events.PanoramaEvent") as Class;
			qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onFirstPanoramaStartedLoading, false, 0, true);
			qjPlayer.manager.addEventListener(panoramaEventClass.PANORAMA_LOADED, onPanoramaLoaded, false, 0, true);
			stage.addEventListener(Event.ENTER_FRAME, onCameraMove, false, 0, true);
			
			ExternalInterface.addCallback("jsgm_in_loadPano", qjPlayer.manager.loadPano);
		}
		
		private function onFirstPanoramaStartedLoading(e:Event):void {
			qjPlayer.manager.removeEventListener(panoramaEventClass.PANORAMA_STARTED_LOADING, onFirstPanoramaStartedLoading);
			ExternalInterface.call("jsgm_out_init", new ToJSON().translate(jsGooglemapData));
			callActions();
		}
		
		private function onPanoramaLoaded(e:Event):void {
			__fov = qjPlayer.manager._fieldOfView;
			__pan = qjPlayer.manager._pan;
			currentDirection = qjPlayer.manager.currentPanoramaData.direction;
			ExternalInterface.call("jsgm_out_setPanorama", qjPlayer.manager.currentPanoramaData.id);
			ExternalInterface.call("jsgm_out_radarCallback", __fov, __pan + currentDirection);
		}
		
		private function onCameraMove(e:Event):void {
			if (__fov == qjPlayer.manager._fieldOfView && __pan == qjPlayer.manager._pan) return;
			__fov = qjPlayer.manager._fieldOfView;
			__pan = qjPlayer.manager._pan;
			ExternalInterface.call("jsgm_out_radarCallback", __fov, __pan + currentDirection);
		}
		
		private function callActions():void {
			if (jsGooglemapData.settings.open && jsGooglemapData.settings.onOpen) {
				qjPlayer.manager.runAction(jsGooglemapData.settings.onOpen);
			} 
			if(!jsGooglemapData.settings.open && jsGooglemapData.settings.onClose) {
				qjPlayer.manager.runAction(jsGooglemapData.settings.onClose);
			}
			ExternalInterface.call("jsgm_out_setOpen", jsGooglemapData.settings.open);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			if (jsGooglemapData.settings.open == value) return;
			jsGooglemapData.settings.open = value;
			callActions();
		}
		
		public function toggleOpen():void {
			jsGooglemapData.settings.open = !jsGooglemapData.settings.open;
			callActions();
		}
	}
}