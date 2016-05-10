/*
 OuWei Flash3DHDView 
*/
package com.panozona.modules.mousecursor.data{
	
	import com.panozona.player.module.data.ModuleData;
	import com.panozona.player.module.data.DataNode;
	import com.panozona.player.module.utils.DataNodeTranslator;
	
	public class MouseCursorData{
		
		public const settings:Settings = new Settings();
		
		public function MouseCursorData(moduleData:ModuleData, qjPlayer:Object){
			
			var tarnslator:DataNodeTranslator = new DataNodeTranslator(qjPlayer.managerData.debugMode);
			
			for each(var dataNode:DataNode in moduleData.nodes) {
				if (dataNode.name == "settings") {
					tarnslator.dataNodeToObject(dataNode, settings);
				}else {
					throw new Error("Invalid node name: " + dataNode.name);
				}
			}
			
			if (qjPlayer.managerData.debugMode) {
				if (settings.path == null || !settings.path.match(/^(.+)\.(png|gif|jpg|jpeg)$/i))
				throw new Error("Invalid bitmaps grid path: " + settings.path);
			}
		}
	}
}