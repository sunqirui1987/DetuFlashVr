/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.dropdown{
	
	import com.panozona.modules.dropdown.controller.WindowController;
	import com.panozona.modules.dropdown.model.DropDownData;
	import com.panozona.modules.dropdown.model.structure.ExtraElement;
	import com.panozona.modules.dropdown.view.ElementView;
	import com.panozona.modules.dropdown.view.WindowView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class DropDown extends Module{
		
		private var dropDownData:DropDownData;
		
		private var windowView:WindowView;
		private var windowController:WindowController;
		
		public function DropDown(){
			super("DropDown", "1.2", "http://ouwei.cn/wiki/Module:DropDown");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("setActive", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			dropDownData = new DropDownData(moduleData, qjPlayer);
			
			windowView = new WindowView(dropDownData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			dropDownData.windowData.open = value;
		}
		
		public function toggleOpen():void {
			dropDownData.windowData.open = !dropDownData.windowData.open;
		}
		
		public function setActive(id:String):void {
			var elementView:ElementView;
			var found:Boolean = false;
			for (var i:int = 0; i < windowView.boxView.elementsContainer.numChildren; i++) {
				elementView = windowView.boxView.elementsContainer.getChildAt(i) as ElementView;
				if (elementView.elementData.rawElement is ExtraElement) {
					if ((elementView.elementData.rawElement as ExtraElement).id == id) {
						elementView.elementData.isActive = true;
						found = true;
					}else {
						elementView.elementData.isActive = false;
					}
				}
			}
			if(!found){
				printWarning("ExtraElement not found: " + id);
			}
		}
	}
}