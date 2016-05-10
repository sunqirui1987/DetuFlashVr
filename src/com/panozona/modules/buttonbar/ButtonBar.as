/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.buttonbar {
	
	import com.panozona.modules.buttonbar.controller.WindowController;
	import com.panozona.modules.buttonbar.model.ButtonBarData;
	import com.panozona.modules.buttonbar.view.ButtonView;
	import com.panozona.modules.buttonbar.view.WindowView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class ButtonBar extends Module{
		
		public var buttonBarData:ButtonBarData;
		
		public var windowView:WindowView;
		public var windowController:WindowController;
		
		public function ButtonBar(){
			super("ButtonBar", "1.3", "http://ouwei.cn/wiki/Module:ButtonBar");
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("setActive", String, Boolean);
			moduleDescription.addFunctionDescription("toggleActive", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			buttonBarData = new ButtonBarData(moduleData, qjPlayer);
			
			windowView = new WindowView(buttonBarData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
		}
		
///////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			buttonBarData.windowData.open = value;
		}
		
		public function toggleOpen():void {
			buttonBarData.windowData.open = !buttonBarData.windowData.open;
		}
		
		public function setActive(name:String, active:Boolean):void {
			if (name == "a" || name == "b" || name == "c" || name == "d" || name == "e" ||
				name == "f" || name == "g" || name == "h" || name == "i") {
				var buttonView:ButtonView;
				for (var i:int = 0; i < windowView.barView.buttonsContainer.numChildren; i++) {
					buttonView = windowView.barView.buttonsContainer.getChildAt(i) as ButtonView;
					if (buttonView.buttonData.button.name == name) {
						buttonView.buttonData.isActive = active;
						return;
					}
				}
			}else {
				printWarning("Invalid extraButton name: " + name);
			}
		}
		
		public function toggleActive(name:String):void {
			if (name == "a" || name == "b" || name == "c" || name == "d" || name == "e" ||
				name == "f" || name == "g" || name == "h" || name == "i") {
				var buttonView:ButtonView;
				for (var i:int = 0; i < windowView.barView.buttonsContainer.numChildren; i++) {
					buttonView = windowView.barView.buttonsContainer.getChildAt(i) as ButtonView;
					if (buttonView.buttonData.button.name == name) {
						buttonView.buttonData.isActive = !buttonView.buttonData.isActive;
						return;
					}
				}
			}else {
				printWarning("Invalid extraButton name: " + name);
			}
		}
	}
}