/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.zoomslider.model{
	
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class ZoomSliderData {
		
		public const sliderData:SliderData = new SliderData();
		public const windowData:WindowData = new WindowData();
		
		public function ZoomSliderData(moduleData:ModuleData, qjPlayer:Object){
			
			var translator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "slider") {
					translator.dataNodeToObject(dataNode, sliderData.slider);
				}else if (dataNode.name == "window") {
					translator.dataNodeToObject(dataNode, windowData.window);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			windowData.open = windowData.window.open;
			if (sliderData.slider.length < 0) sliderData.slider.length = 0;
			
			if (qjPlayer.managerData.debugMode) {
				if (sliderData.slider.path == null || !sliderData.slider.path.match(/^(.+)\.(png|gif|jpg|jpeg)$/i)) {
					throw new Error("Invalid path: " + sliderData.slider.path);
				}
			}
		}
	}
}