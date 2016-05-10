/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.imagegallery {
	
	import com.panozona.modules.imagegallery.controller.WindowController;
	import com.panozona.modules.imagegallery.model.ImageGalleryData
	import com.panozona.modules.imagegallery.model.WindowData;
	import com.panozona.modules.imagegallery.view.WindowView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class ImageGallery extends Module {
		
		private var imageGalleryData:ImageGalleryData;
		
		private var windowView:WindowView;
		private var windowController:WindowController;
		
		public function ImageGallery() {
			super("ImageGallery", "1.0", "http://ouwei.cn/wiki/Module:ImageGallery");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("toggleOpen", String);
			moduleDescription.addFunctionDescription("setGroup", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			imageGalleryData = new ImageGalleryData(moduleData, qjPlayer);
			windowView = new WindowView(imageGalleryData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			imageGalleryData.windowData.open = value;
		}
		
		public function toggleOpen():void {
			imageGalleryData.windowData.open = !imageGalleryData.windowData.open;
		}
		
		public function setGroup(value:String):void {
			if(imageGalleryData.viewerData.getGroupById(value) != null){
				imageGalleryData.viewerData.currentGroupId = value;
			} else {
				printWarning("Invalid group id: " + value);
			}
		}
	}
}