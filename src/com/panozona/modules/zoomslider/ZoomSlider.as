/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.zoomslider{
	
	import com.panozona.modules.zoomslider.controller.WindowController;
	import com.panozona.modules.zoomslider.model.ZoomSliderData;
	import com.panozona.modules.zoomslider.view.WindowView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class ZoomSlider extends Module{
		
		private var windowView:WindowView;
		private var windowController:WindowController;
		
		private var zoomSliderData:ZoomSliderData;
		
		public function ZoomSlider():void{
			super("ZoomSlider", "1.1", "http://ouwei.cn/wiki/Module:ZoomSlider");
			
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("toggleOpen");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			zoomSliderData = new ZoomSliderData(moduleData, this.qjPlayer);
			windowView = new WindowView(zoomSliderData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			if (value == zoomSliderData.windowData.open) return;
			zoomSliderData.windowData.open = value;
		}
		
		public function toggleOpen():void {
			zoomSliderData.windowData.open = !zoomSliderData.windowData.open;
		}
	}
}