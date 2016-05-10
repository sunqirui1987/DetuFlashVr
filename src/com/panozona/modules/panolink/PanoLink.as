/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.panolink{
	
	import com.panozona.modules.panolink.controller.WindowController;
	import com.panozona.modules.panolink.model.PanoLinkData;
	import com.panozona.modules.panolink.view.WindowView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class PanoLink extends Module{
		
		private var windowView:WindowView;
		private var windowController:WindowController;
		
		private var panoLinkData:PanoLinkData;
		
		public function PanoLink(){
			super("PanoLink", "1.1", "http://ouwei.cn/wiki/Module:PanoLink");
			
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("toggleOpen");
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			panoLinkData = new PanoLinkData(moduleData, qjPlayer);
			
			windowView = new WindowView(panoLinkData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			if (value == panoLinkData.windowData.open) return;
			panoLinkData.windowData.open = value;
		}
		
		public function toggleOpen():void {
			panoLinkData.windowData.open = !panoLinkData.windowData.open;
		}
	}
}