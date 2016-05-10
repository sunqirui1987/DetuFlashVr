/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.compass {
	
	import com.panozona.modules.compass.controller.WindowController;
	import com.panozona.modules.compass.model.CompassData;
	import com.panozona.modules.compass.view.WindowView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class Compass extends Module {
		
		private var compassData:CompassData;
		
		private var windowView:WindowView;
		private var windowController:WindowController;
		
		public function Compass() {
			super("Compass", "1.2", "http://ouwei.cn/wiki/Module:Compass");
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			compassData = new CompassData(moduleData, qjPlayer); // always first
			
			windowView = new WindowView(compassData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			compassData.windowData.open = value;
		}
		
		public function toggleOpen():void {
			compassData.windowData.open = !compassData.windowData.open;
		}
	}
}