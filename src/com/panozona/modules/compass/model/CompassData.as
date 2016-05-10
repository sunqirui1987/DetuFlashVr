/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.compass.model {
	
	import com.panozona.modules.compass.model.structure.Close;
	import com.panozona.modules.compass.model.structure.Settings;
	import com.panozona.modules.compass.model.WindowData;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class CompassData {
		
		public const settings:Settings = new Settings();
		public const windowData:WindowData = new WindowData();
		public const close:Close = new Close();
		
		public function CompassData(moduleData:ModuleData, qjPlayer:Object) {
			
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "settings") {
					tarnslator.dataNodeToObject(dataNode, settings);
				}else if (dataNode.name == "window") {
					tarnslator.dataNodeToObject(dataNode, windowData.window);
				}else if (dataNode.name == "close") {
					tarnslator.dataNodeToObject(dataNode, close);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			windowData.open = windowData.window.open;
			
			if (qjPlayer.managerData.debugMode) {
				if (settings.path == null || !settings.path.match(/^(.+)\.(png|gif|jpg|jpeg)$/i)){
					throw new Error("Invalid bitmaps grid path: " + settings.path);
				}
				if (windowData.window.onOpen != null && qjPlayer.managerData.getActionDataById(windowData.window.onOpen) == null) {
					throw new Error("Action does not exist: " + windowData.window.onOpen);
				}
				if (windowData.window.onClose != null && qjPlayer.managerData.getActionDataById(windowData.window.onClose) == null) {
					throw new Error("Action does not exist: " + windowData.window.onClose);
				}
			}
		}
	}
}