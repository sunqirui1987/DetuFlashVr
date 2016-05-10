/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagemap{
	
	import com.panozona.modules.imagemap.controller.WindowController;
	import com.panozona.modules.imagemap.model.ImageMapData;
	import com.panozona.modules.imagemap.view.WindowView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import morn.core.handlers.Handler;
	
	public class ImageMap extends Module {
		
		public var imageMapData:ImageMapData;
		
		public var windowView:WindowView;
		public var windowController:WindowController;
		
		public function ImageMap() {

			super("ImageMap", "1.3", "http://ouwei.cn/wiki/Module:ImageMap");
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("setMap", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			imageMapData = new ImageMapData(moduleData, qjPlayer); // always first
			
			if(imageMapData.tab){
				App.init(this.qjPlayer as Sprite);
				App.loader.loadAssets(imageMapData.tab.skinUrls.split(","), new Handler(createUI));
			}else{
				createUI();
			}
		}
		
		private function createUI():void{
			windowView = new WindowView(imageMapData,this.qjPlayer.manager.managerData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			imageMapData.windowData.open = value;
		}
		
		public function toggleOpen():void {
			imageMapData.windowData.open = !imageMapData.windowData.open;
		}
		
		public function setMap(value:String):void {
			if(imageMapData.mapData.getMapById(value) != null){
				imageMapData.mapData.currentMapId = value;
			}else {
				printWarning("Invalid map id: " + value);
			}
		}
	}
}