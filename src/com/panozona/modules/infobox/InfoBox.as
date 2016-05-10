/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.infobox{
	
	import com.panozona.modules.infobox.controller.WindowController;
	import com.panozona.modules.infobox.model.InfoBoxData;
	import com.panozona.modules.infobox.view.WindowView;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.Module;
	
	public class InfoBox extends Module {
		
		private var infoBoxData:InfoBoxData;
		
		private var windowView:WindowView;
		private var windowController:WindowController;
		
		public function InfoBox() {
			super("InfoBox", "1.0", "http://ouwei.cn/wiki/Module:InfoBox");
			moduleDescription.addFunctionDescription("toggleOpen");
			moduleDescription.addFunctionDescription("setOpen", Boolean);
			moduleDescription.addFunctionDescription("setArticle", String);
		}
		
		override protected function moduleReady(moduleData:ModuleData):void {
			
			infoBoxData = new InfoBoxData(moduleData, qjPlayer); // always first
			
			windowView = new WindowView(infoBoxData);
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
			infoBoxData.windowData.open = !infoBoxData.windowData.open;
		}
		
		public function setArticle(value:String):void {
			if(infoBoxData.articleData.getArticleById(value) != null){
				infoBoxData.articleData.currentArticleId = value;
			}else {
				printWarning("Invalid article id: " + value);
			}
		}
	}
}