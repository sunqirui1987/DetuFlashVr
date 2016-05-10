/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.menuscroller {
	
	import com.panozona.modules.menuscroller.controller.ShowViewController;
	import com.panozona.modules.menuscroller.controller.WindowController;
	import com.panozona.modules.menuscroller.model.MenuScrollerData;
	import com.panozona.modules.menuscroller.model.structure.ExtraElement;
	import com.panozona.modules.menuscroller.view.ElementView;
	import com.panozona.modules.menuscroller.view.ShowView;
	import com.panozona.modules.menuscroller.view.WindowView;
	import com.panozona.player.module.Module;
	import com.panozona.player.module.data.ModuleData;
	
	public class MenuScroller extends Module{
		
		public var menuScrollerData:MenuScrollerData;
		
		public var windowView:WindowView;
		public var windowController:WindowController;
		
		public var showView:ShowView;
		public var showViewController:ShowViewController;
		
		public function MenuScroller(){
			super("MenuScroller", "1.2.1", "http://ouwei.cn/wiki/Module:MenuScroller");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("setImmediatelyOpen", Boolean);
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("setActive", String);
			moduleDescription.addFunctionDescription("scroll", Number);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			menuScrollerData = new MenuScrollerData(moduleData, qjPlayer); // always first
			
			if(menuScrollerData.showViewItem){
				showView = new ShowView(menuScrollerData.showViewItem,menuScrollerData);
				addChild(showView);
				showViewController = new ShowViewController(showView, this);
			}
			
			windowView = new WindowView(menuScrollerData);
			windowController = new WindowController(windowView, this);
			addChild(windowView);
		}
		
///////////////////////////////////////////////////////////////////////////////
//  Exposed functions 
///////////////////////////////////////////////////////////////////////////////
		
		public function setOpen(value:Boolean):void {
			menuScrollerData.windowData.open = value;
		}
		public function setImmediatelyOpen(value:Boolean):void {
			windowView.visible = value;
		}
		
		public function toggleOpen():void {
			menuScrollerData.windowData.open = !menuScrollerData.windowData.open;
		}
		
		public function setActive(id:String):void {
			var elementView:ElementView;
			var found:Boolean = false;
			for (var i:int = 0; i < windowView.scrollerView.elementsContainer.numChildren; i++) {
				elementView = windowView.scrollerView.elementsContainer.getChildAt(i) as ElementView;
				if (elementView.elementData.rawElement is ExtraElement) {
					if((elementView.elementData.rawElement as ExtraElement).id == id) {
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
		
		public function scroll(scrollVal:Number):void{
			menuScrollerData.scrollerData.scrollVal = scrollVal;
		}
	}
}